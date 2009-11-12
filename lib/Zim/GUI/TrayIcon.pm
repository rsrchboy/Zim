package Zim::GUI::TrayIcon;

use strict;
use Gtk2;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.26';
our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI::TrayIcon - TrayIcon widget for zim

=head1 DESCRIPTION

This module adds an icon in the system tray for zim that implement
"minimise to tray". This way you can always have zim running in the
background.

The context menu for the tray icon lists all pages in the current
history stack.

To use this module you need either Gtk2::StatusIcon (gtk+ >= 2.10)
or Gtk2::TrayIcon (can be found on CPAN).

This module supports multiple instances of zim now, but also shows the old
behavior when running with "--no-daemon". This means that we can run both
as a object within a zim instance and as a seperate process serving multiple
instances.

=head1 EXPORT

None by default.

=head1 METHODS

=over 4

=item C<run()>

If we run as a separate process, this will be called to initalize.
Always asssumes L<Zim::GUI::Daemon> to be used.

=cut

sub run {
	my $class = shift;
	Gtk2->init;

	my $object = $class->new(use_daemon => 1);
	Glib::IO->add_watch ( fileno(STDIN), ['in', 'hup'], sub {
		my ($fileno, $condition) = @_;
		return 0 if $condition eq 'hup'; # uninstall
		my $line = <STDIN>;
		Gtk2->main_quit if $line =~ /^Close FORCE/;
		return 1;
	} );
	warn "## Running TrayIcon with PID $$\n";

	Gtk2->main;
}

=item C<new(app => PARENT)>

Simple constructor.

=cut

sub init {
	my $self = shift;

	my ($name, $icon);
	if ($$self{use_daemon}) {
		$name = 'Zim';
		$icon = Gtk2::Gdk::Pixbuf->new_from_file($Zim::ICON);
	}
	else {
		# Either we run without a daemon or the user
		# prefers individual tray icons per notebook
		$name = $$self{app}{notebook}{name};
		$icon = $$self{app}->get_icon;
	}
	
	my $widget = eval { Gtk2::StatusIcon->new_from_pixbuf($icon) };
	if ($@) {
		# StatusIcon new in gtk 2.10 and not always available
		$widget = $self->_init_trayicon($name, $icon) if $@;
	}
	else {
		$widget->set_tooltip($name);
		$widget->signal_connect_swapped(
			popup_menu => \&popup_menu, $self );
		$widget->signal_connect_swapped(
			activate => \&toggle_hide_window, $self );
		$widget->set_visible(1);
		warn "# StatusIcon not embedded - no system tray ?\n"
			unless $widget->is_embedded;

	}
	$$self{icon_widget} = $widget;
		# Keep reference to avoid destructionof this object.
		# Explicitly not using {widget} here because this
		# object does not derive from Gtk2::Widget .
}

sub _init_trayicon {
	# Default to using the Gtk2::TrayIcon module if possible. This module
	# is deprecated by the Gtk2::StatusIcon class in gtk 2.10, but is
	# needed for this functionality when using 2.4 or 2.6 .
	my ($self, $name, $icon) = @_;

	eval 'use Gtk2::TrayIcon';
	die 'Could not load Gtk2::StatusIcon nor Gtk2::TrayIcon' if $@;
	warn "## Using Gtk2::TrayIcon instead of Gtk2::StatusIcon\n";

	my $widget= Gtk2::TrayIcon->new("Zim ($$)");
	my $box = Gtk2::EventBox->new;
	$box->set_visible_window(0);
	$box->set_above_child(1);
	my $iconset = Gtk2::IconSet->new_from_pixbuf($icon);
	my $image = Gtk2::Image->new_from_icon_set($iconset, 'large-toolbar');
	$box->add($image);
	my $tooltips = Gtk2::Tooltips->new;
	$tooltips->set_tip($box, $name);
	$box->signal_connect_swapped(
		button_press_event => \&on_button_press_event, $self);
	$box->signal_connect_swapped(popup_menu => \&popup_menu, $self);
	$widget->add($box);
	$widget->show_all;
}

sub on_button_press_event {
	my ($self, $event) = @_;
	return unless $event->type eq 'button-press';
	if ($event->button == 1) {
		$self->toggle_hide_window;
	}
	elsif ($event->button == 3) {
		$self->popup_menu($event);
	}
	return 1;
}

=item C<toggle_hide_window()>

Hides the main window of zim if it was visible or unhides it if it
it was invisible.

=cut

sub toggle_hide_window {
	my $self = shift;
	if ($$self{use_daemon}) {
		# potentially multiple instances
		my @list = Zim::GUI::Daemon->list;
		if (@list == 0) {
			$self->call_daemon('open', '_new_');
		}
		elsif (@list == 1) {
			$self->call_daemon('tell', $list[0][1], 'ToggleWindow');
		}
		else { $self->popup_menu() }
	}
	else {
		# single instance
		$$self{app}->is_active
			? $$self{app}->HideWindow
			: $$self{app}->ShowWindow ;
	}
}

=item C<popup_menu(EVENT)>

Show a popup menu. EVENT is optional.

=cut

sub popup_menu {
	my $self = shift;
	my $button = shift || 0;
	my $time = shift || 0;
	($button, $time) = ($button->button, $button->time)
		if ref $button; # button was event object

	my $menu = Gtk2::Menu->new();

	if ($$self{use_daemon}) {
		# list of Notebooks
		my @list = Zim::GUI::Daemon->list;
		for my $notebook (@list) { # list of [NAME, PATH]
			_item($menu, $$notebook[0], sub {
				$self->call_daemon('tell', $$notebook[1],
					'ToggleWindow' );
			} );
		}
		
		_separator($menu) if @list;

		# Other...
		_item($menu, __('Other...'), sub { #. menu item "Other notebook"
			$self->call_daemon('open', '_new_');
		} );
	}
	else {
		# single instance
		$self->_page_menu($menu);
	}

	_separator($menu);
	
	# Quit
	my $quit = $$self{use_daemon}
		? sub {
			$self->call_daemon('broadcast', 'Close', 'FORCE');
			$self->call_daemon('main_quit');
			Gtk2->main_quit;
		}
		: sub { $$self{app}->Quit } ;
	_stock_item($menu, 'gtk-quit', $quit);
	

	$menu->show_all;
	
	# TODO use Gtk2::StatusIcon::position_menu here
	$menu->popup(undef, undef, undef, undef, $button, $time);
}

sub _separator {
	my $menu = shift;
	my $item = Gtk2::SeparatorMenuItem->new();
	$menu->add($item);
}

sub _item {
	my ($menu, $label, $code) = @_;
	my $item = Gtk2::ImageMenuItem->new_with_label($label);
	$item->signal_connect(activate => $code);
	$menu->add($item);
	return $item;
}

sub _stock_item {
	my ($menu, $stock, $code) = @_;
	my $item = Gtk2::ImageMenuItem->new_from_stock($stock);
	$item->signal_connect(activate => $code);
	$menu->add($item);
	return $item;
}

sub _page_menu {
	# Menu that shows various pages and the search function.
	# Can only be used for a single instance.
	my ($self, $menu) = @_;

	# Home
	_stock_item($menu, 'gtk-home', sub { $$self{app}->GoHome } );
	
	_separator($menu);
	
	# Search
	_item($menu, __('Search'), sub { $self->{app}->SearchDialog->show } ); #. menu item

	_separator($menu);
	
	# History pages
	my $hist = $self->{app}{history};
	my ($idx, @recent) = $hist ? $hist->get_recent : ();
	for (reverse 0 .. $#recent) {
		my $rec = $recent[$_];
		my $item = _item($menu, $$rec{basename}, sub {
			my $r = $$self{app}{history}->jump($$rec{name});
			$$self{app}->load_page($r);
		} );
		$item->set_image(
			Gtk2::Image->new_from_stock('gtk-yes', 'menu') )
			if $_ == $idx ;
	}
	
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

