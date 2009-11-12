
package Zim::GUI::Calendar;

use strict;
use vars qw/$CODESET/;
use POSIX qw(strftime);
use Encode;
use Gtk2::Gdk::Keysyms;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.26';
our @ISA = qw/Zim::GUI::Component/;

*CODESET = \$Zim::CODESET;
$CODESET ||= 'utf8';

=head1 NAME

Zim::GUI::Calendar - Calendar widget for zim

=head1 DESCRIPTION

This package implements a calendar dialog. It links each date to a page.

=head1 METHODS

=over 4

=item C<new(app => PARENT)>

Simple constructor.

=cut

my $check_backward = undef;

my ($k_return, $k_kp_enter, $k_space, $k_escape)
	= @Gtk2::Gdk::Keysyms{qw/Return KP_Enter space Escape/};

sub init {
	my $self = shift;
	my $app = $self->{app};

	## Init settings
	## plugin script already sets defaults and resolves namespace
	$self->init_settings('Calendar Plugin');
	$$self{namespace} = $$self{settings}{Namespace};

	## Construct the dialog
	my $dialog = Gtk2::Dialog->new(
		__('Calendar'), $self->{app}{window}, #. dialog title
	       	[qw/destroy-with-parent no-separator/],
	);
	$dialog->set_resizable(0);
	$dialog->signal_connect(delete_event => sub {
			$self->{app}{actions}->get_action('TCalendar')->set_active(0);
			return 1;
		} );
	$dialog->vbox->set_spacing(5);
	$self->{window} = $dialog;

	my $fmt = __("%a %b %e %Y"); #. strftime format for current date - default suggested in perldoc localtime
	my $label = Gtk2::Label->new( Encode::decode($CODESET,
		Zim::Utils::strftime($fmt, localtime)) );
		# Neest Zim::Utils::strftime here because of non-portable %e
		# in the format. Also format can be translated.
	Glib::Timeout->add(60_000, sub {
			return 0 unless $dialog->visible;
			$label->set_text( Encode::decode($CODESET,
					Zim::Utils::strftime($fmt, localtime)) );
			return 1;
		} );
		# check once every minute whether the day didn't change
	$dialog->vbox->add($label);

	my $calendar = Gtk2::Calendar->new();
	$calendar->display_options (
		[qw/show-heading show-day-names show-week-numbers/] );
	$dialog->vbox->add($calendar);
	$self->{widget} = $calendar;

	$calendar->signal_connect(key_press_event => \&on_key_press_event, $self);
	$calendar->signal_connect(button_press_event => \&on_button_press_event, $self);
	$calendar->signal_connect(day_selected => \&on_day_selected_tmp, $self);
	$calendar->signal_handlers_block_by_func(\&on_day_selected_tmp);
	$calendar->signal_connect(day_selected_double_click => \&on_day_selected, $self);
	$calendar->signal_connect(month_changed => \&on_month_changed, $app);
	
	$app->signal_connect('page_loaded' => \&on_page_loaded);

	my $hbox = Gtk2::HBox->new(0,0);
	$dialog->vbox->pack_start($hbox, 0,1,0);
	my $today_button = Gtk2::Button->new(__('_Today')); #. button
	$hbox->pack_end($today_button, 0,1,0);
	$today_button->signal_connect( clicked => sub {
		my ($day, $month, $year) = (localtime)[3,4,5];
		$year += 1900;
		$calendar->select_month($month, $year);
		$calendar->select_day($day);
	} );
}

sub on_key_press_event {
	my ($cal, $event, $self) = @_;
	my $val = $event->keyval;
	if ($val == $k_return or $val == $k_kp_enter) { # Enter
		# TODO trigger space keybinding on calendar widget
	}
	elsif ($val == $k_space) { # Space
		$cal->signal_handlers_unblock_by_func(\&on_day_selected_tmp);
	}
	elsif ($val == $k_escape) {
		$self->{app}{actions}->get_action('TCalendar')->set_active(0);
		return 1;
	}
	return 0; 
}

sub on_button_press_event {
	my ($cal, $event, $self) = @_;
	return unless $event->type eq 'button-press';
	$cal->signal_handlers_unblock_by_func(\&on_day_selected_tmp)
		if $event->button == 1;
	return 0;
}

sub on_day_selected { $_[1]->load_date( reverse $_[0]->get_date ) }

sub on_day_selected_tmp {
	$_[0]->signal_handlers_block_by_func(\&on_day_selected_tmp);
	goto &on_day_selected;
}

sub on_month_changed {
	my ($cal, $app) = @_;
	my $self = $app->Calendar;
	$cal->clear_marks;
	
	my ($year, $month, $day) = $cal->get_date;
	$year -= 1900;
	my $string = strftime('%Y_%m', 0, 0, 0, $day, $month, $year);
#	warn "Looking for $string in $$self{namespace}\n";

	# List top level namespace - backward compat
	if ($check_backward) {
		for ($$app{notebook}->list_pages($$self{namespace})) {
#			warn "$_\n";
			/^$string\_(\d{2})$/ or next;
			$cal->mark_day($1);
#			warn "Marked $1\n";
		}
	}

	# List namespace for specific month
	my $ns = $$self{namespace}
		. strftime('%Y:%m:', 0, 0, 0, $day, $month, $year);
	for ($app->{notebook}->list_pages($ns)) {
#		warn "$_\n";
		/^(\d{2})$/ or next;
		$cal->mark_day($1);
#		warn "Marked $1\n";
	}
	
}

sub on_page_loaded {
	my ($app, $page) = @_;
	my $self = $app->Calendar;
#	warn "Comparing $page wiht $$self{namespace}\n";
	$page =~ /^:*\Q$$self{namespace}\E:*(\d{4})[:_](\d{2})[:_](\d{2})/
		or return;
		# regex matches both in "_" seperated and ":" seprated
		# "_" separated is for backward compatibility 
	my ($day, $month, $year) = ($3, $2, $1);
	$month -= 1; # 0 based
	$self->select_month($month, $year);
	$self->select_day($day);
}

=item C<visible()>

Returns whether the calendar is visible.

=cut

sub visible { $_[0]->{window}->visible }

=item C<show()>

Show the calendar.

=cut

sub show {
	my $self = shift;

	## Check if we need to backwards compatible
	$self->_check_backward_compat()
		unless defined $check_backward;

	# restore window to old position - do this twice to try
	# to prevent visible window move, doesn't work for each WM
	my $w = $self->{window};
	$w->set_no_show_all(0);
	$w->move( @{$self->{position}} ) if $self->{position};
	$w->show_all;
	$w->move( @{$self->{position}} ) if $self->{position};

	# load content
	&on_page_loaded($self->{app}, $self->{app}{page}->name);
	&on_month_changed($self->{widget}, $self->{app});
}

=item C<hide()>

Hide the calendar.

=cut

sub hide {
	my $self = shift;
	my $w = $self->{window};
	$self->{position} = [ $w->get_position ];
	$w->hide_all;
	$w->set_no_show_all(1);
}

=item C<load_date(DAY, MONTH, YEAR)>

Load the zim page coresponding to this date.

=cut

sub load_date {
	my ($self, $day, $month, $year) = @_;
	#warn "User selected: $day, $month, $year\n";
	$year -= 1900;
	my $notebook = $$self{app}{notebook};

	# First check existence of "_" separated page - backward compat
	# we do not check $backwards_compat here because that is only
	# set after calendar is displayed for first time. This method
	# can be called earlier.
	my $name = $$self{namespace}
		. strftime('%Y_%m_%d', 0, 0, 0, $day, $month, $year);
	$name = $notebook->resolve_name($name);
	my $page = $notebook->get_page($name);
	return $$self{app}->load_page($page) if $page->exists;

	# Default to page in namespace per month
	$name = $$self{namespace}
		. strftime('%Y:%m:%d', 0, 0, 0, $day, $month, $year);
	$name = $notebook->resolve_name($name);
	$$self{app}->load_page($name);
}

# This sub checks if we have pages using the old naming sheme
# using :Date:yyyy_mm_dd instead of :Data:yyyy:mm:dd
# If this is the case and this is the first time we check ask
# the user if he wants to upgrade. If this is not the first
# time just keep backward compatibility where possible.

sub _check_backward_compat {
	my $self = shift;
	my $notebook = $$self{app}{notebook};

	# Check if we have pages in old format
	for ($notebook->list_pages($$self{namespace})) {
		next unless /^\d{4}_\d{2}_\d{2}/;
		$check_backward = 1; # declared in package
		last;
	}
	$check_backward ||= 0; # once defined we do not repeat this check
	warn "## Detected Date pages in format < 0.24\n";
	return if ! $check_backward
	       or $$self{app}{state}{did_calendar_backwards_check};
	
	# Prompt the user to ask what he wants to do
	my $r = $self->prompt_question( 'question',
		__("<b>Upgrade calendar pages to 0.24 format?</b>\n\nThis notebook contains pages for dates using the format yyyy_mm_dd.\nSince Zim 0.24 the format yyyy:mm:dd is used by default, creating\nnamespaces per month.\n\nDo you want to upgrade this notebook to the new layout?\n"), #. question dialog, answers are 'yes', 'no' or 'not now'
		[nn => undef, __('Not Now')], #. button
		[no => 'gtk-no'],
		[yes => 'gtk-yes'],
	);
	$$self{app}{state}{did_calendar_backwards_check} = 1 unless $r eq 'nn';
	return unless $r eq 'yes';

	# Move all pages that look like dates
	for my $name ($notebook->list_pages($$self{namespace})) {
		next unless $name =~ /^(\d{4})_(\d{2})_(\d{2})/;
		my ($y, $m, $d) = ($1, $2, $3);
		next if $name =~ /:$/; # we can not move namespaces :(
		my $old = $notebook->get_page($$self{namespace}.$name);
		my $new = $notebook->get_page($$self{namespace}."$y:$m:$d");
		warn "Moving $old => $new\n";
		$notebook->move_page($old => $new);
	}
	$check_backward = 0;
}


1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

