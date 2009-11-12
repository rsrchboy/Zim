package Gtk2::Ex::DesktopEntryMenu;

use strict;
use Gtk2;
use File::Spec;
use File::BaseDir qw/xdg_data_files/;
use File::MimeInfo::Magic;
use File::MimeInfo::Applications;

our $VERSION = '0.20';

our $STYLE = 'auto'; # either "auto" "menu" or "plain"

=head1 NAME

Gtk2::Ex::DesktopEntryMenu - Generate menu items to open files

=head1 SYNOPSIS

	use Gtk2::Ex::DesktopEntryMenu style => 'auto';

	sub on_populate_popup {
		# ...
		Gtk2::Ex::DesktopEntryMenu->populate_menu($menu, $hyperlink)
			if $hyperlink =~ m#^file://# ;
		# ..
	}

=head1 DESCRIPTION

This module offers an "open with" menu and a simple editor dialog
to allow users to open a file with an application that can handle it.

This is a GUI wrapper for C<File::MimeInfo::Applications>.

TODO: add Dialog to select application or set custom command

TODO: win32 exec code

TODO: way to force using magic

=head1 OPTIONS

There is one option which can be given with the C<use> statement.

This is the B<style> option. The style can be either "plain",
"menu" or "auto". When not given it defaults to "auto". When the style
is "plain" all items are included in the menu, when the style is
"menu" all items are put in a "Open With" submenu. In the case of
"auto" the items are put into a submenu when there are more than
4 applications.

=head1 METHODS

=over 4

=cut

sub import {
	my ($class, %opts) = @_;
	die "Unkonw style: $opts{style}"
		if  defined  $opts{style}
		and ! grep { $opts{style} eq $_ } qw/auto plain menu/;
	$STYLE = $opts{style} if defined $opts{style};
}

=item C<populate_menu(MENU, FILE, MIMETYPE, STYLE)>

Convenience method that adds all applictions that can open this file
to the menu.

MENU should be of class L<Gtk2::Menu>.
MIMETYPE is optional and FILE can either be a filename or an array reference
with filenames.

STYLE can be used to override the default style.

=cut

sub populate_menu {
	my ($class, $menu, $file, $mimetype, $style) = @_;
	$style ||= $STYLE;
	
	my @items = $class->menuitems($file, $mimetype);

	# if no items add insensitive item
	unless (@items) {
		my $item = Gtk2::MenuItem->new('_Open');
		$item->set_sensitive(0);
		push @items, $item;
	}

	if (
		($style eq 'menu' and @items > 1) or
		($style eq 'auto' and @items > 4)
	) { # use a submenu
		my $item = Gtk2::MenuItem->new('Open _With ...');
		$menu->prepend($item);
		$item->show;

		my $submenu = Gtk2::Menu->new;
		$item->set_submenu($submenu);
		$submenu->show;

		my $first = shift @items;
		$menu->prepend($first);
		$first->show;

		$menu = $submenu;
	}

	for (reverse @items) {
		$menu->prepend($_);
		$_->show;
	}
}

=item C<menuitems(FILE, MIMETYPE)>

Returns a list with L<Gtk2::MenuItem> objects for FILE with MIMETYPE.

MIMETYPE is optional and FILE can either be a filename or an array reference
with filenames.

=item C<menuitem(ENTRY, FILE, IS_DEFAULT)>

Returns a L<Gtk2::MenuItem> object for a L<File::DesktopEntry> object
that opens FILE when activated.

IS_DEFAULT can be used to tell that this is the default application.

=cut

sub menuitems {
	my ($class, $file, $mimetype) = @_;
	
	$mimetype ||= _mimetype($file);
	return unless $mimetype;
	
	my @entries = mime_applications($mimetype);
	return unless @entries;
	#warn join "\n", map {$_ ? $_->{file} : $_} @entries, '';

	my @names;
	for my $entry (grep defined($_), @entries) {
		$entry->{file} =~ /([\w\-\.]+)$/;
		my $name = $1;
		$entry = undef if grep {$_ eq $name} @names;
		push @names, $name;
	}
	
	my $default = shift @entries;
	@entries = grep defined($_), @entries;
	my @items = $default ? ($class->menuitem($default, $file, 1)) : () ;
	while (@entries) {
		push @items, $class->menuitem(shift(@entries), $file);
	}

	return @items;
}

sub _mimetype {
	my $file = shift;
	$file = $$file[0] if ref $file;
	$file =~ s#^file://##;
	my $mt = mimetype($file);
	#warn "Found mimetype $mt for $file\n";
	return $mt;
}

sub menuitem {
	my ($class, $entry, $file, $default) = @_;
	
	my $label = ($default ? '_Open With ' : 'Open With ')
	            . '"' . $entry->get_value('Name') . '"' ;
	my $icon = $entry->get_value('Icon');
	
	my $pixbuf = length($icon) ? $class->icon_pixbuf($icon, 'menu') : undef ;
	my $image = $pixbuf  ? Gtk2::Image->new_from_pixbuf($pixbuf)
	          : $default ? Gtk2::Image->new_from_stock('gtk-open', 'menu')
		  : undef ;
	
	my $item = Gtk2::ImageMenuItem->new($label);
	$item->set_image($image) if $image;
	$item->{file} = $file;
	$item->{entry} = $entry;
	$item->signal_connect(activate => \&on_item_activated);
	return $item;
}

sub on_item_activated {
	my $item = shift;
	my ($entry, $file) = @$item{'entry', 'file'};
	unless (fork) { # child process
		eval { $entry->exec(ref($file) ? @$file : $file) };
		warn $@ if $@;
		exit 1;
	}
}

=item C<icon_pixbuf(NAME, SIZE)>

Returns a pixbuf for the application icon or undef.
NAME can either be a full file name, a partial file name or just the name
of something in the theme directories. SIZE is a L<Gtk2::IconSize> name.

=cut

sub icon_pixbuf {
	my (undef, $name, $size) = @_;

	my @size = Gtk2::IconSize->lookup($size);
	if (File::Spec->file_name_is_absolute($name)) {
		return undef unless -f $name and -r _;
		return Gtk2::Gdk::Pixbuf->new_from_file_at_size($name, @size);
	}
	else {
		$name =~ s/\..*$//; # remove extension
		my $icontheme = Gtk2::IconTheme->get_default;
		my $pixbuf = eval { $icontheme->load_icon($name, $size[0], []) };
		return $@ ? undef : $pixbuf;
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

