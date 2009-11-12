package Zim::Page;

use strict;
use overload
	'""' => sub { $_[0]->{name} },
	fallback => 'TRUE' ;
use Carp;
use Zim::Utils;
use Zim::Formats;

our $VERSION = '0.27';

our %_Formats;

=head1 NAME

Zim::Page - Page object for Zim

=head1 DESCRIPTION

This class defines a page object. A page is the unit of data as presented
to the user. The source of the data is managed by L<Zim::Store> objects.

=head1 OVERLOAD

This class overloads the '""' operator, so the string version of an object
is the page name.

=head1 METHODS

=over 4

=item C<new(PARENT, NAME)>

Simple constructor. PARENT should be a repository object of class Zim.
NAME is the page name for this object.

=cut

sub new {
	my ($class, $parent, $name) = @_;
	$name =~ s/:+$//;
	croak "BUG: Can't create a $class object without a page name"
		unless length $name;
	$name =~ s/^:?/:/;
	my $self = bless {
		name	=> $name,
		store	=> $parent,
		root	=> ($parent ? $parent->root : undef),
		exists	=> 1, # only used when no source set
		status	=> '',
		properties => {read_only => 1},
	}, $class ;
	return $self;
}

=item C<properties()>

Returns a hash with properties. See L</PROPERTIES>.

=cut

sub properties { $_[0]->{properties} }

=item C<name()>

Get or set the full name of the page.

=cut

sub name {
	$_[0]->{name} = $_[1] if @_ > 1;
	return $_[0]->{name};
}

=item C<basename()>

Returns the last part of the page name.

=cut

sub basename {
	my $name = $_[0]->{name};
	$name =~ s/^(.*:+)//;
	return $name;
}

=item C<split_name()>

=cut

sub split_name {
	my $name = pop;
	$name = $name->{name} if ref $name;
	#print STDERR "namespace for $name ";
	$name =~ s/^(.*:)//;
	my $ns = $1 || ':';
	$ns =~ s/::+/:/g;
	#print STDERR "is $name\n";
	return ($ns, $name);
}

=item C<namespace()>

Returns the namespace to which this page belongs.

=item C<namespaces()>

Like C<namespace()> but returns the namespace path as a list.

=cut

sub namespace { (&split_name)[0] }

sub namespaces {
	my $name = pop;
	$name = $name->{name} if ref $name;
	$name =~ s/^:+|:+$//g;
	my @ns = split /:+/, $name;
	pop @ns;
	return @ns;
}

=item C<status(STRING)>

Set or get a status string for this page.
Typical status strings are 'new' and 'deleted'.

=cut

sub status {
	$_[0]->{status} = $_[1] if @_ > 1;
	return $_[0]->{status};
}

=item C<exists()>

Returns TRUE if the page already exists.

=cut

sub exists { $_[0]->{source} ? $_[0]->{source}->exists : $_[0]->{exists} }

=item C<copy(TARGET, UPDATE_LINKS)>

=item C<move(TARGET, UPDATE_LINKS)>

=item C<delete()>

The methods C<copy()>, C<move()> and C<delete()> are aliases for the methods
C<copy_page()>, C<move_page()> and C<delete_page()> in the public store
interface; see L<Zim::Store>.

TARGET is the new name for the page. The UPDATE_LINKS argument is a boolean
that tells whether links to this page should be updated to point to this
new name.

=cut

sub copy { $_[0]->{root}->copy_page(@_) }

sub move {
	$_[0]->{_resolve} = {}; # clear links - FIXME update here ?
	$_[0]->{root}->move_page(@_);
}

sub delete { $_[0]->{store}->delete_page(@_) }

=item C<parse_link(LINK, NO_RESOLVE)>

Returns a link type and a link target, see L<Zim::Formats>.

=cut

sub parse_link {
	my $self = shift;
	# No cloning hack here, we only need to resolve pages from the
	# notebook we are cloning, not files, interwiki etc.
	# So cloning is take care of in resolve_name
	my $fmt = $self->{format} || 'Zim::Formats';
	return $fmt->parse_link(shift, $self, @_);
}

=item C<resolve_page(NAME, NO_DEFAULT)>

Caching wrapper for C<$repository->resolve_page(NAME, PAGE, NO_DEFAULT)>.

=item C<resolve_name(NAME, NO_DEFAULT)>

Caching wrapper for C<$repository->resolve_name(NAME, PAGE, NO_DEFAULT)>.

=cut

sub resolve_page {
	my $self = shift;
	my $name = $self->resolve_name(@_);
	return $name ? $self->{root}->get_page($name) : undef ;
}

sub resolve_name {
	my ($self, $link, $no_def) = @_;
	return $self->{cloning}->resolve_name($link, $no_def)
		if $self->{cloning};
		# 'cloning' hack needed when exporting because we may need
		# to resolve pages that do not yet exist in our new notebook.
		# So we use the notebook we are cloning from.
	
	if (my $r = $self->{_resolve}{$link}) {
		# Caching
		return ( ($no_def && $$r[1]) ? undef : $$r[0] )
	}

	my $name = $self->{root}->resolve_name($link, $self, 1);
	if ($name) {
		$self->{_resolve}{$link} = [$name, 0];
	}
	else { # default
		$name = $self->namespace . $link;
		$self->{_resolve}{$link} = [$name, 1];
	}

	return $name;
}

=item C<match_word(WORD)>

TODO: stable api for this

=cut

sub match_word { # TODO optimize by caching found links
	my ($self, $word) = @_;
	return $self->{store}->can('_match_word')
		? $self->{store}->_match_word($self, $word)
		: undef ;
}

=item C<equals(PAGE)>

Check if PAGE is refering to the same page we are.
This does not guarantee that the actual content is the same.

=cut

sub equals {
	my ($self, $page) = @_;
	return $page eq $self->{name} unless ref $page; 
	return 0 if $page->{store} ne $self->{store}; # compare ref string
	return $self->{name} eq $page->name;
}

=item C<clone(PAGE, media => MEDIA, doc_root => PREFIX)>

Import content from page object PAGE into this object.
PAGE typically belongs to a different notebook.
Deletes current contents.

MEDIA can be 'none', 'default' or 'all'. When 'none' is set no media is copied.
When 'default' is set all files below the document dir root are copied.
For 'all' we automatically attach external files.

PREFIX is a prefix we use for links under the document root. If this is set
any files under the document root will not be copied for any setting of MEDIA.

=cut

sub clone {
	my ($self, $page, %opt) = @_;
	local $self->{cloning} = $page;
	#if ( $self->{format} and $page->{format} ) {
		$self->delete if $self->exists; # prevent mtime check etc.
		my $tree = $page->get_parse_tree;
		$self->_check_media($tree, $page, %opt);
		$self->set_parse_tree($tree);
	#}
	#else { warn "Could not clone page: ". $page->name ."\n" }
}

# Check for all file links and image in the parse tree if we need
# to copy the corresponding files to the exported file tree

sub _check_media {
	my ($self, $tree, $cloning, %opt) = @_;
	$opt{media} ||= 'default';
	$opt{doc_root} = $$self{store}->document_root;
	die "BUG: unknown media option: $opt{media}"
		unless grep {$opt{media} eq $_} qw/none default all/;
	
	for my $l (Zim::Formats->extract_refs('link', $tree)) {
		my ($type, $link) = $cloning->parse_link($$l[1]{to});
		next unless $type eq 'file';
		$$l[1]{to} = $self->_copy_media($link, $cloning, %opt);
	}

	for my $i (Zim::Formats->extract_refs('image', $tree)) {
		my $link = delete $$i[1]{file};
			# for images 'file' gives fully resolved path
			# need to set 'src' because 'file' is not saved
			# but do delete old path in 'file'
		$$i[1]{src} = $self->_copy_media($link, $cloning, %opt);
	}
}

sub _copy_media {
	my ($self, $file, $cloning, %opt) = @_;
		# Cloning is the page we are cloning _from_

	return $self->relative_path($file) if $opt{media} eq 'none';
		# We use relative path here instead of absolute
		# because maybe we are using clone to copy within the
		# same notebook between different storage backends

	my $path = $cloning->relative_path($file);
		# returns e.g. ./file, /file or ~/file
		# if cloning has a doc_root /file is below doc_root and
		# absolute paths will start with file://
		# If we have a doc_root use it as is, later parse_link can
		# prefix our doc_root to is, if we do not have a doc_root
		# we use the original absolute path to attach or link.

	# Determine if we need to copy, and if so to where
	my $copy;
	if ($path =~ /^\./) {
		# file is relative to document dir - copy
		$copy = $self->resolve_file($path);
	}
	elsif (defined $opt{doc_root} and $path =~ /^\//) {
		# link to a file inside document root - use as is
		return $path;
	}
	elsif ($opt{media} eq 'all') {
		# link outside doc_dir and doc_root (if we have any)
		# copy to _media directory
		my $key = $file;
		$key =~ s/[\/\\]+/_/g; # remove dir separators
		$key =~ s/^_+|_+$//g;
		$copy = $$self{store}->document_dir()->file("_media/$key");
	}
	else {
		# Return absolute path - use uri to force abs path
		return $opt{doc_root} ? Zim::FS->path2uri($file) : $file ;
	}

	# Do the actual copy
	# TODO: we can skip the actual copy if the file was already copied
	# for another page linking the same file. However checking existence 
	# is not enough: maybe we are overwriting a previous export.
	if (-f $file) {
		warn "#  copy $file => $copy\n";
		file($file)->copy($copy);
	}
	return $self->relative_path($copy);
}

=item C<get_next()>

Returns next page.

=item C<get_prev()>

Return previous page.

=cut

sub get_next {
	my $self = shift;
	my ($ns, $name) = ($self->namespace, $self->basename);
	my $prev;
	for ($self->{store}->list_pages($ns)) {
		s/:$//;
		return $self->{store}->get_page($ns.$_)
			if $prev eq $name;
		$prev = $_;
	}
	return undef;
}

sub get_prev {
	my $self = shift;
	my ($ns, $name) = ($self->namespace, $self->basename);
	my $prev;
	for ($self->{store}->list_pages($ns)) {
		s/:$//;
		if ($_ eq $name) {
			return $self->{store}->get_page($ns.$prev)
				if length $prev;
			last;
		}
		$prev = $_;
	}
	return undef;
}
=back

=head2 Source Interface

=over 4

=item C<set_source(SOURCE)>

SOURCE is an object that supports an C<open(MODE)> method, which 
returns a filehandle (or IO object) for the source, and an C<exists()>
method which checks if there is anything to open.

If SOURCE is C<undef> this unsets the source, making the page read-only.

This method sets the 'read_only' property depending on whether SOURCE
is defined or not.

=cut

sub set_source {
	$_[0]->{source} = $_[1];
	$_[0]->{parse_tree} = undef;
	$_[0]->{properties}{read_only} = ! defined $_[1];
}

=item C<open_source(MODE)>

Returns an IO object or undef when there is none.
This method dies when it fails opening a given source.
In general pages that have status "new" will not yet have a source.

MODE is optional and can either be 'r' or 'w' depending on whether you
would like the source to be opened for reading or for writing.

Do not forget to close the IO object when you are done with it !
Use OO syntax to close it, using C<< $fh->close >> instead of
C<close $fh>.

=cut

sub open_source {
	my ($self, $mode) = @_;
	my $src = $self->{source};
	return unless defined $src;
	return if $mode eq 'r' and ! $src->exists;
	$src->dir->touch if $mode eq 'w' and $src->can('dir');
	my $fh = $src->open($mode);
	$self->{status} = '' if $mode eq 'w' and defined $fh;
		# remove "new" or "deleted" status
	return $fh;
}

=item C<has_source()>

Returns a boolean.

=cut

sub has_source { return defined $_[0]->{source} }

=back

=head2 Formatted Interface

=over 4

=item C<set_format(FORMAT)>

Sets a source format for this page. This can either be an object of the class
L<Zim::Formats> (or similar), or a name in which case this will be looked up
in the C<Zim::Formats::*> namespace.

Formats are only used for pages that also have a source object.

=cut

sub set_format {
	my ($self, $format) = @_;
	$self->{format} = ref($format) ? $format : _load_format($format);
}

sub _load_format {
	my $name = shift;
	$name = lc $name;
	return $_Formats{$name} if defined $_Formats{$name};

	# TODO: hash lookup using Zim::Formats
	my $class = 'Zim::Formats::'.quotemeta(ucfirst $name);
	eval "use $class";
	die if $@;

	$_Formats{$name} = $class;
	return $class;
}

=item C<get_parse_tree()>

Get the parse tree for this page.

When using source this method will return the tree resulting from running
the given source through the given formatter.

=cut

sub get_parse_tree {
	my $self = shift;
	return $self->{parse_tree} if defined $self->{parse_tree};
	return unless defined $self->{source} and defined $self->{format};
	
	my $io = $self->open_source('r');
	if ($io) {
		my $tree = $self->{format}->load_tree($io, $self);
		$io->close;

		# check mtime for backward compat zim < 0.26
		# also usefull for offline edited files
		# unfortunately we can not get creation time from the FS
		my $p = $$self{properties};
		if ($$self{source}->can('mtime')) {
			$$p{'Modification-Date'} ||=
				Zim::Formats->header_date_string(
					$$self{source}->mtime );
			$$p{'Creation-Date'} ||= 'Unknown';
		}

		return $tree;
	}
	else { return ['Page', $self->{properties}] }
	# FIXME hook _template into this "else"
}

=item C<set_parse_tree(TREE)>

Set the parse tree for this page. Will fail when the page is read-only.

When using source this method will use the formatter to save the parse tree
to the IO object.

=cut

sub set_parse_tree { #warn "set_parse_tree from ", join(' ', caller), "\n" ;
	my ($self, $tree) = @_;
	croak "You tried to save page '$self', but it is read_only"
		if $self->properties->{read_only};
	$self->{status} = ''; # remove "new" or "deleted"
	$self->{_links} = [ $self->list_links($tree) ];
	Zim::Formats->fix_file_ending($tree);

	# store tree
	if (defined $self->{source}) {
		my $io = $self->open_source('w')
			|| die "Could not save parse tree, did not get an IO object.\n";
		
		my $date = Zim::Formats->header_date_string( time );
		$$self{properties}{'Modification-Date'} = $date;
		$$self{properties}{'Creation-Date'} ||= $date;
		
		$self->{format}->save_tree($io, $tree, $self);
		$io->close;
		
		$self->{store}->_cache_page($self)
			if $self->{store}->can('_cache_page');
		# FIXME this hook does not belong here
	}
	else {
		$self->{parse_tree} = $tree;
	}
}

=item C<list_links()>

Returns a list with names of pages that this page links to.

=cut

sub list_links { #warn "list_links from ", join(' ', caller), "\n" ;
	my $self = shift;
	my $node = shift;
	unless ($node) {
		return @{$self->{_links}} if $self->{_links};
		$node = $self->get_parse_tree;
	}

	my %links;
	for (2 .. $#$node) {
		my $n = $$node[$_];
		next unless ref $n;
		if ($$n[0] eq 'link') {
			my ($type, $link) = ('', $$n[1]{to});
			($type, $link) = $self->parse_link($link);
			next unless $type eq 'page';
			$links{$link} = 1;
		}
		else {
			%links = (%links, map {$_ => 1} list_links($self, $n)); # recurse
		}
	}

	return keys %links;
}

=item C<list_backlinks()>

Returns a list with names of pages that link to this page.

=cut

sub list_backlinks {
	my $obj = $_[0]->{cloning} ? $_[0]->{cloning} : $_[0];
		# 'cloning' hack needed when exporting because we may need
		# to resolve pages that do not yet exist in our new notebook.
		# So we use the notebook we are cloning from.
	return $obj->{root}->can('list_backlinks')
		? $obj->{root}->list_backlinks($obj) : () ;
}

=item C<update_links(FROM => TO, ...)>

Update links to other pages. This is used for example when
a page is moved to update all links to that page.

=item C<update_links_self(OLD)>

Called if the current page was moved from OLD to current
name. Updates links to reflect this move.

=cut

sub update_links {
	my ($self, %links) = @_;
	my $tree = $self->get_parse_tree || return;
	require Zim::Selection;
	my $selection = Zim::Selection->new(undef, {}, keys %links);

	warn "Updating links in ", $self->name, "\n";
	my $done = 0;
	for my $ref (Zim::Formats->extract_refs('link', $tree)) {
		my $old = $$ref[1]{to};
		my ($t, $l) = $self->parse_link($old, 'NO_RESOLVE');
		#warn "found link, old = $old => $t, $l\n";
		next unless $t eq 'page';
		my $match = $selection->resolve_name($l, $self, 'NO_DEFAULT')
			|| next;
		#warn "\told match = $match\n";
		my $new_match = $self->resolve_name($l, 'NO_DEFAULT');
		#warn "\tnew match = $new_match\n";
		next if $new_match and length($new_match) > length($match);
			# the only difference is the movement of pages
			# so "new_match" was already there before the move
			# ergo, if "new_match" is there, this was not a link
			# to "match" in the first place
		my $new = $self->relative_name($links{$match});
		unless (length $new) {
			warn "\tBUG: could not update link to $links{$match}\n";
			next;
		}
		warn "\tUpdating $match => $new\n";
		$$ref[1]{to} = $new;
		$$ref[2] = $new if @$ref == 3 and $$ref[2] eq $old;
		$done++;
	}
	$self->set_parse_tree($tree) if $done;
	warn "Updated $done links in $self\n";
	return $done;
}

sub update_links_self {
	my ($self, $from) = @_;
	my $tree = $self->get_parse_tree || return;

	warn "Updating links in ", $self->name, " (was $from)\n";
	my $done = 0;
	for my $ref (Zim::Formats->extract_refs('link', $tree)) {
		my $old = $$ref[1]{to};
		my ($t, $l) = $self->parse_link($old, 'NO_RESOLVE');
		#warn "found link, old = $old => $t, $l\n";
		next unless $t eq 'page';
		my $page = $self->{root}->resolve_name($l, $from);
		#warn "resolved $l => $page\n";
		my $new = $self->relative_name($page);
		unless (length $new) {
			warn "\tBUG: could not update link to $page\n";
			next;
		}
		warn "\tUpdating $old => $new\n";
		$$ref[1]{to} = $new;
		$$ref[2] = $new if @$ref == 3 and $$ref[2] eq $old;
		$done++;
	}
	$self->set_parse_tree($tree) if $done;
	warn "Updated $done links in $self\n";
	return $done;
}

=back

=head2 Document Interface

These methods are used to store and retrieve documents. This has nothing to
do with the source of the page, these documents should be regarded as
attachments.

See detailed documentation in L<Zim::Store>.

=over 4

=item C<document_dir()>

=item C<store_file(FILE, NAME, MOVE)>

=item C<resolve_file(PATH)>

=item C<relative_path(FILE)>

=cut

sub document_dir { $_[0]{store}->document_dir($_[0]) }

sub store_file {
	my ($self, $file) = (shift, shift);
	croak "BUG: '$file' is not an object" unless ref $file;
	$$self{store}->store_file($file, $self, @_);
}

sub resolve_file { $_[0]{store}->resolve_file($_[1], $_[0]) }

sub relative_path { $_[0]{store}->relative_path($_[1], $_[0]) }

=back

=head2 Other Functions

=over 4

=item C<relative_name(NAME)>

Turns an absolute page name into one that is relative
to this page. Reverses part of the logic of C<resolve_name()>.
Returns either relative or absolute name.

=cut

sub relative_name {
	my ($self, $name) = @_;
	my @name = grep length($_), split /:+/, $name;
	my @self = grep length($_), split /:+/, $self->{name};
	return join ':', @name unless $name[0] eq $self[0];
	my $anchor;
	while (@self and @name and $self[0] eq $name[0]) {
		$anchor = shift @self;
		shift @name;
	}
	return $name[0] if @self and @name == 1; # direct leaf of same path
	return join ':', $anchor, @name; # indirect leaf
}


=item C<get_text()>

Returns plain text page. Used by "Email Page" action.
Not to be used for exporting.

=cut

sub get_text {
	my $self = shift;
	my $tree = $self->get_parse_tree;
	my $fmt = 'Zim::Formats::Wiki';
	my $buffer = buffer();
	my $fh = $buffer->open('w');
	$fmt->save_tree($fh, $tree, $self);
	close $fh;
	return ''.$buffer->read;
}

=item C<commit_change()>

=item C<discard_change()>

=cut

sub commit_change {
	$_[0]{source}->commit_change
		if $_[0]{source} and $_[0]{source}->can('commit_change');
}

sub discard_change {
	$_[0]{source}->discard_change
		if $_[0]{source} and $_[0]{source}->can('discard_change');
}

1;

__END__

=back

=head1 PROPERTIES

The page object contains a hash with properties. These can be any kind of data
from the backend that needs to be shared with the interface. Typically it are
config options that can be specified per-page.

For the "formatted" page interface the properties hash is used for the Document
meta attributes in the parse-tree.

Common properties are:

=over 4

=item base (url)

Base directory for files that belong to this page in some way or another.
This is for example used by the interface to resolve the location of image
files that are included in the page.

This value can be undefined when the store does not allow direct access
to the source files.

TODO: At the moment this is the directory which contains the page file, this
is open for change in future versions.

Currently only the C<file://> url is really supported.

=item read_only (boolean)

Tells the interface that this page should not be edited.
Defaults to TRUE.

=item special (boolean)

Rare cases a non-existent read_only page is used to display some information
or because there is simply nothing else to display. This property makes
various components ignore these pages. For example they don't show up in
the history.

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>,
L<Zim::Store>

=cut
