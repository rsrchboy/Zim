package Zim::Store;

use strict;
use Carp;
use Zim::Page;
use Zim::Utils;

our $VERSION = '0.26';

=head1 NAME

Zim::Store - Base class for page storage objects

=head1 DESCRIPTION

This is a base class for storage backends.
It documents the interface expected to handle page objects.
It provides a number of stub methods and some logic that is common to most
stores.

When implementing a new store at least implement C<get_page()>,
C<resolve_name()> or C<resolve_case()>. When implementing a
store that is writable C<delete_page()> also needs to be there.
You might want to implement a native C<copy_page()> and C<move_page()>
also then.
To make your pages show up in the side pane implement C<list_pages()>.
All other methods are optional.

Note that when a page name is given it is always given fully-specified,
so you need to take into account your own namespace prefix.

It is good practice to throw an exception when a method fails.
This way the GUI knows that something went wrong and can alert the user.

=head1 METHODS

=over 4

=item new(parent => PARENT, namespace => NAMESPACE, ...)

Simple object constructor.
PARENT can be a parent repository object or undef.
NAMESPACE is the prefix for all pages managed by this store.

=cut

sub new {
	my $class = shift;
	my %param = @_;
	$param{namespace} ||= ':' ;
	$param{namespace} =~ s/:?$/:/;
	$param{indexpage} ||= $param{namespace};
	$param{indexpage} =~ s/:*$//;
	my $self = bless {%param}, $class;
	$self->init();
	return $self;
}

=item C<init()>

Stub init function, to be overloaded.

=cut

sub init { }

=item C<list_pages(NAMESPACE)>

This method should return a list of pages in NAMESPACE.
The list is used by the gui to produce a hierarchical index,
it does not tell anything about the actual existence of the pages.

The default returns an empty list.

=cut

sub list_pages { }

=item C<get_page(NAME)>

This method is expected to return a page object for NAME.
See L<Zim::Page> for an example.

When a page does not exist an empty object should be returned
that can be used to create this page by saving to it.
The status of this object should be set to 'new'.
When a page does not exists and can not be created undef should
be returned.

The default does nothing.

=cut

sub get_page {
	my @c = caller;
	die "BUG: ".ref($_[0])."->get_page() not implemented\n" .
	    "     called from: @c\n"
}

=item C<resolve_page(LINK, PAGE, NO_DEFAULT)>

Convenience function packing C<resolve_name()> and C<get_page()>.

=cut

sub resolve_page {
	my $self = shift;
	my $name = $self->resolve_name(@_);
	return $name ? $self->root->get_page($name) : undef ;
}

=item C<resolve_name(NAME, REF, NO_DEFAULT)>

Resolves a page relative to a given path. Does an upward search through
the path for relative links. This search is depth first (or actually
"surface first"), since checking the given path is cheaper than doing
a in width search.

* make name case sensitive
* match name against REF
* check existence

for matching only use first element of NAME
either anchored in path REF or an existing leaf of REF
match case-insensitive.

when a match is found the remainig parts of NAME
need to be resolved to put them in correct case

without REF, or when NAME starts with ':'
we consider the absolute name a direct match
and continue with resolving case

when no match is found a default is returned
unless NO_DEFAULT is set
this default is the REF minus the last part plus
all parts of NAME in their original case

=item C<resolve_case(\@NAME, \@REF)>

B<Private> method called by C<resolve_name()>.
To be overloaded by child classes.

NAME contains the parts of the pagename we are looking for.
REF contains parts of the pagename we use as base for a relative lookup.
Try to match the first part of NAME in the path defined by REF.
If REF is undefined, just start from ":".

Should return a case sensitive page name.

=cut

sub resolve_name { #warn "resolve_name(@_)\n";
	my ($self, $link, $page, $no_def) = @_;
	my @link = grep length($_), split /:+/, $link;
	my @page = $page ? (grep length($_), split /:+/, "$page") : ();
	my $anchor = lc $link[0];
	my $name;
	if ($link =~ /^:/ or ! @page) { # absolute name
		my @copy = @link;
		$name = $self->resolve_case(\@link) || ':'.join ':', @copy;
	}
	elsif (grep {lc($_) eq $anchor} @page) { # anchored in path
		my ($i) = grep {lc($page[$_]) eq $anchor} reverse 0 .. $#page;
		shift @link; # shift anchor
		splice @page, $i+1, $#page, @link;
		my @copy = @page;
		$name = $self->resolve_case(\@page) || ':'.join ':', @copy;
	}
	else { # match in width
		pop @page; # pop basename
		my @copy = (@page, @link);
		$name = $self->resolve_case(\@link, \@page);
		$name ||= ':'.join(':', @copy) unless $no_def;
	}
	#warn "Resolved $link to $name\n";
	return $name;
}

sub resolve_case {
	my @c = caller;
	die "BUG: ".ref($_[0])."->resolve_case() not implemented\n" .
	    "     called from: @c\n"
}

=item C<copy_page(SOURCE, TARGET)>

Copy contents of object SOURCE to object TARGET.
Both page objects should belong to this store.

Make sure to update the page objects correctly.
For example set status and update or flush the parse tree.

=cut

sub copy_page {
	my ($self, $source, $target) = @_;
	croak "usage: copy_page(OBJECT, OBJECT)"
		unless ref $source and ref $target;
	$target->clone($source, media => 'none');
}

=item C<move_page(SOURCE, TARGET)>

Move the content of object SOURCE to object TARGET.
Both page objects should belong to this store.

Make sure to update the page objects correctly.
For example set status and update or flush the parse tree.

The default just calls C<copy_page()> and C<delete_page()>.

=cut

sub move_page {
	my ($self, $source, $target) = @_;
	croak "usage: move_page(OBJECT, OBJECT)"
		unless ref $source and ref $target;
	$self->copy_page($source, $target);
	$source->delete;
}

=item C<delete_page(PAGE)>

Delete object PAGE and returns the page object.
Be aware that although the content is deleted the PAGE object
goes on living and should be updated accordingly.
The status of the object should be set to 'deleted'.

The default method fails by exception.

=cut

sub delete_page { 
	my @c = caller;
	die "BUG: ".ref($_[0])."->delete_page() not implemented\n" .
	    "     called from: @c\n"
}

=item C<search()>

TODO

=cut

sub search { } # make this dispatch to specific methods for each type, use array to order by cost

=back

=head2 Document Interface

This interface is used to deal with external documents that belong to the
notebook. Think of these documents as attachments.

The documents are stored as files in a directory that may or may not be the
same as the directory where page contents are stored. The parent object has an
attribute "document_dir" to specify the document root directory.

The "document_root" is an alternative directory. This is used as a top level
directory to find _external_ documents (not considered attachments). This can
for example be a parent directory of document_dir or some totally unrelated dir.

=over 4

=item C<document_dir(PAGE)>

Returns the document dir for PAGE.
Returns the toplevel dir if PAGE is undefined.

=cut

sub document_dir {
	my ($self, $page) = @_;

	my $root = $$self{parent}{dir} || $$self{dir};
	return $root unless defined $page;
	return $$page{document_dir} if defined $$page{document_dir}; # cache

	# encoding logic same as in Zim::Store::Files
	my @parts =
		map {s/\%([A-Fa-z0-9]{2})/chr(hex($1))/eg; $_}
		grep length($_), split /:+/, "$page";
	my $dir = $root->resolve_dir(undef, @parts);

	$$page{document_dir} = $dir; # cache
	return $dir;
}

=item C<document_root()>

Returns the document root directory or undef.

=cut

sub document_root { $_[0]{parent}{document_root} || $_[0]{document_root} }

=item C<store_file(FILE, PAGE, NAME, MOVE)>

Stores a file in the document dir for PAGE, or in the toplevel dir if PAGE
is not specified. Returns a path that can be used to link this file.

NAME is optional and gives the desired file name to store. If NAME is not
provided the name of FILE is used.

If MOVE is true the original file is moved instead of copied.

If the name is identical to that of an existing file a number will appended
before the file extension in order to make the name unique. If the name
contains a sequence 'XX' (or longer) this sequence will be replaced with a
number such that the part of the name up to and including the 'XX' is unique.
(So file extension does not matter). This can be used to attach a group of
files with the same basename while making sure that none of them conflicts
with an existing file.

=cut

sub store_file {
	my ($self, $file, $page, $name, $move) = @_;
	$name ||= $file->name;
	my $dir = $self->document_dir($page);
	my $new_file = $dir->file( _unique_name($dir, $name) );
	$move ? $file->move($new_file)
	      : $file->copy($new_file) ;
	return './'.$new_file->rel_path;
		# should be identival as the result of:
		# $self->relative_path($file, $page)
}

sub _unique_name {
	# generate an unique file name
	my ($dir, $name) = @_;
	my $i = 1;
	my $fmt = $name;
	$fmt =~ s/\%/\%\%/g; # escape literal %
	if ($fmt =~ /XX/) {
		# Explicit pattern, make sure basename is unique
		# regardless of file extensions etc.
		$fmt =~ s/(XX+).*/'%0'.length($1).'d'/e;
		my $unique = sprintf $fmt, $i;
		while ( _grep_dir($dir, $unique) ) {
			$unique = sprintf $fmt, ++$i;
		}
		$name =~ s/^.*?XX+/$unique/;
	}
	elsif (-e "$dir/$name") {
		# Implicit pattern, only append number if exact name
		# exists.
		$fmt =~ s/(\.|$)/_\%02d$1/;
		$name = sprintf $fmt, $i;
		while (-e "$dir/$name") {
			$name = sprintf $fmt, ++$i;
		}
	}
	return $name;
}

sub _grep_dir {
	my ($dir, $string) = @_;
	my @match = glob quotemeta($dir.$string).'*';
		# Without the quotemeta you can end up in infinite loops
		# when the name for e.g. contains a whitespace :(
	return scalar @match;
}

=item C<resolve_file(PATH, PAGE)>

PAGE is an optional argument.

This method resolves links to files, the argument can be either a 
file:// url or a path starting with either './', '../', '~/' or '/'.

In case an url or a path starting with '~/' is used these are considered
absolute paths.

In case the path starts with './', '../' the file is resolved relative to
the document dir for PAGE. If PAGE is not given the top level document dir
is used.

In case the path starts with '/' the document root is used. This can be the
toplevel document dir but may also be some other dir. If no document root
is set, the file system root is used.

=cut

sub resolve_file {
	my ($self, $path, $page) = @_;
	my ($doc_root, $doc_dir, $doc_dir_root) = (
		$self->document_root(),
		$self->document_dir($page),
		$self->document_dir(),
	);
	
	if ($path =~ m#^/#) {
		# path below document root
		$path = Zim::FS->clean_path($path);
		$path =~ s/^(\.\.\/)+//; # force below document root
		return $doc_root ? $doc_root->file($path) : file($path) ;
	}


	if ($path =~ m#^(\w+[\w\+\-\.]+)://#) { # url
		$path = Zim::FS->uri2path($path);
	}
	elsif ($path =~ m#^~#) { # relative to home dir
		$path = Zim::FS->abs_path($path);
	}
	else { # relative to document dir
		my $p = Zim::FS->abs_path($path, $doc_dir);
		unless (-f $p) {
			# Compatibility with logic of version < 0.24
			# Use same dir as page instead of one below
			my $q = Zim::FS->abs_path($path, $doc_dir->dir);
			$path = -f $q ? $q : $p;
		}
		else { $path = $p }
	}

	my $vcs = $$self{parent}{vcs};
	for (grep defined($_), $doc_dir, $doc_dir_root, $doc_root, $vcs) {
		# Check whether we can nest this file under one of our dirs
		# this is needed in case dirs are under version control etc.
		my $rel = Zim::FS->rel_path($path, $_);
		return $_->file($rel) if defined $rel;
	}

	return file($path); # file outside any of our default dirs
}

=item C<relative_path(PATH, PAGE)>

Returns a path relative to the document dir for page, the document root
or the users home directory. Returns a complete path or file uri otherwise.
This is used to turn paths that are inserted into links and keep them readable.
PAGE is an optional argument.

=cut

sub relative_path {
	my ($self, $path, $page) = @_;
	$path = Zim::FS->uri2path($path) if $path =~ m#^file://#;
	return $path if $path =~ m#^\w[\w\+\-\.]+:/#; # url
	return $path unless Zim::FS->is_abs_path($path);

	# Return relative to doc_dir when path is below doc_dir_root
	my ($doc_dir, $doc_dir_root) =
		( $self->document_dir($page), $self->document_dir() );
	return Zim::FS->rel_path($path, $doc_dir, 'UP')
		if Zim::FS->rel_path($path, $doc_dir_root);
	
	# Else return relative to doc_root
	my $doc_root = $self->document_root;
	if ($doc_root) {
		my $rel = Zim::FS->rel_path($path, $doc_root);
		if ($rel) {
			$rel =~ s/^\.//; # comform to logic in resolve_file()
			return $rel;
		}
	}

	# Else return relative to HOME
	if (my $rel = Zim::FS->rel_path($path, $ENV{HOME})) {
		$rel =~ s/^\./\~/;
		return $rel;
	}

	# Else just return the path, turn into uri if doc_root exists
	# to comfirm with logic in resolve_file()
	return defined($doc_root)
		? Zim::FS->path2uri($path)
		: Zim::FS->abs_path($path) ;
		# need abs_path() here to get rid of OS specific stuff
		# on e.g. win32
}

=back

=head2 Utility methods

These methods are commonly used methods in store objects.
They do not need to be overloaded.

=over 4

=item C<clean_name(NAME, RELATIVE)>

Class function that returns a sanatized page name.
Removes forbidden chars etc.

If RELATIVE is true the name is not made absolute.

=cut

sub clean_name {
	my (undef, $name, $rel) = @_;
	#print STDERR "resolved $name to ";
	$name =~ s/^:*/:/ unless $rel;		# absolute name
	$name =~ s/:+$//;			# not a namespace
	$name =~ s/::+/:/g;			# replace multiple ":"
	$name =~ s/[^:\w\.\-\(\)\%]/_/g;	# replace forbidden chars
	$name =~ s/(:+)[\_\.\-\(\)]+/$1/g;	# remove non-letter at begin
	$name =~ s/_+(:|$)/$1/g;		# remove trailing underscore
	#print STDERR "$name\n";
	$name = undef if $name eq ':';
	return $name;
}

=item C<root()>

Returns the top parent repository object. This is used to get pages when
we are not sure these pages belong to our store.

=cut

sub root {
	my $self = shift;
	my $obj = $self;
	while (
		defined $obj->{parent}
		and ref($obj->{parent}) ne 'HASH' # Auto-Vivication Grrr
	) {
		$obj = $obj->{parent};
		last if $obj eq $self; # prevent infinite loop
	}
	return $obj;
}

=item C<check_dir()>

Checks for a "dir" attribute, else check if parent has a dir and derives
from that. Dies on failure.
Used when initializing store sub-classes that are dir based.

=cut

sub check_dir {
	my $self = shift;
	return if ref $$self{dir}; # already an object

	if (defined $$self{dir}) {
		# check if we can get dir relative to parent
		my $dir = Zim::FS->abs_path($$self{dir});
		my $parent = $$self{parent}{dir};
		my $rel = $parent
			? Zim::FS->rel_path($dir, $parent) 
			: undef ;
		$$self{dir} = defined($rel)
			? $parent->subdir($rel)
			: dir($dir) ;
	}
	else {
		# no dir given, find one based on namespace
		die ref($self)." needs a directory to initialize\n"
			unless length $$self{parent}{dir};
		my @parts = grep length($_), split /:+/, $self->{namespace};
		$$self{dir} = $$self{parent}{dir}->resolve_dir(undef, @parts);
	}
	
	warn "## '$$self{namespace}' using dir: $$self{dir}\n";
}

=item C<check_file()>

Check if a "file" attribute is set and make sure "dir" is set based on that.
Used when initializing store sub-classes that are file based.

=cut

sub check_file {
	my $self = shift;
	die ref($self)." needs a file to initialize\n"
		unless defined $$self{file};

	unless (ref $$self{file}) {
		# If file is not an object, see if we can get it
		# relative to the parent dir
		my ($file, $dir) = ($$self{file}, $$self{parent}{dir});
		$file = Zim::FS->abs_path($file, $dir);
		my $rel = defined($dir)
			? Zim::FS->rel_path($file, $dir)
			: undef ;
		$$self{file} = defined($rel) ? $dir->file($rel) : file($file) ;
	}

	$$self{dir} = $$self{file}->dir;
		# Used for e.g. for the document dir etc.
		# so needs to be defined.
}

=item C<wipe_array(REF)>

Removes double items from the array refered to by ref.

=cut

sub wipe_array {
	my $ref = pop;
	@$ref = sort @$ref;
	my $prev = '';
	for (@$ref) {
		if ($_ eq $prev) { $_ = undef }
		else             { $prev = $_ }
	}
	@$ref = grep defined($_), @$ref;
	return $ref;
}

1;

__END__

=back

=head1 BUGS

Please mail the author if you find any bugs.

=head1 AUTHOR

Jaap Karssenberg || Pardus [Larus] E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>

=cut
