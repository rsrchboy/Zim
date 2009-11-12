package Zim::GUI::FindReplaceDialog;

use strict;
use Gtk2;
use Zim::Utils;

our $VERSION = '0.24';

=head1 NAME

Zim::GUI::FindReplaceDialog - simple module

=head1 METHODS

=over 4

=item C<new()>

Simple constructor

=cut

sub new {
	my ($class, %self) = @_;
	bless \%self, $class;
}

=item C<show(STRING)>

Show the dialog.
STRING is an optional query string.

=cut

sub show {
	my $self = shift;
	my $query = shift;
	
	if (defined $self->{dialog}) {
		$self->{dialog}->present;
		$self->{find_entry}->set_text($query) if length $query;
		return;
	}
	
	## Setup dialog
	my $dialog = Gtk2::Dialog->new(
		__('Find and Replace'), $self->{app}{window}, #. dialog title
		[qw/destroy-with-parent no-separator/],
		'gtk-help'  => 'help',
		'gtk-close' => 'close',
	);
	$dialog->set_resizable(0);
	$dialog->set_border_width(5);
#	$dialog->set_default_size(1,275);
	$dialog->set_icon($self->{app}{window}->get_icon);
	
	my $hbox = Gtk2::HBox->new(0,12);
	$hbox->set_border_width(12);
	$dialog->vbox->add($hbox);

	my $vbox = Gtk2::VBox->new(0,5);
	$hbox->pack_start($vbox, 0,1,0);

	# Find entry
	my $align = Gtk2::Alignment->new(0,0.5, 0,0);
	$align->add( Gtk2::Label->new(__('Find what').':') ); #. input label
	$vbox->add( $align );
	my $find_entry = Gtk2::Entry->new;
	$vbox->add( $find_entry );

	my $case = Gtk2::CheckButton->new(__('Match c_ase')); #. check box
	$vbox->add($case);
	my $word = Gtk2::CheckButton->new(__('Whole _word')); #. check box
	$vbox->add($word);

	# Replace entry
	$align = Gtk2::Alignment->new(0,0.5, 0,0);
	$align->add( Gtk2::Label->new(__('Replace with').':') ); #. input label
	$vbox->add( $align );
	my $replace_entry = Gtk2::Entry->new;
	$vbox->add( $replace_entry );

	# Buttons
	my $direction = 1; # go forward by default
	my $bbox = Gtk2::VButtonBox->new;
	$hbox->add($bbox);
	
	my $next_b = $self->{app}->new_button(
		'gtk-go-forward', __('_Next') ); #. button
	$next_b->signal_connect(clicked => sub {
		my $query = $find_entry->get_text;
		my @opt = map $_->get_active, $case, $word;
		$direction = 1;
		$self->{app}->PageView->search($query, $direction, @opt);
	} );
	$find_entry->signal_connect( activate => sub { $next_b->clicked } );
	$bbox->add($next_b);

	my $prev_b = $self->{app}->new_button(
		'gtk-go-back', __('_Previous') ); #. button
	$prev_b->signal_connect(clicked => sub {
		my $query = $find_entry->get_text;
		my @opt = map $_->get_active, $case, $word;
		$direction = -1;
		$self->{app}->PageView->search($query, $direction, @opt);
	} );
	$bbox->add($prev_b);

	my $repl_b = $self->{app}->new_button(
		'gtk-find-and-replace', __('_Replace') ); #. button
	$repl_b->signal_connect(clicked => sub {
		my $query = $find_entry->get_text;
		my $string = $replace_entry->get_text;
		my @opt = map $_->get_active, $case, $word;
		$self->{app}->PageView->replace($string);
		$self->{app}->PageView->search($query, $direction, @opt);
	} );
	$bbox->add($repl_b);

	my $repl_all_b = Gtk2::Button->new(__('Replace _all') ); #. button
	$repl_all_b->signal_connect(clicked => sub {
		my $query = $find_entry->get_text;
		my $string = $replace_entry->get_text;
		$self->{app}->PageView->replace_all($query => $string);
	} );
	$bbox->add($repl_all_b);
	
	$dialog->signal_connect(response => sub {
		my ($dialog, $response) = @_;
		if ($response eq 'help') {
			$self->{app}->ShowHelp(':usage:searching');
		}
		else { $self->hide }
	} );

	$self->{dialog} = $dialog;
	$self->{find_entry} = $find_entry;
	$dialog->show_all;
	$dialog->move( @{$self->{position}} ) if $self->{position};
	
	if (length $query) {
		$find_entry->set_text($query);
		# TODO find text
	}
}

=item C<hide()>

=cut

sub hide {
	return unless $_[0]->{dialog};
	$_[0]->{position} = [ $_[0]->{dialog}->get_position ];
	$_[0]->{dialog}->destroy;
	$_[0]->{dialog} = undef;
	$_[0]->{find_entry} = undef;
}

=item C<search(QUERY)>

=cut

sub search {
	my $self = shift;
	$self->show(@_);
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

