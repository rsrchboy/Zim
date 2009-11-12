package Zim::GUI::SearchDialog;

use strict;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.27';
our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI::SearchDialog - simple module

=head1 DESCRIPTION

This module contains the search dialog for zim.

=head1 METHODS

=over 4

=item C<show()>

=cut

sub show {
	my $self = shift;
	my $query = shift;
	$query = $$self{last_query} unless length $query;
	
	## Setup dialog
	my $dialog = Gtk2::Dialog->new(
		__('Search'), $self->{app}{window}, #. dialog title
		[qw/destroy-with-parent no-separator/],
		'gtk-help'  => 'help',
		'gtk-close' => 'close',
	);
	$dialog->set_border_width(5);
	$dialog->set_default_size(250,300);
	$dialog->set_icon($self->{app}{window}->get_icon);
	
	my $vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(12);
	$dialog->vbox->pack_start($vbox, 0,1,0);
	
	my $table = Gtk2::Table->new(3, 3);
	$vbox->add($table);

	$table->attach_defaults(
			Gtk2::Label->new( __('Search').':' ), 1,2, 1,2 ); #. input label
	my $string_entry = Gtk2::Entry->new();
	$table->attach_defaults( $string_entry, 2,3, 1,2 );
	$$self{query_entry} = $string_entry;
	my $find_button = Gtk2::Button->new_from_stock('gtk-find');
	$table->attach_defaults($find_button, 3,4, 1,2 );

	#my $edit_button = Gtk2::Button->new_from_stock('gtk-edit');
	#$edit_button->signal_connect(clicked => sub { $self->edit_query } );
	#$table->attach_defaults($edit_button, 3,4, 2,3);

	my $case_box = Gtk2::CheckButton->new_with_mnemonic(
		__('Match c_ase') ); #. check box
	$table->attach_defaults($case_box, 1,3, 2,3);
	my $word_box = Gtk2::CheckButton->new_with_mnemonic(
		__('Whole _word') ); #. check box
	$table->attach_defaults($word_box, 1,3, 3,4);
	
	my $swindow = Gtk2::ScrolledWindow->new();
	$swindow->set_policy('automatic', 'automatic');
	$swindow->set_shadow_type('in');
	$dialog->vbox->add($swindow);
	
	my $list = Gtk2::SimpleList->new(
		__('Page') => 'text',   #. header search results
		__('Rank') => 'int'  ); #. header search results
	$list->get_column(0)->set_expand(1);
	$list->get_column(0)->set_sort_column_id(0);
	$list->get_column(1)->set_sort_column_id(1);
	$list->get_model->set_sort_column_id(1 => 'descending');
	$self->set_treeview_single_click($list);
	$swindow->add($list);
	
	$find_button->signal_connect(clicked => sub {
		my $query = {
			string => $string_entry->get_text,
			case   => $case_box->get_active,
			word   => $word_box->get_active,
		} ;
		return unless $$query{string} =~ /\S/;

		if ($$query{string} =~ /:/) { # back links - FIXME does not belong here
			my $page = $self->{app}{notebook}->resolve_page($$query{string});
			return unless $page;
			@{$list->{data}} = map [$_, 1], $page->list_backlinks();
		}
		else {
			@{$list->{data}} = ();
			my $callback = sub {
				push @{$list->{data}}, @_ if @_;
				while (Gtk2->events_pending) {
					Gtk2->main_iteration_do(0);
				}
			};
			$self->{app}{notebook}->search($query, $callback);
		}
	} );

	$string_entry->signal_connect(
		activate => sub { $find_button->clicked } );

	$list->signal_connect(row_activated => sub {
		my ($i) = $list->get_selected_indices;
		my ($name) = @{$list->{data}[$i]};
		$self->{app}->present;
		$self->{app}->link_clicked($name);
		$self->{app}->PageView->Find($string_entry->get_text);
	} );

	$dialog->signal_connect(response => sub {
		my ($dialog, $response) = @_;

		if ($response eq 'help') {
			$self->{app}->ShowHelp(':usage:searching');
			return;
		}
		else {
			$self->hide;
		}
	} );

	if (length $query) {
		$string_entry->set_text($query);
		$find_button->clicked;
	}
	
	$dialog->show_all;
	$dialog->move( @{$self->{position}} ) if $self->{position};
	$self->{dialog} = $dialog;
}

=item C<hide()>

=cut

sub hide {
	# We destroy instead of doing a real hide because search
	# dialog can contain a lot of data.
	return unless $_[0]->{dialog};
	$_[0]->{last_query} = $_[0]->{query_entry}->get_text();
	$_[0]->{position} = [ $_[0]->{dialog}->get_position ];
	$_[0]->{dialog}->destroy;
	$_[0]->{query_entry} = undef;
	$_[0]->{dialog} = undef;
}

=item C<search(QUERY)>

=cut

sub search {
	my $self = shift;
	$self->show(@_);
}

=item C<edit_query()>

Opens the "Edit query" dialog.

=cut

sub edit_query {
	my $self = shift;
	my $query = $$self{query_entry}->get_text;

	## Setup dialog
	my $dialog = Gtk2::Dialog->new(
		__('Edit Query'), #. dialog title
		$$self{dialog} || $$self{app}{window},
		[qw/destroy-with-parent no-separator/],
		'gtk-help'   => 'help',
		'gtk-cancel' => 'close',
		'gtk-ok'     => 'ok',
	);
	$dialog->set_border_width(5);
	$dialog->set_default_size(250,300);
	$dialog->set_icon($self->{app}{window}->get_icon);
	
	$dialog->vbox->pack_start( Gtk2::Label->new(
		__('You can add rules to your search query below') #. dialog text
	), 0,1,0 );

	my $vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(12);
	$dialog->vbox->pack_start($vbox, 0,1,0);
	
	my $hbox = Gtk2::HBox->new(0,5);
	$vbox->add($hbox);

	my $opp_combo = Gtk2::ComboBox->new_text();
	$opp_combo->append_text($_) for qw/AND OR/;
	$hbox->pack_start($opp_combo, 0,0,0);

	my $not_combo = Gtk2::ComboBox->new_text();
	$not_combo->append_text($_) for '   ', 'NOT';
	$hbox->pack_start($not_combo, 0,0,0);

	my $type_combo = Gtk2::ComboBox->new_text();
	$type_combo->append_text($_) for qw/Name Content Links LinksTo/;
	$hbox->pack_start($type_combo, 0,0,0);

	$hbox = Gtk2::HBox->new(0,5);
	$vbox->add($hbox);

	my $entry = Gtk2::Entry->new;
	$hbox->add($entry);
	my $add_button = Gtk2::Button->new_from_stock('gtk-add');
	$hbox->add($add_button);
	$entry->signal_connect(activate => sub{ $add_button->clicked });

	$query =~ s/(\s)(AND|OR|NOT|&&?|\|\|?|\!)\s/$1$2\n/g;
	my ($scroll, $textview) = $self->new_textview($query);
	$dialog->vbox->add($scroll);

	$add_button->signal_connect(clicked => sub {
			my $opp = _get_active_text($opp_combo);
			my $not = (_get_active_text($not_combo) eq 'NOT');
			my $type = _get_active_text($type_combo);
			my $string = $entry->get_text;
			$string =~ s/"/\\"/g;
			$string = "\"$string\"" if $string =~ /\W/;
			my $buffer = $textview->get_buffer;
			$query = $buffer->get_text($buffer->get_bounds, 0);
			$query = '' unless $query =~ /\S/;
			$query .= " $opp\n" if length $query;
			$query .= ($not ? 'NOT ' : '') . "$type: $string";
			$buffer->set_text($query);
		} );

	## Run dialog
	$dialog->show_all;
	$dialog->signal_connect(response => sub {
			my ($dialog, $response) = @_;
			if ($response eq 'help') {
				$self->{app}->ShowHelp(':usage:searching');
				return;
			}
			elsif ($response eq 'ok') {
				my $buffer = $textview->get_buffer;
				$query = $buffer->get_text($buffer->get_bounds, 0);
				$query =~ s/\n+/ /g;
				$$self{query_entry}->set_text($query);
			}
			$dialog->destroy;
		} );
}

sub _get_active_text {
	my $combo = shift;
	if (Gtk2->CHECK_VERSION(2, 6, 0)) {
		return $combo->get_active_text;
	}
	else {
		my $iter = $combo->get_active_iter;
		return ( ($combo->get_model->get($iter))[0] );
	}
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

