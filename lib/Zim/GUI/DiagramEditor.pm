package Zim::GUI::DiagramEditor;

use strict;
use Zim::Utils;
use Zim::GUI::Component;
use Zim::Template;

our @ISA = qw/Zim::GUI::Component/;

our $VERSION = '0.28';

our %DEFAULTS = (
	dot => 'dot %1 -Tpng -o %2',
);


=head1 NAME

Zim::GUI::DiagramEditor - Diagram editor for Zim

=head1 DESCRIPTION

This module provides the diagram editor dialog for Zim.
It requires dot to generate the actual diagram image.

=head1 METHODS

=over 4

=item C<show(PATH)>

Open the diagram editor. If PATH is given it is the "src" path to an exiting
image (the corresponding .dot file is also assumed to exit). This path is
resolved relative to the current page.

=cut

sub init {
	my $self = shift;
	$self->init_settings('DiagramEditor Plugin', \%DEFAULTS);

	# Test if the applications are available
	my $null = File::Spec->devnull;
	my $dot = $$self{settings}{dot};
	for ($dot) {
		/^(\S+)/; # match base command
		system("which $1 > $null") == 0 and next;
		
		my $error = __('Can not find application "{name}"', name => $1); #. error when external application is not found
		$self->error_dialog($error);
		$$self{app}->unplug('DiagramEditor');
		die $error."\n";
	}
}

sub show {
	my ($self, $src) = @_;

	my $dialog = Gtk2::Dialog->new(
		__("Diagram Editor"), $self->{app}{window}, #. dialog title
	       	[qw/modal destroy-with-parent/],
		'gtk-help'   => 'help',
		'gtk-cancel' => 'cancel',
		'gtk-ok'     => 'ok',
	);
	$dialog->set_resizable(1);
	$dialog->set_default_size(400, 0);
	$dialog->vbox->set_border_width(12);
	$self->{dialog} = $dialog;

	# Apart from spacing between image and text this extra vbox
	# also seems to be needed for the viewport to resize correctly
	# after a new image is added. (!?)
	my $vbox = Gtk2::VBox->new(0, 12);
	$dialog->vbox->add($vbox);

	my $win1 = Gtk2::Viewport->new;
	my $color = Gtk2::Gdk::Color->parse('#FFF');
	$win1->modify_bg('normal', $color); # set white background
	$win1->set_no_show_all(1);
	$self->{image_window} = $win1;
	$vbox->add($win1);
	
	my ($win2, $text) = $self->new_textview;
	$text->set_editable(1);
	$self->{buffer} = $text->get_buffer;
	$vbox->add($win2);

	my $hbox = Gtk2::HBox->new;
	$dialog->vbox->pack_start($hbox, 0,1,0);

	my $pbutton = $self->{app}->new_button(
		'gtk-refresh', __('_Preview') ); #. button
	$pbutton->signal_connect(clicked => \&compile, $self);
	$pbutton->set_sensitive(0);
	$hbox->pack_start($pbutton, 0,1,0);
	$self->{buffer}->signal_connect('modified-changed' =>
		sub { $pbutton->set_sensitive($self->{buffer}->get_modified) } );

	#my $lbutton = $self->{app}->new_button(
	#	'gtk-file', __('View _Log') ); #. button
	#$lbutton->signal_connect(clicked => \&view_log, $self);
	#$hbox->pack_start($lbutton, 0,1,0);
	#$lbutton->set_sensitive(0);
	#$self->{log_button} = $lbutton;

	$dialog->show_all;
	$win1->set_no_show_all(0);
	$self->{compiled} = 0;

	# For an existing image load both the image and the dot source
	# trow an error if the asociated dot file does not exist.
	if ($src) {
		my $img = $$self{app}{page}->resolve_file($src);
		my $dot_file = $img->path;
		$dot_file =~ s/\.png$/.dot/;
		return $self->{app}->error_dialog(
			__("The diagram for image: {path}\nis missing. Can not edit diagram.", path => $img->path) ) #. error when no .dot file exists
			unless -e $dot_file;
		$self->_load_image($img);
		$self->{buffer}->set_text( file($dot_file)->read || '' );
	}

	# Run the dialog
	while (my $response = $dialog->run) {
		if ($response eq 'help') {
			$self->{app}->ShowHelp(
				':usage:plugins:DiagramEditor' );
			next;
		}
		elsif ($response eq 'ok') {
			last if ! $self->{compiled}
			     && ! $self->{buffer}->get_modified;
				# Diagram was not edited => cancel
			my $img = $self->save($src);
			next unless defined $img;
			$img .= '?type=diagram';
			defined($src) ? $$self{app}->Reload
			               : $$self{app}->PageView->InsertImage($img, 'NO_ASK' );
			last;
		}
		else { last } # cancel
	}
	_cleanup();
	delete @$self{qw/dialog image_window buffer log_button/};
	$dialog->destroy;
}

sub _cleanup {
	# Remove tmp files. Especially because using PID in file names
	# this widget can polute /tmp rather quickly if we do not clean up.
	my $tmpdir = Zim::FS->tmpdir;
	eval {
		file($_)->remove
			for <$tmpdir/zim-$ENV{USER}-$$-DiagramEditor.*>;
	};
}

=item C<save(PATH)>

Compile the diagram and save it to the namespace for the current page.
PATH is an optional argument which is given in case we are editing
an already existing diagram. Returns the path for the image.

=cut

sub save {
	my ($self, $src) = @_;

	## Compile
       	$self->compile if $self->{buffer}->get_modified;
	my $tmp_img = $$self{img_file};
	unless (-e $tmp_img) {
		my $r = $self->{app}->prompt_question( 'warning',
			'<b>'.__('The diagram failed to compile. Do you want to save anyway?').'</b>', #. warning dialog, answers are 'save' or 'cancel'
			[cancel => 'gtk-cancel'],
			[save   => 'gtk-save'  ]  );
		return unless $r eq 'save';
	}

	## Save text and store image under the same name
	my $page   = $$self{app}{page};
	my $buffer = $$self{buffer};
	my $text   = buffer( $buffer->get_text($buffer->get_bounds(), 0) );
	if ($src) {
		# overwrite existing file
		# we call resolve_file to make sure we get a file object
		# that is properly nested below doc_dir or doc_root
		my $dot_file = $src;
		$dot_file =~ s/\.png$/.dot/ or die;
		my $img = $page->resolve_file($src);
		file($tmp_img)->copy($img);
		$page->resolve_file($dot_file)->write($text->read);
	}
	else {
		# store under a new unique name
		my $path = $page->store_file($text, 'diagram_XX.dot');
		$path =~ m#(diagram_\d+)# or die;
		my $img = $1.'.png';
		return $page->store_file(file($tmp_img) => $img);
	}
}

=item C<compile()>

Compiles the diagram in the tmp dir and shows a preview in the dialog.

=cut

sub compile {
	my $self = pop; # pop because we can be called from signal

	# Logic similar to Zim::FS->tmp_file for creating tmp files
	# Include user name and PID to avoid collisions
	my $tmpdir = Zim::FS->tmpdir;
	my $dot_file = "$tmpdir/zim-$ENV{USER}-$$-DiagramEditor.dot";

	my $img = $dot_file;
	$img =~ s/\.dot$/.png/;

	my $mask = umask 0077; # set umask to user only

	## Get text from widget and write to file
	my $text = $self->{buffer}->get_text(
		$self->{buffer}->get_bounds(), 0 );

	warn "# Writing $dot_file\n";
	file($dot_file)->write($text);

	## Generate Image
	my $dot = $$self{settings}{dot};
	$dot =~ s/\%1/$dot_file/g;
	$dot =~ s/\%2/$img/g;

	## Run commands
	my $ok = (system($dot) == 0);
	warn "Generating diagram failed: $!\n" if $?;
	
	umask $mask; # reset old umask
	
	## Make sure we don't leave a broken image
	unlink $img or die $! if ! $ok and -f $img;

	## Update dialog
	$self->_load_image($img);
	$self->{compiled} = 1;
	$self->{buffer}->set_modified(0);
	#$self->{log_button}->set_sensitive(1);
	$self->{dot_file} = $dot_file;
	$self->{img_file} = $img;
	#$self->{log_file} = "$dir/$base.log";
	return $ok;
}

sub _load_image {
	## Load image in preview window
	my ($self, $file) = @_;

	my $win = $self->{image_window};
	$win->remove($_) for $win->get_children;
	my $image = Gtk2::Image->new_from_file($file);
		# uses missing image icon if file does not exist
	my $align = Gtk2::Alignment->new(0.5, 0.5, 0, 0);
	$align->set_padding(10, 10, 5, 5); # need whitespace around image
	$align->add($image);
	$win->add($align);
	$win->show_all;
}

=item C<view_log()>

Open a dialog with a TextView showing the dot log file.

=cut

sub view_log {
	my $self = pop; # pop because we can be called from signal

	my $dialog = Gtk2::Dialog->new(
		__("Diagram Editor Log"), $self->{dialog}, #. dialog title
	       	[qw/modal destroy-with-parent/],
		'gtk-close' => 'ok',
	);
	$dialog->set_resizable(1);
	$dialog->set_default_size(600, 300);
	my ($win, $text) = $self->new_textview(
		''.file($$self{log_file})->read );
	$dialog->vbox->add($win);
	$dialog->show_all;
	$dialog->run;
	$dialog->destroy;
}

=item C<populate_popup(MENU, PIXBUF)>

Add menu items for editing diagrams. PIXBUF is the image object passed on by
L<Zim::PageView>.

=cut

sub populate_popup {
	my ($self, $menu, $pixbuf) = @_;
	my $file = $pixbuf->{image_data}{src};
		# use 'src' not 'file' because we want to use resolve_file
		# later on to retrieve object in save()
	
	# Separator
	my $seperator = Gtk2::SeparatorMenuItem->new();
	$seperator->show;
	$menu->prepend($seperator);

	# Edit object
	my $edit_item = Gtk2::MenuItem->new(__('_Edit Diagram')); #. context menu
	$edit_item->show;
	$edit_item->signal_connect_swapped(
		activate => sub { $self->show($file) } );
	$menu->prepend($edit_item);
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2007 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

