package Zim::GUI::PreferencesDialog;

use strict;
use File::BaseDir qw/data_dirs/;
use Gtk2;
use Gtk2::SimpleList;
use Zim::Utils;

our $VERSION = '0.29';

=head1 NAME

Zim::GUI::PreferencesDialog - dialog for zim

=head1 DESCRIPTION

This module contains the preferences dialog for zim.
It is autoloaded when needed.

=head1 METHODS

=over 4

=item C<new()>

Simple constructor

=cut

sub new {
	my ($class, %self) = @_;
	bless \%self, $class;
}

=item C<show()>

Present the dialog.

=cut

my %Labels = ( # setting => [label, tooltip]
	browser => [
		__('Web browser'), #. pref. label
		__("Application to open urls"), #. pref. tooltip
	],
	file_browser => [
		__('File browser'), #. pref. label
		__("Application to open directories"), #. pref. tooltip
	],
	email_client => [
		__('Email client'), #. pref. label
		__("Application to compose email"), #. pref. tooltip
	],
	text_editor => [
		__('Text editor'), #. pref. label
		__("Application to edit text files"), #. pref. tooltip
	],
	diff_editor => [
		__('Diff editor'), #. pref. label
		__("Application show two text files side by side"), #. pref. tooltip
	],
	user_name => [
		__('User name'), #. pref. label
		__("Your name; this can be used in export templates"), #. pref. tooltip
	],
	follow_new_link => [
		__('Follow new link'), #. pref. label
		__("Creating a new link directly opens the page"), #. pref. tooltip
	],
	ro_cursor => [
		__('Show cursor for read-only'), #. pref. label
		__("Show the cursor even when you can not edit the page. This is useful for keyboard based browsing."), #. pref. tooltip
	],
	tearoff_menus => [
		__('Tearoff menus'), #. pref. label
		__("Add 'tearoff' strips to the menus"), #. pref. tooltip
	],
	use_camelcase => [
		__('Auto-link CamelCase'), #. pref. label
		__("Automaticly link CamelCase words when you type"), #. pref. tooltip
	],
	use_linkfiles => [
		__('Auto-link files'), #. pref. label
		__("Automatically link file names when you type"), #. pref. tooltip
	],
	use_utf8_ent => [
		__('Auto-format entities'), #. pref. label
		__("Use autoformatting to type special characters"), #. pref. tooltip
	],
	use_autoincr => [
		__('Auto-increment numbered lists'), #. pref. label
		__('Automatically increment items in a numbered list'), #. pref. tooltip
	],
	use_recurscheck => [
		__('Check checkbox lists recursive'), #. pref. label
		__('Checking a checkbox list item will also check any sub-items'), #. pref. tooltip
	],
	backsp_unindent => [
		__('Use "Backspace" to un-indent'), #. pref. label
		__("Use the \"Backspace\" key to un-indent bullet lists (Same as \"Shift-Tab\")"), #. pref. tooltip
	],
	use_autoselect => [
       		__('Auto-select words'), #. pref. label
		__("Automaticly select the current word when you toggle the format"), #. pref. tooltip
	],
	follow_on_enter => [
		__('Use "Enter" to follow links'), #. pref. label
		__("Use the \"Enter\" key to follow links. If disabled you still can use \"Alt-Enter\""), #. pref. tooltip
	],
	use_ctrl_space => [
		__('Use "Ctrl-Space" to switch focus'), #. pref. label
		__("Use the \"Ctrl-Space\" key combo to switch focus between text and side pane. If disabled you can still use \"Alt-Space\"."), #. pref. tooltip
	],
	expand_tree => [
		__('Expand side pane'), #. pref. label
		__("Start the side pane with the whole tree expanded."), #. pref. tooltip
	],
	use_ucfirst_title => [
		__('Uppercase Title'), #. pref. label
		__("Set first character to uppercase if title contains no uppercase character."), #. pref. tooltip
	],
);

sub show {
	my $self = shift;
	my $app = $self->{app};
	my $dialog = Gtk2::Dialog->new(
		__("Preferences"), $app->{window}, #. dialog title
	       	[qw/destroy-with-parent no-separator/],
		'gtk-help'   => 'help',
		'gtk-cancel' => 'cancel',
		'gtk-ok'     => 'ok',
	);
	$dialog->set_resizable(0);
	
	## Set up content
	my %entries;
	my %checkboxes;
	my $settings = $self->{app}{settings};
	my $tooltips = Gtk2::Tooltips->new;

	my $_prompt = sub { # new left aligned label
		my $key = shift;
		my $align = Gtk2::Alignment->new(0,0.5, 0,0);
		my $label = Gtk2::Label->new($Labels{$key}[0].':');
		$align->add($label);
		return $align;
	};
	my $_entry = sub { # new entry
		my $key = shift;
		my $entry = Gtk2::Entry->new();
		$entries{$key} = $entry;
		$entry->set_text($$settings{$key});
		$tooltips->set_tip($entry, $Labels{$key}[1])
			if defined $Labels{$key}[1];
		return $entry;
	};
	my $_checkbox = sub { # new checkbox
		my $key = shift;
		my $box = Gtk2::CheckButton->new_with_label($Labels{$key}[0]);
		$checkboxes{$key} = $box;
		$box->set_active($$settings{$key});
		$tooltips->set_tip($box, $Labels{$key}[1])
			if defined $Labels{$key}[1];
		return $box;
	};

	my $tabs = Gtk2::Notebook->new;
	$dialog->vbox->add($tabs);
	
	## General tab
	my $vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(5);
	$tabs->append_page($vbox, __('General')); #. tab label
	
	my @settings = qw/
		user_name
		browser
		file_browser
		email_client
		text_editor
		diff_editor
	/;
	my $table = Gtk2::Table->new(scalar(@settings), 2);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);
	$vbox->pack_start($table,0,1,0);
	my $i = 0;
	for (@settings) {
		$table->attach_defaults($_prompt->($_), 0,1, $i,$i+1);
		$table->attach_defaults($_entry->($_), 1,2, $i,$i+1);
		$i++;
	}

	## Interface tab
	$vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(5);
	$tabs->append_page($vbox, __('Interface')); #. tab label
	
	@settings = qw/
		follow_on_enter
		follow_new_link
		use_ctrl_space
		ro_cursor
		tearoff_menus
		expand_tree
	/;
	for (@settings) {
		$vbox->pack_start($_checkbox->($_), 0,1,0);
	}

	$table = Gtk2::Table->new(3, 2);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);
	$vbox->pack_start($table,0,1,0);
	$i = 0;

	# Font button
	my $use_font = Gtk2::CheckButton->new_with_label(
		__('Use custom font') ); #. check box
	$table->attach_defaults($use_font, 0,2, $i,$i+1);
	$i++;
	$use_font->set_active($$settings{textfont});
	my $font = $$settings{textfont} ||
		$app->PageView->get_style->font_desc->to_string;
	#warn "font: $font\n";
	my $font_button = Gtk2::FontButton->new_with_font($font);
	$font_button->signal_connect(font_set => sub {
		my $string = $font_button->get_font_name;
		$$settings{textfont} = $string;
		$app->PageView->set_font($string);
	} );
	$table->attach_defaults($font_button, 1,2, $i,$i+1);
	$i++;
	$font_button->set_sensitive($use_font->get_active);
	$use_font->signal_connect(toggled => sub {
		my $active = $use_font->get_active;
		$font_button->set_sensitive($active);
		unless ($active) {
			$$settings{textfont} = undef;
			$app->PageView->set_font(undef);
		}
	} );

	## Editing tab
	$vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(5);
	$tabs->append_page($vbox, __('Editing')); #. tab label
	@settings = qw/
		use_camelcase
		use_linkfiles
		use_utf8_ent
		use_autoincr
		use_autoselect
		backsp_unindent
		use_recurscheck
		use_ucfirst_title
	/;
	$table = Gtk2::Table->new(scalar(@settings), 1);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);
	$vbox->pack_start($table, 0,1,0);
	$i = 0;
	for (@settings) {
		$table->attach_defaults($_checkbox->($_), 0,1, $i,$i+1);
		$i++;
	}

	## Plugins tab
	$vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(5);
	$tabs->append_page($vbox, __('Plugins')); #. tab label

	my $label = Gtk2::Label->new();
	$label->set_markup(
		'<i>'.__("You need to restart the application\nfor plugin changes to take effect.").'</i>');
	$vbox->pack_start($label, 0,1,0);
	my @plugins;
	my @plugged = split /,/, $$settings{plugins};
	for my $dir (data_dirs('zim', 'plugins')) {
		for my $f (dir($dir)->list) {
			next unless $f =~ s/\.pl$//;
			next if grep {$$_[1] eq $f} @plugins;
			my $bit = grep {$_ eq $f} @plugged;
			push @plugins, [$bit, $f];
		}
	}
	@plugins = sort {$$a[1] cmp $$b[1]} @plugins;
	
	my $plugin_list = Gtk2::SimpleList->new(
		__('Enabled') => 'bool',   #. header plugin list
		__('Name')    => 'text' ); #. header plugin list
	@{$plugin_list->{data}} = @plugins;
	my $win = Gtk2::ScrolledWindow->new();
	$win->set_policy('automatic', 'automatic');
	$win->set_shadow_type('in');
	$win->add($plugin_list);
	$vbox->add($win);


	## Show it all
	$dialog->show_all;
	while ($_ = $dialog->run) {
		if ($_ eq 'help') {
			$app->ShowHelp(':usage:preferences');
			next;
		}
		last unless $_ eq 'ok';
		
		# set setting
		for (keys %entries) {
			$$settings{$_} = $entries{$_}->get_text;
		}
		for (keys %checkboxes) {
			$$settings{$_} = $checkboxes{$_}->get_active ? 1 : 0;
			#warn "$_ = $$settings{$_}\n";
		}

		# set plugins
		@plugged = map $$_[1], grep $$_[0], @{$plugin_list->{data}};
		$$settings{plugins} = join ',', @plugged;

		$app->SaveSettings('NOTIFY');
		last;
	}
	$dialog->destroy;
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

