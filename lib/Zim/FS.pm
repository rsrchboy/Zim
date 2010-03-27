package Zim::FS;

use strict;
use Cwd ();
use File::Spec ();
use File::Copy ();
use File::BaseDir 0.03 ();
	# takes care of $HOME among other stuff

our $VERSION = '0.29';

eval 'use Zim::OS::Win32' if $^O eq 'MSWin32';
die $@ if $@;

our @ISA = ($^O eq 'MSWin32') ? ('Zim::FS::Win32')
                              : ('Zim::FS::Unix' ) ;

$ENV{PWD} = Cwd::cwd(); # just to be sure

=head1 NAME

Zim::FS - OO wrapper for Files and Directories

=head1 SYNOPSIS

	$dir = Zim::FS::Dir->new('.');
	print "Dir contents:\n", map "- $_\n", $dir->list;

	$file = Zim::FS::File->new('./Changes');
	$text = $file->read;
	$file->write("New item\n", $text);

=head1 DESCRIPTION

This package provides various objects for handling files and directories.

=head1 OVERLOAD

These classes overload the '""' operator, so the string version of an object
is the path of the file or directory in question.

=head1 METHODS

=head2 Zim::FS;

The main C<Zim::FS> class contains non-OO routines for handling paths.
These are used by the File and Dir objects and should in general be avoided
in other modules.

=over 4

=cut

package Zim::FS::Unix;

use strict;
use Carp;
use File::Glob ':glob';

=item C<localize(FILE)>

Returns platform dependend version of FILE.
Can also localize uris produced by C<uri2path()> in some corner cases.

=cut

sub localize {return pop} # default does nothing, placeholder for win32

=item C<is_abs_path(PATH)>

Returns boolean whether a path is absolute or not.
Urls are considered absolute paths.

=item C<abs_path(PATH, REFERENCE)>

Turn a relative filename or a file uri into a local path name
and cleans up this path to a logical form. It also does tilde 
expansion.

If REFERENCE is omitted the current dir is used.

Calls C<uri2path()> first when needed.

=item C<clean_path(PATH)>

Removes "." and ".." from the path.
Returned path can only contain ".." at the begin.

=cut

sub is_abs_path {
	my ($class, $path) = @_;
	return 1 if $path =~ m#^(/|~|\w[\w\+\-\.]+:/)#;
	return File::Spec->file_name_is_absolute($path);
}

sub abs_path {
	my ($class, $file, $ref) = @_;
	#warn "abs_path: $name ($ref)\n";
	return $class->clean_path($file) if $file =~ /^\//;
	
	if ($file =~ m#\w[\w\+\-\.]+:/#) { # url
		$file = $class->uri2path($file);
		return $file if $file =~ m#^\w[\w\+\-\.]+:/#; # failed
		return $class->clean_path($file);
	}

	if ($file =~ m#^(~([^/]*))#) { # home dir
		my ($home) = length($2)
			? bsd_glob($1, GLOB_TILDE) # other user
			: $ENV{HOME}  ;            # current user
		$file =~ s#^(~[^/]*)#$home#;
	}
	else { # use reference or PWD
		$ref ||= $ENV{PWD};
		$file = $ref.'/'.$file;
	}
	return $class->clean_path($file);
}

sub clean_path {
	my (undef, $file) = @_;
	$file =~ s#(?<=[^/])/+\.(?![^/])##g; # remove /.
	while ($file =~ s#[^/]+/+\.\.(?![^/])##) {} # remove foo/..
	$file =~ s#^/(\.\.)(?![^/])#$1#; # fix leading /../
	$file =~ s#//+#/#g; # /// => /
	return $file;
}

=item C<rel_path(FILE, REFERENCE, UPWARD)>

Returns a path for FILE relative to REFERENCE
or undef when this is not possible.

When UPWARD is true the returned path can contain
"../", else it will only go below REFERENCE.

=cut

sub rel_path {
	my ($class, $file, $base, $upward) = @_;
	$file = $class->abs_path($file);
	$base = $class->abs_path($base);
	my @file = grep length($_), split '/', $file;
	my @base = grep length($_), split '/', $base;
	while (@base) {
		last unless $base[0] eq $file[0];
		shift @base;
		shift @file;
	}
	return undef if @base and ! $upward;
	if (@base) { unshift @file, '..' for @base }
	else       { unshift @file, '.'            }
	return join '/', @file;
}

=item C<uri2path(URI)>

Method for parsing file uris, returns either a normal path or a (modified) uri.
No url decoding is done here.

=cut

# support file:/path file://localhost/path and file:///path

sub uri2path {
	shift; # class
	my $file = shift;
	$file =~ s#^file:(?://localhost/+|/|///+)([^/]+)#/$1#i;
	return $file;
}

=item C<path2uri(FILE)>

Turns a path into an uri. Does no checks.

=cut

sub path2uri {
	my $class = shift;
	my $file = shift;
	$file = $class->abs_path($file);
	$file =~ s#^/?#file:///#;
	return $file;
}

=item C<cache_file(NAME)>

Returns a file in the cache.
If NAME is a path directory separators are stripped.

=item C<tmp_file(NAME)>

Returns a file in the tmp directory. Basides NAME both the user name and 
the process id are included in the file name to avoid collisions between
separate instances of zim.

=cut

sub cache_file {
	my ($class, $name) = @_;
	$name =~ s/[\/\\:]+/_/g; # win32 save
	$name =~ s/^_+|_+$//g;
	my $file = File::BaseDir->cache_home('zim', $name);
	return $file ? Zim::FS::File->new($file) : undef ;
}

sub tmp_file {
	my ($class, $name) = @_;
	my $dir = $class->tmpdir;
	my $file = Zim::FS::File->new($dir, "zim-$ENV{USER}-$$-$name");
	return undef unless $file;
	$file->touch();
	chmod 0600, $file->{path}; # Set permissions
	return $file;
}

=item C<devnull>

Returns the path for the F</dev/null> device.

=item C<tmpdir>

Returns the path for F</tmp> or equivalent.

=cut

sub devnull { File::Spec->devnull }

sub tmpdir { File::Spec->tmpdir }

=back

=head2 Zim::FS::Node

Base class for directory and file objects.

=over 4

=cut

package Zim::FS::Node;

use strict;
use overload
	'""' => \&path,
	fallback => 'TRUE' ;

=item C<path>

Returns the full path.

=item C<uri>

Returns the path as a C<file://> uri.

=cut

sub path { $_[0]{path} }

sub uri { Zim::FS->path2uri( $_[0]->path ) }

=item C<name>

Returns the last part of the path.

=item C<basename>

Returns basename part of the path.

=cut

sub name { my @p = split '/', $_[0]{path}; pop @p }

sub basename {
	my $name = $_[0]->name;
	$name =~ s/\..+$//;
	return $name;
}

=item C<dir()>

Returns a Dir object for the directory containing this file or dir.

=item C<parent()>

Returns Dir object to which this file or dir belongs.
Not necessarily the direct parent dir, use C<dir()> to find that.

=item C<rel_path()>

Return the path relative to C<parent> if any.

=cut

sub dir {
	my $self = shift;
	#warn "PARENT $$self{dir} RELPATH $$self{relpath}\n";
	if ($$self{dir}) {
		my @path = split '/', $$self{relpath};
		pop @path;
		return scalar(@path)
			? $$self{dir}->subdir(@path)
			: $$self{dir};
	}
	else {
		my @path = split '/', $$self{path};
		pop @path;
		return Zim::FS::Dir->new(@path);
	}
}

sub parent { $_[0]{dir} }

sub rel_path { $_[0]{relpath} }

=item C<writable()>

Returns boolean.

=cut

sub writable {
	# We try to do the righ thing even if path does not yet exist.
	# Deepest exisitng parent must be writable for us to auto-create
	# path.
	my $self = shift;
	my $path = $self->{path};
	while (! -e $path) {
		$path = undef unless $path =~ m#/#;
		$path =~ s#(.*)/.*#$1#;
	}
	return defined($path) ? -w $path : 0 ;
}

=back

=head2 Zim::FS::Dir

Object for a single directory.

=over 4

=cut

package Zim::FS::Dir;

use strict;
use Carp;
use Encode;

our @ISA = qw/Zim::FS::Node/;

=item C<new(@PATH)>

Simple constructor, takes path as a list. If the first argument is a
Dir object it regards this as its parent object.

=cut

sub new {
	my $class = shift;
	my $dir = ref($_[0]) ? shift : undef ;
	if ($dir and ! @_) {
		# allow reblessing Dir objects
		return bless $dir, $class;
	}
	my $path = join '/', @_;
	croak "Invalid dirname: '$path'" unless $path =~ /\S/;
	my $self = bless {}, $class;
	
	$$self{is_root} = 1 if $path eq '/' && ! $dir;
	if ($dir) {
		$$self{relpath} = Zim::FS->clean_path($path);
		croak "\"$path\" is outside  \"$dir\""
			if $$self{relpath} =~ /^\.\./;
		$$self{path} = $dir->path.'/'.$$self{relpath};
		$$self{path} =~ s#/+#/#g;
		$$self{path} =~ s#/\./#/#g;
		$$self{dir} = $dir;
	}
	else { $$self{path} = Zim::FS->abs_path($path) }
	s/\/*$/\// for grep defined($_), @$self{'path', 'relpath'};
	return $self;
}

sub _check_nested {
	# (FILE, DIR) check whether FILE is below DIR
	croak "\"$_[0]\" outside \"$_[1]\"" unless $_[0]{dir} eq $_[1];
}

=item C<exists>

Returns whether dir exists or not.

=cut

sub exists { -d $_[0]{path} }

=item C<list()>

Returns a list of items for DIR. Ignores hidden files.

=cut

sub list {
	my $dir = shift;

	opendir DIR, $$dir{path} or die "Could not list dir $dir\n";
	my @items = grep {! /^\./} readdir DIR;
	closedir DIR;

	eval {$_ = Encode::decode('utf8', $_, 1)} for @items;
	#warn "$dir =>\n", map "\t$_\n", @items;
	return @items;
}

=item C<touch()>

Create this dir and parents if it doesn't exist already.
Returns list of created dirs.

=item C<touch(DIR)>

Create a sub dir if it doesn't exist alread.
Returns list of created dirs.

=cut

sub touch {
	my ($dir, $node) = @_;
	unless ($node) {
		return if $dir->exists;
		return $$dir{dir}->touch($dir) if $$dir{dir};
		$node = $dir;
	}
	else {
		_check_nested($node, $dir);
	}
	
	my ($vol, $dirs) = File::Spec->splitpath(
		File::Spec->rel2abs($node), 'DIR');
	my @dirs = File::Spec->splitdir($dirs);
	my $path = File::Spec->catpath($vol, shift @dirs, '');
	my @added;
	unless (! length $path or -d $path) {
		warn "## FS mkdir: $path\n";
		mkdir $path or die "Could not create dir: $path\n";
		push @added, $path;
	}
	while (@dirs) {
		$path = File::Spec->catdir($path, shift @dirs);
		next if -d $path;
		warn "## FS mkdir: $path\n";
		mkdir $path or die "Could not create dir $path\n";
		push @added, $path;
	}
	return @added;
}

=item C<file(@PATH)>

Returns a file in this directory.

=item C<subdir(@PATH)>

Returns a sub dir in this directory.

=item C<resolve_file(EXT, @PARTS)>

Look for a file below this directory that kind of looks like @PARTS.

EXT is the file extension to add to the last part when resolving a file.
This can be C<undef>. The extension is also used to keep case the same between
like-named dirs and files.

=item C<resolve_dir(EXT, @PARTS)>

Like C<resolve_file()> but returns a Dir object.

=cut

sub file { Zim::FS::File->new(@_) } # File->new() checks for dir object

sub subdir {
	my $self = shift;
	my $class = ref $self;
	if (@_ == 1 && ref $_[0]) {
		# single object argument => we want an existing
		# directory object to become a child of the current one
		my $path = Zim::FS->rel_path($_[0], $self);
		croak "$_[0] can not be a subdir of $self" unless $path;
		return $self if $path eq '.';
		return $class->new($self, $path);
	}
	elsif (@_ == 1 && $_[0] =~ /^\.\/*$/) {
		# special case
		return $self;
	}
	else {
		croak "subdir() needs argument" unless @_;
		return $class->new($self, @_);
	}
}

sub resolve_file { unshift @_, 0; goto \&_resolve }

sub resolve_dir  { unshift @_, 1; goto \&_resolve }

sub _resolve {
	my ($is_dir, $self, $ext, @parts) = @_;
	$ext ||= '';
	$ext =~ s/^\.?/./ if $ext;
	#warn "RESOLVE: @parts EXT: $ext DIR: $is_dir IN: $self\n";

	my $path = $self;
	while (-d $path && @parts) {
		#warn "\tPATH: $path PARTS: @parts\n";
		if (@parts == 1 && ! $is_dir) { # file
			my $match = $path->_grep_file($parts[0], $ext);
			last unless $match;
			$path = $path->file($match);
		}
		else { # dir
			my $match = $path->_grep_subdir($parts[0], $ext);
			last unless $match;
			$path = $path->subdir($match);
		}
		shift @parts;
	}
	return $path unless @parts;
	if ($is_dir) { return $path->subdir(@parts) }
	else {
		$parts[-1] .= $ext;
		return $path->file(@parts);
	}
}

sub _grep_file {
	# lookup a file doing funky stuff to get the case right
	# we can not use the "-f" short-cut because we don't know
	# whether the file system is case sensitive or not
	my ($self, $file, $ext) = @_;
	my $regex = qr/^(?i:\Q$file\E)(?:\Q$ext\E)?$/;
	my @matches = grep {$_ =~ $regex} $self->list;
	#warn "\tMATCHES (F): @matches\n";
	return undef unless @matches;
	my (@files, @dirs);
	for (sort @matches) { # sort for predictability
		if (length($_) == length($file.$ext)) {
			push @files, $_;
		}
		else {
			push @dirs, $_;
		}
	}
	if (@files) {
		return $file.$ext if grep {$_ eq $file.$ext} @files;
		return shift(@files);
	}
	else {
		return $file.$ext if grep {$_ eq $file} @dirs;
		return shift(@dirs).$ext;
	}
}

sub _grep_subdir {
	# lookup a subdir doing funky stuff to get the case right
	# we can not use the "-d" short-cut because we don't know
	# whether the file system is case sensitive or not
	my ($self, $dir, $ext) = @_;
	$ext = $ext ? quotemeta($ext) : '\\.*' ;
	my $regex = qr/^(?i:\Q$dir\E)(?:$ext)?$/;
	my @matches = grep {$_ =~ $regex} $self->list;
	#warn "\tMATCHES (D): @matches\n";
	return undef unless @matches;

	@matches = map substr($_, 0, length $dir), @matches; # remove remainder
	return $dir if grep {$_ eq $dir} @matches; # same case
	@matches = sort @matches; # sort for predictability
	return shift(@matches); # different case
}

=item C<cleanup()>

Remove this directory and clean up its parent directories if they are empty.
Only works if this dir has an parent Dir object.

=item C<cleanup(FILE)>

=item C<cleanup(DIR)>

Removes a file or directory and cleans up it's parents when they are empty
up to the directory of the current object. Returns list of deleted parents.

=item C<remove_file(FILE)>

Remove a file under this dir. FILE is an object.

=item C<remove_dir(DIR)>

Remove a subdir under this dir. DIR is an object.

=cut

sub cleanup {
	my ($dir, $node) = @_;
	return $$dir{dir}->cleanup($dir) unless $node;
	_check_nested($node, $dir);
	
	if ($node->exists) {
		$node->isa('Zim::FS::File')
			? $dir->remove_file($node)
			: $dir->remove_dir($node)  ;
	}

	my @deleted;
	my @path = grep length($_), split '/', $$node{relpath};
	pop @path; # removed above
	while (@path) {
		my $subdir = File::Spec->catdir($$dir{path}, @path);
		rmdir $subdir or last if -e $subdir; # fails when non-empty
		warn "## FS rmdir: $subdir\n";
		push @deleted, $subdir;
		pop @path;
	}
	#warn "## Cleaned up: @deleted";
	return @deleted;
}

sub remove_file {
	my ($dir, $file) = @_;
	warn "## FS unlink: $file\n";
	_check_nested($file, $dir);
	unlink $$file{path} or die "Could not delete file: $file\n";
}

sub remove_dir {
	my ($dir, $subdir) = @_;
	warn "## FS rmdir: $subdir\n";
	_check_nested($subdir, $dir);
	rmdir $$subdir{path} or die "Could not remove dir: $subdir\n";
}

=item C<copy_file(SOURCE => DEST)>

Copy content from one file object to another.

=item C<move_file(SOURCE => DEST)>

Move content from one file object to another.

=cut

sub copy_file {
	my ($dir, $src, $dest) = @_;
	croak 'Usage: $dir->copy_file(SOURCE => DEST)' unless @_ == 3;
	return if $src eq $dest;
	
	my $new = !$dest->exists;
	$dest->dir->touch;
	warn "## FS copy: $src => $dest\n";
	File::Copy::copy("$src" => "$dest")
		or die "Could not copy '$src' to '$dest' ($!)\n";
	$dest->on_write($new);
}

sub move_file {
	my ($dir, $src, $dest) = @_;
	croak 'Usage: $dir->move_file(SOURCE => DEST)' unless @_ == 3;
	return if $src eq $dest;
	
	my $new = !$dest->exists;
	$dest->dir->touch;
	warn "## FS move: $src => $dest\n";
	File::Copy::move("$src" => "$dest")
		or die "Could not move '$src' to '$dest' ($!)\n";
	$dest->on_write($new);
}

=item C<commit_file(FILE)>

=item C<discard_file(FILE)>

=item C<on_write_file(FILE)>

Callbacks to be overloaded in sub classes.

=cut

sub on_write_file { }

sub commit_file { }

sub discard_file { }

=back

=head2 Zim::FS::File

Object for a single file.

=over 4

=cut

package Zim::FS::File;

use strict;
use Carp;

our @ISA = qw/Zim::FS::Node/;

=item C<new(FILENAME)>

Simple constructor, uses L<File::Spec>'s C<catfile> when multiple
arguments are given. Attaches to Dir object when first argument is an
object reference.

=cut

sub new {
	my $class = shift;
	my $dir = ref($_[0]) ? shift : undef ;
	if ($dir and $dir->isa('Zim::FS::File') and ! @_) {
		# allow reblessing File objects
		my $file = bless $dir, $class;
		return $file;
	}
	my $path = join '/', @_;
	croak "Invalid filename: '$path'" unless $path =~ /\S/;
	my $file = bless {}, $class;

	if ($dir) { # nested file
		$$file{relpath} = Zim::FS->clean_path($path);
		croak "\"$path\" is outside  \"$dir\""
			if $$file{relpath} =~ /^\.\./;
		$$file{path} = $dir->path.'/'.$$file{relpath};
		$$file{path} =~ s#/\./#/#g;
		#warn "RELPATH $$file{relpath} DIR $dir\n";
		#warn "DIR class: ".ref($dir)."\n";
	}
	else { # orphaned file
		if ($^O eq 'MSWin32') {
			# for Win32 we need relative to volume ...
			$path = Zim::FS->abs_path($path);
			my ($vol, undef, undef) = File::Spec->splitpath($path);
			$dir = Zim::FS::Dir->new($vol.'\\');
			$$file{relpath} = $path;
			$$file{relpath} =~ s/^\Q$vol\E\/*//;
			$$file{path} = $path;
		}
		else {
			# Code below was used to also accomadate win32, but
			# that was buggy, see new code in block above. Now
			# probably we could call abs_path directly here and use
			# a regex to remove "/". Not changing this now because
			# lack of testing for such a change.
		$dir = Zim::FS::Dir->new('/');
		$$file{relpath} = Zim::FS->rel_path($path, $dir);
			$$file{relpath} =~ s#^\./##; # rel_path call abs_path
		$$file{path} = $dir.$$file{relpath};
		}
	}
	$$file{path}  =~ s#/+#/#g;
	$$file{dir}   = $dir;
	$$file{mtime} = 0;
	return $file;
}

=item C<read()>

Returns the contents of the file. Takes list context in account.
Returns empty when the file does not exist.

=cut

sub read {
	my $file = shift;
	warn "## FS read: $file\n";
	return unless $file->exists;
	my $fh = $file->open('r');
	my @text = <$fh>;
	@text = map {s/\r?\n$/\n/; $_} @text; # DOS to Unix conversion
	$fh->close;
	return wantarray ? (@text) : join('', @text);
}

=item C<write(CONTENT, ..)>

Write CONTENT to file.
Creates file and parent directories when needed.

=item C<append(CONTENT, ..)>

Append content to file.
Creates file and parent directories when needed.

=cut

sub write {
	my $file = shift;
	warn "## FS write: $file\n";
	my $fh = $file->open('w');
	print $fh @_;
	$fh->close or die "$file: $!\n";
}

sub append {
	my $file = shift;
	warn "## FS append: $file\n";
	my $fh = $file->open('a');
	print $fh @_;
	$fh->close or die "$file: $!\n";
}

=item C<cleanup()>
Delete the file and empty parent directories.

=item C<remove()>

Delete the file.

=cut

sub cleanup { $_[0]{dir}->cleanup($_[0]) }

sub remove {
	$_[0]{dir}->remove_file($_[0]);
	$_[0]{mtime} = 0;
}

=item C<exists()>

Returns boolean.

=cut

sub exists { -f $_[0]{path} }

=item C<mtime()>

Return the modification time for this file.

=item C<set_mtime()>

Set the current mtime of the file as an object attribute.

=item C<check_mtime()>

Get the mtime for the file and compare to stored mtime atribute.
Dies when timestamps do not match. Used by subclasses to detect
when files changed on disk.

=cut

sub mtime { $_[0]{mtime} || ( CORE::stat $_[0]{path} )[9] }

sub set_mtime { $_[0]{mtime} = ( CORE::stat $_[0]{path} )[9] }

sub check_mtime {
	my $self = shift;
	my $file = $self->{path};
	my $mtime ||= (CORE::stat $file)[9];
	die "File has changed on disk since reading: $file\n"
		if  defined $mtime
		and $self->{mtime} != $mtime ;
	$self->{mtime} = $mtime;
}

=item C<open(MODE)>

Returns an C<IO> object that can be used as a file handle.

Make sure to close this handle using OO syntax, using C<< $fh->close >>
instead of C<close $fh>.

FILE is an optional argument allowing this function to be
used without an object.

MODE can be 'r', 'w' or 'a' for read, write and append respectivly.

=cut

sub open {
	my ($file, $mode) = @_;
	$mode ||= 'r';

	my $new = 0;
	unless ($mode eq 'r' or $file->exists) {
		$new = 1;
		$file->dir->touch();
	}

	my $handle = Zim::FS::IO->new($file, $mode) || die "$file: $!\n";

	$handle->set_on_close(\&on_write, $file, $new) unless $mode eq 'r';
	return $handle;
}

=item C<grep(REGEXP, MODE)>

Line based grep function. MODE can be undefined, 'lines' or 'count';
In normal mode matches are returned, for 'lines' complete lines that
match are returns, and for 'count' a number of matches is returned.

=cut

sub grep {
	my ($self, $regexp, $mode) = @_;
	my $file = $self->{path};
	$mode ||= 'normal';
	return $mode eq 'count' ? 0 : () unless -f $file;
	#print STDERR "Grepping for /$regexp/ in $file (mode: $mode)\n\t";
	my @match;
	my $fh = $self->open;
	if ($mode eq 'lines') {
		while (<$fh>) {
			push @match, $_ if $_ =~ $regexp;
			#print STDERR '.';
		}
	}
	elsif ($mode eq 'count') {
		$match[0] = 0;
		while (<$fh>) {
			$match[0]++ if $_ =~ $regexp;
			#print STDERR '.';
		}
	}
	else {
		$regexp  = /($regexp)/;
		while (<$fh>) {
			push @match, ($_ =~ $regexp);
			#print STDERR '.';
		}
	}
	$fh->close;
	#print STDERR "DONE\n";
	#print STDERR "\t=> @match\n";
	return wantarray ? @match : $match[0] ;
}

=item C<touch()>

Create empty file if file does not exist.

=cut

sub touch {
	return if -e $_[0]{path};
	$_[0]->write('');
}

=item C<on_write()>

Called by the file handle object when it is closed after writing to this file.
Used by subclasses, not intended for external use.

=cut

sub on_write {
	$_[0]->set_mtime;
	$_[0]{dir}->on_write_file(@_);
}

=item C<resolve_link()>

If the file is a symlink this will return the final destination of that link.

=cut

sub resolve_link {
	my $file = shift;
	my $class = ref($file);
	while (-l $file) {
		my $link = readlink($file);
		die "Could not read link: $!" unless defined $link;
		$file = $class->new(
			Zim::FS->abs_path($link, $file->dir) );
	}
	return $file;
}

=item C<copy(DESTINATION)>

Copy content from one file to another.
Creates parent directories if needed.

=cut

sub copy { $_[0]{dir}->copy_file($_[0] => _file($_[1])) }

sub _file { # make sure we pass on object instead of string
	return $_[0] if ref($_[0]) && @_ == 1;
	Zim::FS::File->new(@_);
}

=item C<move(DESTINATION)>

Move file contents from one place to another.
Takes care of creating and cleaning up parent directories.

=cut

sub move { $_[0]{dir}->move_file($_[0] => _file($_[1])) }

=back

=head2 Zim::FS::File::Config

This subclass is used for reading and writing config files

=over 4

=cut

package Zim::FS::File::Config;

use strict;

our @ISA = qw/Zim::FS::File/;

=item C<read(\%CONFIG, GROUP)>

Returns a hash with config data.

Arguments CONFIG and GROUP are optional. If CONFIG is given it will be used to
store the config. Existing keys found in the file will be overwritten with the 
value from the file If GROUP is given this is the default group in the config. 
Keys from the group will be placed in the top level hash, all other groups will
be sub-hashes.

=cut

# For backwards compatibility all keys outside a group go in the
# top level hash and will end up in the default group after writing.

sub read {
	my ($self, $config, $default) = @_;
	$config  ||= {};
	$default ||= 'Default';

	my $group = $config;
	for ($self->SUPER::read) {
		/^\s*\#/ and next;
		if (/^\s*\[(.+)\]\s*$/) {
			if ($1 eq $default) { $group = $config }
			else {
				$$config{$1} ||= {};
				$group = $$config{$1};
			}
		}
		elsif (/^\s*(.+?)\s*=\s*(.*?)\s*$/) {
			$$group{$1} = $2;
		}
	}
	return $config;
}

=item C<write(\%CONFIG, GROUP)>

Writes a hash with config data.

GROUP is optional and will be used as the name for the default group. All keys
in the top level hash go in this group. Sub-hashes will be separate groups.

=cut

sub write {
	my ($self, $config, $default) = @_;
	$default ||= 'Default';

	my $settings = {};
	my @groups;
	while (my ($k, $v) = each %$config) {
		if   (ref $v) { push @groups, [$k => $v] }
		else          { $$settings{$k} = $v      }
	}
	@groups = sort {$$a[0] cmp $$b[0]} @groups;
		# using sort to make result predictable
	unshift @groups, [$default => $settings] if %$settings;

	my $fh = $self->open('w');
	for my $i (0 .. $#groups) {
		my ($group, $hash) = @{$groups[$i]};
		print $fh "\n" if $i;
		print $fh "[$group]\n";
		print $fh "$_=$$hash{$_}\n" for sort keys %$hash;
			# using sort to make result predictable
	}
	print $fh "\n# vim: syntax=desktop\n"; # enable highlighting in VIM
	$fh->close;
}

=back

=head2 Zim::FS::File::CheckOnWrite

This subclass is used for the text files containing
pages to prevent data loss.

Be aware that checking and locking done in this class are only
intended to prevent a single user to overwrite data by accident.
It will not suffice for a multi-user system.

This class checks the modification time of the file when
reading and writing. It will not allow you to overwrite a file
if it changed since you read it.

Also this class implements "atomic" writing. This means that
when you write to a file you write to a temporary file first.
When the file handle is closed the temporary file is moved to
replace the original file. This way the original file is not
purged when an error occurs while writing.

=over 4

=cut

package Zim::FS::File::CheckOnWrite;

use strict;

our @ISA = qw/Zim::FS::File/;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->{mtime} = 0;
	$self->{real_path} = $self->resolve_link;
	$self->{tmp_path} = $self->{real_path} . '.zim.new~';
	return $self;
}

sub open {
	my ($self, $mode) = @_; 
	$mode ||= 'r';
	
	if ($mode eq 'r') {
		$self->set_mtime;
		return $self->SUPER::open($mode);
	}
	else { # mode 'w' || 'a'
		$self->check_mtime;
		my $new = ! $self->exists;
		my $handle = Zim::FS::IO->new($$self{tmp_path}, $mode)
			|| die "$$self{tmp_path}: $!\n";
		$handle->set_on_close(\&on_write, $self, $new);
		return $handle;
	}
}

sub on_write {
	# rename tmp file to real path and record mtime
	my $self = shift;
	#warn "move $self->{tmp_path} => $self->{path}\n";
	File::Copy::move($$self{tmp_path} => $$self{real_path})
		or die "Could not move '$$self{tmp_path}' to '$$self{real_path}'\n"
		if -f $$self{tmp_path} ;
		# The -f check is here because we are also called from
		# move_file() and copy_file()
	$self->SUPER::on_write(@_);
}

=back

=head2 Zim::FS::File::CacheOnWrite

This subclass is used when the original file is located on a slow
file system. It implements a "copy on write" that uses a cache file
after the first write. You need to call C<commit_change()> in order
to overwrite the original file.

It does check the modification time like CheckOnWrite.

=over 4

=cut

package Zim::FS::File::CacheOnWrite;

use strict;

our @ISA = qw/Zim::FS::File/;

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	my $cache_file = Zim::FS->cache_file($self->{path});
	$self->{cache_file} = Zim::FS::File::CheckOnWrite->new("$cache_file");

	$self->{mtime} = $self->_mtime
		if $self->{cache_file}->exists ;

	return $self;
}

sub DESTROY { goto \&commit_change }

sub _mtime {
	my $f = $_[0]{cache_file}{path}.'.mtime';

	if ($_[1]) { # set mtime
		CORE::open(OUT, '>', $f) or die $!;
		print OUT "$_[1]\n";
		CORE::close(OUT);
	}
	else { # get mtime
		return 0 unless -f $f;
		CORE::open(IN, $f) or die $!;
		my $mtime = <IN>;
		CORE::close(IN);
		chomp $mtime;
		return $mtime;
	}
}

sub open {
	my ($self, $mode) = @_;
	$mode ||= 'r';
	my $cache = $$self{cache_file};
	
	if ($mode eq 'r' && ! $cache->exists) {
		$self->set_mtime;
		return $self->SUPER::open($mode);
	}
	# else cache exists or mode 'w' or 'a'
	
	$self->_mtime( $$self{mtime} );
	$cache->dir->touch if $mode eq 'w';
	return $cache->open($mode);
}

=item C<commit_change()>

Copy the cached data back to the original file.

=cut

sub commit_change {
	my $self = shift;
	return unless $$self{cache_file}->exists;
	
	$self->check_mtime;

	warn "## FS move: $$self{path} => $$self{cache_file}\n";
	my $out = $self->SUPER::open('w');
	my $in  = $$self{cache_file}->open('r');
	File::Copy::copy($in => $out)
		or die "Could not copy '$$self{cache_file}' to '$$self{path}'\n";
	$in->close;
	$out->close; # will trigger "write" event

	$self->_rm_cache;
	$$self{dir}->commit_file($self);
}

=item C<discard_change()>

Throw away the cached version.

=cut

sub discard_change {
	my $self = shift;
	$self->_rm_cache;
	$$self{dir}->discard_file($self);
}

sub _rm_cache {
	my $cache = $_[0]{cache_file};
	if ($cache->exists) {
		$cache->remove;
		unlink $cache.'.mtime';
	}
}

=back

=head2 Zim::FS::URI

Subclass of Zim::FS::Node that just contains an URI or something that looks like
a path, but does not exist on the file system.
Can be used with certain interfaces that require a dir object for resolving paths.

=over 4

=cut

package Zim::FS::URI;

use strict;

our @ISA = qw/Zim::FS::Node/;

=item C<new(@URI)>

Simple constructor.

=item C<uri()>

Returns URI.

=item C<path()>

Same as C<uri()>.

=cut

sub new {
	my $class = shift;
	bless { path => join '/', @_ }, $class;
}

sub uri { $_[0]{path} }

=item C<dir()>

Returns an URI object for parent "dir".

=item C<subdir(@PATH)>

Returns a URI object for the URI after appending @PATH.

=item C<file()>

Like C<subdir()> but without trailing "/".

=cut

sub dir {
	my $self = shift;
	my $path = $$self{path};
	$path =~ s/[^\/]+\/*$// or return undef;
	return Zim::FS::URI->new($path);
}

sub subdir {
	my $self = shift;
	my $uri = $self->file(@_);
	$$uri{path} =~ s/\/?$/\//;
	return $uri;
}

sub file {
	my ($self, @parts) = @_;
	my $path = $$self{path};
	$path =~ s/\/+$//;
	s/^\/+|\/+$//g for @parts; # avoid doubling of "/"
	$path = join '/', $path, @parts;
	return Zim::FS::URI->new($path);
}

=back

=head2 Zim::FS::Buffer

This object implements part of the API of Zim::FS::File but keeps all data in memory.
Can be used with certain interfaces that require a file object to read/write data.

Does not inherit from Zim::FS::Node.

=over 4

=cut

package Zim::FS::Buffer;

use strict;
use Carp;

=item C<new(\$STRING)>

=item C<new(@STRING)>

Simple constructor, takes a scalar ref or a list of scalars as argument.

=cut

sub new {
	# Instead of blessing the reference we bless a reference to the
	# reference. This is done because the "open" function doesn't like
	# blessed scalar references.
	my $class = shift;
	if (@_ == 1 && ref $_[0]) {
		# wrap existing scalar reference
		my $ref = shift;
		croak "usage: new(\\\$STRING)" unless ref($ref) eq 'SCALAR';
		return bless \$ref, $class;
	}
	else {
		# anonymous reference to store buffer
		my $ref = \(my $text = undef);
		my $self = bless \$ref, $class;
		$self->write(@_) if @_;
		return $self;
	}
}

=item C<read()>

Returns contents.

=item C<write(TEXT)>

Sets contents.

=item C<append(TEXT)>

Appends contents.

=item C<open(MODE)>

Returns a file handle.

=cut

sub read {
	my $text = $${$_[0]};
	return wantarray ? (map "$_\n", split /\n/, $text) : $text;
}

sub write { $${$_[0]} = join '', @_[1 .. $#_] }

sub append { $${$_[0]} .= join '', @_[1 .. $#_] }

sub open {
	my ($self, $mode) = @_;
	$$$self = '' unless defined $$$self; # avoid warnings
	$mode = ($mode eq 'w')    ? '>' :
		($mode eq 'a')    ? '>>' : '<' ;
	my $fh;
	open $fh, $mode, $$self or die "BUG $!";
	binmode $fh, ':utf8';
	return $fh;
}

=item C<exists()>

True if content defined.

=item C<remove()>

Delete content.

=cut

sub exists { defined $${$_[0]} }

sub remove { $${$_[0]} = undef }

=item C<copy(FILE)>

Write content of buffer to FILE.

=item C<move(FILE)>

Write content of buffer to FILE and delete buffer.

=cut

sub copy { $_[1]->write( $${$_[0]} ) }

sub move {
	$_[1]->write( $${$_[0]} );
	$_[0]->remove;
}


package Zim::FS::IO;

use strict;
use IO::File;

our @ISA = qw/IO::File/;

# This class is a hack in order to provide a callback
# when the filehandle is closed. This is needed to fix
# stuff like saving the 'mtime' _after_ the file was writen.

# It uses a global hash to save object attributes because
# IO::Handle objects are filehandle references, not hashes.

# It uses a indirect subroutine definition to circumvent
# the Pod::Cover test

our %_on_close;

*set_on_close = sub { # used to set object attributes
	my $fh = shift;
	$_on_close{"$fh"} = [@_];
};

*new = sub {
	my @c = caller;
	my $class = shift;
	my $handle = $class->SUPER::new(@_);
	binmode $handle, ':utf8' if defined $handle;
	return $handle;
};

*close = sub {
	my $fh = shift;
	my $re = $fh->SUPER::close(@_);
	my $arg = delete $_on_close{"$fh"};
	return $re unless $arg;
	my $code = shift @$arg;
	$code->(@$arg);
	return $re;
};

*DESTROY = sub {
	my $fh = shift;
	my $arg = delete $_on_close{"$fh"};
	return unless $arg;
	warn "File handle not closed after writing for:\n\t$$arg[1]\n";
	# We do not call the callback here - close might not have
	# happened due to an error while writing.
};

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006, 2007 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>

=cut

