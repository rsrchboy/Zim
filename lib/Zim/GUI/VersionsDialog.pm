package Zim::GUI::VersionsDialog;

use strict;
use Gtk2;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.27';
our @ISA = qw/Zim::GUI::Component/;

$Zim::GUI::DEFAULTS{diff_editor} ||= 'meld';

=head1 NAME

Zim::GUI::VersionsDialog - versions dialog for zim

=head1 DESCRIPTION

This modules contains the versions dialog for zim.
It is autoloaded when needed.

=head1 METHODS

=over 4

=item C<show()>

Present the dialog.

=cut

sub show {
	my $self = shift;
	$$self{app}->SaveIfModified or return;

	my $vcs = $$self{app}{notebook}{vcs};

	my $dialog = Gtk2::Dialog->new(
		__("Versions"), $self->{app}{window}, #. dialog title
	       	[qw/destroy-with-parent no-separator/],
		'gtk-help'  => 'help',
		'gtk-close' => 'ok',
	);
	$dialog->vbox->set_border_width(12);
	$dialog->vbox->set_spacing(5);
	$dialog->set_default_size(500, 400);

	my $vpane = Gtk2::VPaned->new;
	$dialog->vbox->add($vpane);
	my $vbox1 = Gtk2::VBox->new;
	$vpane->add1($vbox1);

	# Page entry and buttons
	my $hbox1 = Gtk2::HBox->new;
	$vbox1->pack_start($hbox1, 0,1,0);

	my $plabel = Gtk2::Label->new('<b>'.__('Page').':</b>'); #. input label
	$plabel->set_use_markup(1);
	$hbox1->pack_start($plabel, 0,1,0);
	my $page_entry = Gtk2::Entry->new;
	$page_entry->set_text("$$self{app}{page}");
	$self->set_page_completion($page_entry);
	$hbox1->pack_start($page_entry, 0,1,0);

	my $apply_button = $self->new_small_button('gtk-apply');
	$hbox1->pack_start($apply_button, 0,1,0);
	$apply_button->signal_connect(
		clicked => sub { $page_entry->signal_emit('activate') } );
	my $clear_button = $self->new_small_button('gtk-clear');
	$hbox1->pack_start($clear_button, 0,1,0);
	$clear_button->signal_connect( clicked => sub {
		$page_entry->set_text('');
		$page_entry->signal_emit('activate');
	} );

	my $ann_button = Gtk2::Button->new(__('View _Annotated...')); #. button
	$hbox1->pack_start($ann_button, 0,1,0);

	my $rev_button = Gtk2::Button->new(__('_Restore Version...')); #. button
	$hbox1->pack_start($rev_button, 0,1,0);

	# TODO wrap list and text in a HPaned

	# Version list
	my $list = Gtk2::SimpleList->new(
		__('Id')    => 'text', #. column header for version id
		__('Date')  => 'text', #. column header for timstamp
		__('User')  => 'text', #. column header for committer
		'_comment_' => 'text', # hidden column
	);
	$list->get_column(3)->set_visible(0);
	$self->set_treeview_single_click($list);
	my $scroll1 = Gtk2::ScrolledWindow->new;
	$scroll1->set_policy('automatic', 'automatic');
	$scroll1->set_shadow_type('in');
	$scroll1->add($list);
	$vbox1->add($scroll1);

	# Frame with comment
	my $frame = Gtk2::Frame->new;
	my $label = Gtk2::Label->new('<b>'.__('Comment').'</b>'); #. frame label
	$label->set_use_markup(1);
	$frame->set_label_widget($label);
	$vpane->add2($frame);
	my $vbox2 = Gtk2::VBox->new;
	$frame->add($vbox2);
	$vbox2->set_border_width(12);

	# Comment text
	my ($scroll2, $textview) = $self->new_textview;
	$vbox2->pack_start($scroll2, 1,1,0);

	# Input and buttons for diffs etc.
	my $hbox2 = Gtk2::HBox->new();
	$vbox2->pack_start($hbox2, 0,1,0);

	$hbox2->pack_start(
		Gtk2::Label->new(__('Compare this version with').':'), 0,1,0 ); #. label for version entry

	my $current = __('Current'); #. special name for current version
		# use var to match translated string later
	my $version_entry = Gtk2::Entry->new();
	$version_entry->set_text( $current );
	$hbox2->pack_start($version_entry, 0,1,0);

	my $bbox = Gtk2::HButtonBox->new;
	$bbox->set_layout('end');
	$vbox2->pack_start($bbox, 0,1,0);
	my $dbutton = Gtk2::Button->new(__('_Notebook Changes...')); #. button label
	$bbox->add($dbutton);
	my $pbutton = Gtk2::Button->new(__('_Page Changes...')); #. button label
	$bbox->add($pbutton);
	my $cbutton = Gtk2::Button->new(__('Co_mpare Page...')); #. button label
	$bbox->add($cbutton);
	$_->set_sensitive(0) for $bbox->get_children;

	my $version;
	$list->signal_connect(row_activated => sub {
		my ($view, $path) = @_;
		my $model = $view->get_model;
		my $iter = $model->get_iter($path);
		$version = $model->get_value($iter, 0);
		my $comment = $model->get_value($iter, 3);
		$textview->get_buffer->set_text($comment);
		$_->set_sensitive(1) for $bbox->get_children;
	} );

	$ann_button->signal_connect( clicked => sub {
		my $page = _get_page($self, $page_entry) or return;
		$self->Annotate($page);
	} );

	$rev_button->signal_connect( clicked => sub {
		my $page = _get_page($self, $page_entry) or return;
		my ($v1) = _get_versions(
			$self, $version, $version_entry, $current);
		$self->Restore($page, $v1);
	} );

	$dbutton->signal_connect(clicked => sub {
		# Diff notebook button
		my ($v1, $v2) = _get_versions(
			$self, $version, $version_entry, $current);
		return unless defined $v1;
		$self->Diff(undef, $v1, $v2);
	} );

	$pbutton->signal_connect(clicked => sub {
		# Diff page button
		my ($v1, $v2) = _get_versions(
			$self, $version, $version_entry, $current);
		return unless defined $v1;
		my $page = _get_page($self, $page_entry) or return;
		$self->Diff($page, $v1, $v2);
	} );

	$cbutton->signal_connect(clicked => sub {
		# Compare page button
		my ($v1, $v2) = _get_versions(
			$self, $version, $version_entry, $current);
		return unless defined $v1;
		my $page = _get_page($self, $page_entry) or return;
		$self->Compare($page, $v1, $v2);
	} );

	$page_entry->signal_connect( activate => sub {
		my $page = ( $page_entry->get_text =~ /\S/ )
			? _get_page($self, $page_entry)
			: undef ;
		_fill_version_list($self, $list, $page);
	} );

	# TODO connect buttons (in)sensitive to entry->activate
	# ann_button diff_page_button compare_page_button

	# set vpane layout
	$vpane->set_position(175);
	$vpane->child1_resize(1);
	$vpane->child2_resize(0);

	# Run the dialog
	$dialog->signal_connect(response => sub {
		my ($dialog, $response) = @_;

		if ($response eq 'help') {
			$self->{app}->ShowHelp(':Usage:VersionControl');
			return;
		}
		else {
			$dialog->destroy;
		}
	} );
	$dialog->show_all;
	_fill_version_list($self, $list, $$self{app}{page});
}

sub _get_page {
	my ($self, $entry) = @_;
	my $name = $entry->get_text;
	my $page = $$self{app}{notebook}->resolve_page(
		$name, $$self{app}{page} )
			if $name =~ /\S/;
	if (ref $page) {
		$entry->set_text($page->name);
		return $page;
	}
	else {
		my $error = ($name =~ /\S/)
			? __('No such page: {page}', page => $name) #. error
			: __('Please give a page first') ; #. error
		$self->error_dialog($error);
		return undef;
	}
}

sub _get_versions {
	my ($self, $v1, $entry, $current) = @_;
	unless (defined $v1) {
		# no version selected in list
		$self->error_dialog(__('Please select a version first')); #. error
		return undef;
	}
	else {
		# check entry input - special kayword current or version
		my $v2 = $entry->get_text;
		$v2 =~ s/^\s*|\s*$//g;
		$v2 = undef unless length $v2 and lc($v2) ne lc($current);
		return ($v1, $v2);
	}
}

sub _fill_version_list {
	my ($self, $list, $page) = @_;
	my $path;
	$path = $$page{source}->path
		if $$page{source} and $$page{source}->can('path');
		# FIXME do we need other interface for this ?
	@{$$list{data}} = (); # clear
	push @{$$list{data}},
		$$self{app}{notebook}{vcs}->list_versions($path)
		if $path and -e $path ;
}

=item C<Diff(PAGE, VERSION1, VERSION2)>

Show the diff between VERSION1 and VERSION2 for PAGE in an external editor.
Without PAGE show the complete diff, without VERSION2 show the diff against
the current version.

=item C<Compare(PAGE, VERSION1, VERSION2)>

Show VERSION1 and VERSION2 of the page side by side in a specialized
application like "meld" or "gvim -d".

=item C<Annotate(PAGE, VERSION)>

Show the annotated source in an external editor.
If VERSION is undefined the current version is shown.

=item C<Restore(PAGE, VERSION)>

Prompt the user whether to revert PAGE to VERSION and loose all changes.
If VERSION is undefined we prompt to revert to latest saved version.

=cut

sub Diff     { shift->_page2file('gdiff', @_)     }

sub Compare  { shift->_page2file('gcompare', @_)  }

sub Annotate { shift->_page2file('gannotate', @_) }

sub Restore   {
	my $self = shift;
	$self->_page2file('grevert', @_);
	$$self{app}->Reload;
}

sub _page2file {
	my ($self, $sub, $page, @v) = @_;
	return 0 unless $$self{app}{notebook}{vcs};

	$$self{app}->SaveIfModified;

	@v = sort grep defined($_), @v;

	return $self->gdiff(undef, undef, @v)
		if $sub eq 'gdiff' and ! defined $page;
		# gdiff can be called without page to show complete notebook

	$page ||= $$self{app}{page};
	my $path = ($$page{source} and $$page{source}->can('path'))
		? $$page{source}->path : undef ;
		# TODO TODO needs proper interface
	return $self->error_dialog(
		__("Could not get file for page: {page}", page => $page) ) #. error
		unless defined $path;

	return $self->$sub($page, $path, @v);
}

=item C<gdiff(PAGE, PATH, V1, V2)>

Private method used by C<Diff()>, can be overloaded.

=item C<gcompare(PAGE, PATH, V1, V2)>

Private method used by C<Compare()>, can be overloaded.

=item C<gannotate(PAGE, PATH, VERSION)>

Private method used by C<Annotate()>, can be overloaded.

=item C<grevert(PAGE, PATH, VERSION)>

Private method used by C<Restore()>, can be overloaded.

=cut

sub gdiff {
	my ($self, $page, $path, $v1, $v2) = @_;

	my $diff = $$self{app}{notebook}{vcs}->diff($path, $v1, $v2);
	return $self->error_dialog(
		defined($page)
		  ? __("Could not get changes for page: {page}", page => $page) #. error
		  : __("Could not get changes for this notebook") #. error
		) unless defined $diff;

	return _show_text($self, $diff, '.diff');
}

sub gcompare {
	my ($self, $page, $path, $v1, $v2) = @_;
	$v2 = 'current' unless defined $v2;

	my ($text1, $text2);
	eval {
		$text1 = $$self{app}{notebook}{vcs}->cat_version($path, $v1);
		$text2 = ($v2 eq 'current')
			? file($path)->read
			: $$self{app}{notebook}{vcs}->cat_version($path, $v2);
	};
	return $self->error_dialog(
		__('Could not get versions to compare')."\n\n$@" ) #. error
		if $@ or !defined $text1 or !defined $text2 ;

	my $file1 = Zim::FS->tmp_file("compare-$v1.txt");
	my $file2 = Zim::FS->tmp_file("compare-$v2.txt"),

	$file1->write( $text1 );
	$file2->write( $text2 );

	# Find editor - FIXME proper interface here
	my $editor = $$self{app}->_ask_app('diff_editor', __('Diff Editor')) #. application type
		or return 0;
	$editor =~ s/\%[sf]/$file1/ or $editor .= " \"$file1\"";
	$editor =~ s/\%[sf]/$file2/ or $editor .= " \"$file2\"";

	Zim::Utils->run($editor);
	return 1;
}

sub gannotate {
	my ($self, $page, $path, $v) = @_;

	my $ann = $$self{app}{notebook}{vcs}->annotate($path, $v);
	return $self->error_dialog(
		__('Could not get annotated source for page {page}', page => $page) ) #. error
		unless defined $ann;

	return _show_text($self, $ann);
}

sub _show_text {
	my ($self, $text, $ext) = @_;
	$ext ||= '.txt';
	my $file = Zim::FS->tmp_file('VCS'.$ext);
	$file->write($text);

	# Find editor - FIXME proper interface here
	my $editor = $$self{app}->_ask_app('text_editor', __('Text Editor')) #. application type
		or return 0;
	$editor =~ s/\%[sf]/$file/ or $editor .= " \"$file\"";

	Zim::Utils->run($editor);
	return 1;
}

sub grevert {
	my ($self, $page, $path, $v) = @_;
	my $current = __('Current'); #. special name for current version
	$v = $current unless defined $v;

	my $text = __("<b>Restore page to saved version?</b>\n\nDo you want to restore page: {page}\nto saved version: {version} ?\n\nAll changes since the last saved version will be lost !", page => $page, version => $v); #. confirmation for restore version, answers are 'cancel' or 'ok'
	my $answer = $self->prompt_question(
		'warning', $text,
		[cancel => 'gtk-cancel'], [ok => 'gtk-ok'] );

	$v = undef if $v eq $current;
	$$self{app}{notebook}{vcs}->revert($path, $v)
		if $answer eq 'ok';
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2008 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>,
L<Zim::GUI>

=cut

