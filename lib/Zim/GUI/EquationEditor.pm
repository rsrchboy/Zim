package Zim::GUI::EquationEditor;

use strict;
use Zim::Utils;
use Zim::GUI::Component;
use Zim::Template;

our @ISA = qw/Zim::GUI::Component/;

our $VERSION = '0.28';

our %DEFAULTS = (
	latex => 
	'latex -no-shell-escape -halt-on-error -output-directory %2 %1',
	dvipng =>
	'dvipng -q -bg Transparent -T tight -o %2 %1',
);


=head1 NAME

Zim::GUI::EquationEditor - Equation editor for Zim

=head1 DESCRIPTION

This module provides the equation editor dialog for Zim.
It requires latex to generate the actual equation image.

=head1 METHODS

=over 4

=item C<show(PATH)>

Open the equation editor. If PATH is given it is the "src" path to an exiting
image (the corresponding .tex file is also assumed to exit). This path is
resolved relative to the current page.

=cut

sub init {
	my $self = shift;
	$self->init_settings('EquationEditor Plugin', \%DEFAULTS);

	# Test if the applications are available
	my $null = File::Spec->devnull;
	my ($latex, $dvipng) = @{$$self{settings}}{qw/latex dvipng/};
	for ($latex, $dvipng) {
		/^(\S+)/; # match base command
		system("$1 -v > $null") == 0 and next;
		
		my $error = __('Can not find application "{name}"', name => $1); #. error when external application is not found
		$self->error_dialog($error);
		$$self{app}->unplug('EquationEditor');
		die $error."\n";
	}
}

sub show {
	my ($self, $src) = @_;

	my $dialog = Gtk2::Dialog->new(
		__("Equation Editor"), $self->{app}{window}, #. dialog title
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

	my $lbutton = $self->{app}->new_button(
		'gtk-file', __('View _Log') ); #. button
	$lbutton->signal_connect(clicked => \&view_log, $self);
	$hbox->pack_start($lbutton, 0,1,0);
	$lbutton->set_sensitive(0);
	$self->{log_button} = $lbutton;

	$dialog->show_all;
	$win1->set_no_show_all(0);
	$self->{compiled} = 0;

	# For an existing image load both the image and the tex source
	# throw an error if the asociated tex does not exist.
	if ($src) {
		my $img = $$self{app}{page}->resolve_file($src);
		my $tex = $img->path;
		$tex =~ s/\.png$/.tex/;
		return $self->{app}->error_dialog(
			__("The equation for image: {path}\nis missing. Can not edit equation.", path => $img->path) ) #. error when no .tex file exists
			unless -e $tex;
		$self->_load_image($img);
		$self->{buffer}->set_text( file($tex)->read || '' );
	}

	# Run the dialog
	while (my $response = $dialog->run) {
		if ($response eq 'help') {
			$self->{app}->ShowHelp(
				':usage:plugins:EquationEditor' );
			next;
		}
		elsif ($response eq 'ok') {
			last if ! $self->{compiled}
			     && ! $self->{buffer}->get_modified;
				# Equation was not edited => cancel
			my $img = $self->save($src);
			next unless defined $img;
			$img .= '?type=equation';
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
			for <$tmpdir/zim-$ENV{USER}-$$-EquationEditor.*>;
	};
}

=item C<save(PATH)>

Compile equation and save it to the namespace for the current page.
PATH is an optional argument which is given in case we are editing
an already existing equation. Returns the path for the image.

=cut

sub save {
	my ($self, $src) = @_;

	## Compile
       	$self->compile if $self->{buffer}->get_modified;
	my $tmp_img = $$self{img_file};
	unless (-e $tmp_img) {
		my $r = $self->{app}->prompt_question( 'warning',
			'<b>'.__('The equation failed to compile. Do you want to save anyway?').'</b>', #. warning dialog, answers are 'save' or 'cancel'
			[cancel => 'gtk-cancel'],
			[save   => 'gtk-save'  ]  );
		return unless $r eq 'save';
	}

	## Save text and store image under the same name
	## Do not copy tmp tex file, we do not want the template
	my $page   = $$self{app}{page};
	my $buffer = $$self{buffer};
	my $text   = buffer( $buffer->get_text($buffer->get_bounds(), 0) );
	if ($src) {
		# overwrite existing file
		# we call resolve_file to make sure we get a file object
		# that is properly nested below doc_dir or doc_root
		my $tex = $src;
		$tex =~ s/\.png$/.tex/ or die;
		my $img = $page->resolve_file($src);
		file($tmp_img)->copy($img);
		$page->resolve_file($tex)->write($text->read);
	}
	else {
		# store under a new unique name
		my $path = $page->store_file($text, 'equation_XX.tex');
		$path =~ m#(equation_\d+)# or die;
		my $img = $1.'.png';
		return $page->store_file(file($tmp_img) => $img);
	}
}

=item C<compile()>

Compiles the equation in the tmp dir and shows a preview in the dialog.

=cut

sub compile {
	my $self = pop; # pop because we can be called from signal

	# Logic similar to Zim::FS->tmp_file for creating tmp files
	# Include user name and PID to avoid collisions
	my $tmpdir = Zim::FS->tmpdir;
	my $tex = "$tmpdir/zim-$ENV{USER}-$$-EquationEditor.tex";

	my $mask = umask 0077; # set umask to user only

	## Get text - remove empty lines, not allowed in tex equation block
	my $text = $self->{buffer}->get_text(
		$self->{buffer}->get_bounds(), 0 );
	$text =~ s/\n+/\n/g;
	$text =~ s/^\n*|\n*$//g;

	## Write using template
	my $template = Zim::Formats->lookup_template('latex' => '_Equation');
	die "Could not find template latex/_Equation" unless $template;
	$template = Zim::Template->new($template);
	warn "# Writing $tex\n";
	$template->process({equation => $text} => $tex);

	## Generate Image
	$tex =~ /^(.*)\/(.*?)\.tex$/ or die "BUG: \"$tex\" failed regex";
	my ($dir, $base) = ($1, $2);
	my ($latex, $dvipng) = @{$$self{settings}}{qw/latex dvipng/};
	$latex =~ s/\%1/$base.tex/g;
	$latex =~ s/\%2/$dir/g;
	$dvipng =~ s/\%1/$dir\/$base.dvi/g;
	$dvipng =~ s/\%2/$dir\/$base.png/g;

	## Run commands
	my $ok = (system($latex) == 0 and system($dvipng) == 0);
	warn "Generating equation failed: $!\n" if $?;
	
	umask $mask; # reset old umask
	
	## Make sure we don't leave a broken image
	my $img = $tex;
	$img =~ s/\.tex$/.png/;
	unlink $img or die $! if ! $ok and -f $img;

	## Update dialog
	$self->_load_image($img);
	$self->{compiled} = 1;
	$self->{buffer}->set_modified(0);
	$self->{log_button}->set_sensitive(1);
	$self->{tex_file} = $tex;
	$self->{img_file} = $img;
	$self->{log_file} = "$dir/$base.log";
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

Open a dialog with a TextView showing the latex log file.

=cut

sub view_log {
	my $self = pop; # pop because we can be called from signal

	my $dialog = Gtk2::Dialog->new(
		__("Equation Editor Log"), $self->{dialog}, #. dialog title
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

Add menu items for editing equations. PIXBUF is the image object passed on by
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
	my $edit_item = Gtk2::MenuItem->new(__('_Edit Equation')); #. context menu
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

