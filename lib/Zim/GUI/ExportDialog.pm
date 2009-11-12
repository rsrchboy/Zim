package Zim::GUI::ExportDialog;

use strict;
use Gtk2;
use File::BaseDir qw/xdg_data_files xdg_data_dirs xdg_data_home/;
use Zim::Utils;
use Zim::GUI::Component;
use Zim::Selection;
#use Zim::Formats;

our $VERSION = '0.24';
our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI::ExportDialog - dialog for zim

=head1 DESCRIPTION

This modules contains the export dialog for zim.
It is autoloaded when needed.

=head1 METHODS

=over 4

=item C<show()>

Present the dialog.

=cut

sub show {
	my $self = shift;
	return $self->{dialog}->present if defined $self->{dialog};
	$self->{app}->SaveIfModified or return;
	$$self{filechooser_dir} ||= $ENV{HOME}; # default folder to open

	my $dialog = Gtk2::Dialog->new(
		__("Export page"), $self->{app}{window}, #. dialog title
	       	[qw/destroy-with-parent no-separator/],
		'gtk-help'   => 'help',
		'gtk-cancel' => 'cancel',
		'gtk-ok'     => 'ok',
	);
	$dialog->set_resizable(0);
	$dialog->vbox->set_border_width(12);
	
	# Page range
	my $frame = Gtk2::Frame->new;
	my $label = Gtk2::Label->new('<b>'.__('Pages').'</b>'); #. group label
	$label->set_use_markup(1);
	$frame->set_label_widget($label);
	$dialog->vbox->add($frame);
	
	my $vbox = Gtk2::VBox->new(0, 5);
	$vbox->set_border_width(12);
	$frame->add($vbox);
	
	my $radio1 = Gtk2::RadioButton->new_with_mnemonic(
		undef, __('_All') ); #. radio button
	my $rgroup = $radio1->get_group;
	$vbox->add($radio1);

	my $hbox = Gtk2::HBox->new(0, 5);
	$vbox->add($hbox);
	
	my $radio2 = Gtk2::RadioButton->new_with_mnemonic(
		$rgroup, __('_Page').':' ); #. radio button
	$hbox->pack_start($radio2, 0,1,0);
	
	my $page_entry = Gtk2::Entry->new();
	$page_entry->set_text( $self->{app}{page}->name );
	$page_entry->set_sensitive(0);
	$hbox->pack_start($page_entry, 0,1,0);

	my $recurs_box = Gtk2::CheckButton->new_with_label(__('Recursive')); #. check box
	$recurs_box->set_active(1);
	$recurs_box->set_sensitive(0);	
	$vbox->add($recurs_box);
	
	$radio2->signal_connect( toggled => sub {
		my $active = $radio2->get_active;
		$page_entry->set_sensitive( $active );
		$recurs_box->set_sensitive( $active );
	} );
	
	# Output
	$frame = Gtk2::Frame->new;
	$label = Gtk2::Label->new('<b>'.__('Output').'</b>'); #. group label
	$label->set_use_markup(1);
	$frame->set_label_widget($label);
	$dialog->vbox->add($frame);
	
	my $table = Gtk2::Table->new(5, 3);
	$table->set_border_width(12);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);
	$frame->add($table);
	
	my $i;
	for (__('Format'), __('Template'), '', __('Output dir'), __('Index page')) { #. label input field
		if (length $_) {
			my $label = Gtk2::Label->new($_.':');
			my $align = Gtk2::Alignment->new(0,0.5, 0,0);
			$align->add($label);
			$table->attach_defaults($align, 0,1, $i,$i+1);
		}
		$i++;
	}

	my $state = $self->init_state('Export', {
		# defaults
		format => 'html',
		index => 'index',
		template => 'Default',
		use_doc_root => 1,
		doc_root => '/',
		attach_external => 0,
	} );
	
	my $combo1 = Gtk2::ComboBox->new_text();
	my @formats = qw/Html Txt2Tags/;
	# FIXME use Zim::Formats->list(..) to discover available formats
	$combo1->append_text($_) for @formats;
	my ($if) = grep {lc($formats[$_]) eq $$state{format}} 0..$#formats;
	$combo1->set_active($if || 0);
	$table->attach_defaults($combo1, 1,2, 0,1);
	
	my $combo2 = Gtk2::ComboBox->new_text();
	my $combo2_items = -1;
	my $templates = {};
	$table->attach_defaults($combo2, 1,2, 1,2);

	my $entry2 = Gtk2::Entry->new;
	$table->attach_defaults($entry2, 1,2, 2,3);
	my $button2 = Gtk2::Button->new(__('_Browse...')); #. button
	$button2->signal_connect(clicked => sub {
		my $t = $self->filechooser_dialog();
		$entry2->set_text($t) if defined $t;
	} );
	$table->attach_defaults($button2, 2,3, 2,3);

	my $entry3 = Gtk2::Entry->new;
	$table->attach_defaults($entry3, 1,2, 3,4);
	$entry3->set_text($$state{dir} || '');
	$entry3->signal_connect(activate => sub { $dialog->response('ok') });
	my $button3 = Gtk2::Button->new(__('_Browse...')); #. button
	$button3->signal_connect(clicked => sub {
		my $dir = $entry3->get_text;
		$dir = $self->filechooser_dialog($dir, 'DIR');
		$entry3->set_text($dir) if defined $dir;
	} );
	$table->attach_defaults($button3, 2,3, 3,4);
	
	my $entry4 = Gtk2::Entry->new;
	$table->attach_defaults($entry4, 1,2, 4,5);
	$entry4->set_text($$state{index} || '');

	my $fill_combo2 = sub {
		my $format = _get_active_text($combo1);
		for (reverse 0 .. $combo2_items) { $combo2->remove_text($_) }
		$templates = Zim::Formats->list_templates($format);
		for (sort keys %$templates) {
			next if /^[_\W]/; # skip "_New" etc.
			if (/^default$/i) { $combo2->prepend_text($_) }
			else              { $combo2->append_text($_)  }
		}
		$combo2_items = scalar keys %$templates;
		$combo2->append_text(__('other...')); #. item in dropdown menu
		$combo2->set_active(0);
		my $other = ($combo2_items == 0);
		$entry2->set_sensitive($other);
		$button2->set_sensitive($other);
	};
	$fill_combo2->(); # initialize

	$combo1->signal_connect(changed => $fill_combo2);
	$combo2->signal_connect(changed => sub {
		my $other = ($combo2->get_active == $combo2_items) ; # "other" item
		$entry2->set_sensitive($other);
		$button2->set_sensitive($other);
	} );

	if ($$state{template} =~ /[\/\\]/) {
		$entry2->set_text($$state{template} || '');
		$combo2->set_active($combo2_items); # other;
	}
	else {
		my @t = sort keys %$templates;
		my ($j) = grep {lc($t[$_]) eq lc($$state{template})} 0..$#t;
		$combo2->set_active($j || 0);
	}

	$frame = Gtk2::Frame->new;
	$label = Gtk2::Label->new('<b>'.__('Media').'</b>'); #. group label
	$label->set_use_markup(1);
	$frame->set_label_widget($label);
	$dialog->vbox->add($frame);
	
	$vbox = Gtk2::VBox->new(0, 5);
	$vbox->set_border_width(12);
	$frame->add($vbox);
	
	$hbox = Gtk2::HBox->new(0, 5);
	$vbox->add($hbox);

	my $use_doc_root = Gtk2::CheckButton->new_with_label(
		__('Prefix document root').':' );
	$use_doc_root->set_active($$state{use_doc_root} || 0);
	$hbox->add($use_doc_root);

	my $doc_root = Gtk2::Entry->new();
	$doc_root->set_text($$state{doc_root} || '');
	$hbox->add($doc_root);

	my $attach_external = Gtk2::CheckButton->new_with_label(
		__('Attach external files') );
	$attach_external->set_active($$state{attach_external} || 0);
	$vbox->add($attach_external);

	# Run dialog
	$self->{dialog} = $dialog;
	$dialog->show_all;
	while ($_ = $dialog->run) {
		if ($_ eq 'help') {
			$self->ShowHelp(':usage:exporting');
			next;
		}
		
		last unless $_ eq 'ok';
		
		# TODO, resolve page here !
		# and resolve page in zim.pl sub export
		my @pages = $radio1->get_active ? (':') : (
			grep length($_),
			split /,\s*|\s+/, $page_entry->get_text ) ;
		last unless @pages;
		
		my ($tn, $template);
		if ($entry2->is_sensitive) { # free input
			$template = $entry2->get_text;
			$template = './'.$template unless $template =~ /[\/\\]/;
			$tn = $template;
		}
		else {
			$tn = _get_active_text($combo2);
			$template = $$templates{$tn};
		}

		my $attach = $attach_external->get_active || 0;
		my %opts = (
			format   => lc _get_active_text($combo1),
			dir      => $entry3->get_text,
			template => $template,
			media    => $attach ? 'all' : 'default',
			index    => $entry4->get_text,
			doc_root => $doc_root->get_text,
		);
		$$state{$_} = $opts{$_}
			for qw/dir format index doc_root/;
		$$state{use_doc_root} = $use_doc_root->get_active || 0;
		delete $opts{doc_root} unless $$state{use_doc_root};
		$$state{template} = $tn;
		$$state{attach_external} = $attach;
		#use Data::Dumper;
		#warn "OPTIONS ", Dumper \%opts;
		#warn "STATE ", Dumper $state;
		
		$dialog->destroy;		
		$self->{dialog} = undef;

		my ($bar, $label);
		($dialog, $bar, $label) = $self->new_progress_bar(
			__("Export page"), #. dialog title
			__("Exporting page {number}", number => 0) ); #. progress bar label
		my $continue = 1;
		$dialog->signal_connect(response => sub {$continue = 0});
		my $i = 1;
		$opts{callback} = sub {
			$bar->pulse;
			$label->set_text(__("Exporting page {number}", number => $i++)); #. progress bar label
			while (Gtk2->events_pending) { Gtk2->main_iteration_do(0) }
			return $continue;
		};
		
		eval {
			my $o = { resolve => 1, recurse => $recurs_box->get_active() };
			my $s = Zim::Selection->new(
				$self->{app}{notebook}, $o, @pages);
			$s->export(\%opts);
		};
		$self->error_dialog($@) if $@;

		$$self{app}->SaveState;
		
		last;
	}
	$dialog->destroy;
	$self->{dialog} = undef;
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

=item C<hide()>

Delete the dialog.

=cut

sub hide {
	return unless $_[0]->{dialog};
	$_[0]->{dialog}->destroy;
	$_[0]->{dialog} = undef;
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

