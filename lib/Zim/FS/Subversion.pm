package Zim::FS::Subversion;

use strict;
use Carp;
use Zim::Utils qw/buffer/; # be careful not to import file() and dir()

our $VERSION = '0.27';
our @ISA = qw/Zim::FS::Dir/;

=head1 NAME

Zim::FS::Subversion - Subversion version control

=head1 DESCRIPTION

This module handles a dir with Subversion version control for Zim.

It inherits from L<Zim::FS|Zim::FS::Dir>.

=head1 METHODS

=head2 Version Control Interface

=over 4

=item C<new(@PATH)>

Simple constructor for an existing Bazaar dir.

=item C<init(@PATH)>

Constructor that will initialize a new Bazaar repository.

=cut

sub new {
	my $class = shift;

	my $self = $class->SUPER::new(@_);
	if ($$self{dir} and $$self{dir}{svn_root}) {
		# Inherit svn_root from parent
		$$self{svn_root} = $$self{dir}{svn_root};
	}
	else {
		_check_svn(); # do this once per tree

		# We must be the root ...
		$$self{svn_root} = "$self";
		eval { $self->svn('info') };
		die "Not a Subversion directory: $self\n" if $@;
	}
	return $self;
}

sub init {
	my ($class, $dir, $args) = @_;
	_check_svn();
	my $self = $class->SUPER::new($dir);
	$$self{svn_root} = $$self{path};

	# We want to avoid import because it does not allow us to set
	# the ignore property up front and it forces us to do a checkout
	# anyway. Might as well check out a dir and then add to it.

	my $url = $$args{url};
	die "SVN needs an url" unless defined $url;
	my @auth = ();
	for (qw/username password/) {
		push @auth, '--'.$_, $$args{$_} if $$args{$_};
	}

	my $list = eval { $self->svn('list', $url) };
	if ($@) {
		# New URL, let's create it
		warn "# URL does not exists: $url\n";
		warn map "## $_\n", split /\n/, $@;
		$self->svn('mkdir', @auth, '--message', 'Init zim notebook', $url);
	}
	$self->svn('co', @auth, $url, '.');
	$self->svn('propset', 'svn:ignore', '.zim', '.');
	# Next commit will add all files

	return $self;
}

sub _check_svn {
	my $null = Zim::FS->devnull;
	system ("svn --version --quiet > $null") == 0
		or die __("Failed to load SVN plugin,\ndo you have subversion utils installed?")."\n"; #. error SVN not installed
}

=item C<commit(COMMENT)>

Commit a new version if there are any changes.

=cut

sub commit {
	my ($self, $comment) = @_;
	carp 'usage: $svn->commit(COMMENT)' unless defined $comment;

	# add new file, remove deleted ones
	my $status = $self->svn('status');
	for (split /\n/, $status) {
		if    (s/^\?\s+//) { $self->svn('add', $_) }
		elsif (s/^\!\s+//) { $self->svn('del', $_) }
	}

	# use a tmp file to avoid problems with newlines etc.
	my $file = Zim::FS->tmp_file('svn-commit-msg.txt');
	$file->write($comment);
	$self->svn('commit', '-F', "$file");
	$file->remove;

	return 1;
}

=item C<revert(PATH, VERSION)>

Revert a file to a certain version. Discards all local edits.
If version is undefined, assume latest saved version.

=cut

sub revert {
	my ($self, $path, $v) = @_;
	carp 'usage: $svn->revert(PATH)' unless defined $path;
	if ($v) {
		# svn revert does not take a version argument
		my $content = $self->cat_version($path, $v);
		Zim::FS::File->new($path)->write($content);
	}
	else { $self->svn('revert') }
	return 1;
}

=item C<status()>

Returns the `svn status` output.

=cut

sub status { return $_[0]->svn('status') }

=item C<list_versions(PATH)>

Returns a list with version info. PATH is an optional argument,
without this argument all versions are listed.

=cut

sub list_versions {
	my ($self, $path) = @_;
	my $log = buffer( $self->svn('log', $path) );

	my @versions;
	my $buffer = '';
	my $io = $log->open('r');
	while (<$io>) {
		if (/^\s*-+$/) {
			push @versions, $buffer if length $buffer;
			$buffer = '';
		}
		else { $buffer .= $_ }
	}
	push @versions, $buffer if length $buffer;
	#~ use Data::Dumper; warn Dumper \@versions;

	# extract revno, date, user and log message
	@versions = map {
		s/^(.+)$(\n+)//m; # remove first line
		my ($rev, $user, $date) = split /\s*\|\s*/, $1;
		$rev =~ s/^r//;
		[$rev, $date, $user, $_];
	} @versions;

	#use Data::Dumper; warn Dumper \@versions;
	return @versions;
}

=item C<cat_version(PATH, VERSION1)>

Returns the content of a file a a specific version.

=cut

sub cat_version {
	my ($self, $path, $v) = @_;
	return $v
		? $self->svn('cat', '-r', $v, $path)
		: $self->svn('cat', $path) ;
}

=item C<diff(PATH, VERSION1, VERSION2)>

Returns the diff between VERSION1 and VERSION2 for PATH or undef.
If either version is undefined a diff versus the current
(possibly un-commited) version is returned. If PATH is undefined
a diff over the whole tree is returned.

=cut

sub diff {
	my ($self, $path, $v1, $v2) = @_;

	my @v = ();
	if    (defined($v1) && defined($v2)) {
		($v1, $v2) = sort ($v1, $v2);
		@v = ("-r", "$v1:$v2");
	}
	elsif (defined($v1) || defined($v2)) {
		@v = ("-r", $v1 || $v2 || '0');
	}

	return $self->svn('diff', @v, $path);
}

=item C<annotate(PATH, VERSION)>

Returns the annotated source for PATH or undef. VERSION is an optional
argument; if VERSION is not defined the current (possibly un-commited)
version is assumed.

=cut

sub annotate {
	my ($self, $path, $v) = @_;
	$path .= '@'.$v if defined $v;
	$self->svn('annotate', $path);
}

=back

=head2 Directory Interface

Overloaded methods:

=over 4

=item C<on_write_file(FILE, NEW)>

=item C<touch()>

=cut

sub on_write_file {
	my ($self, $file, $new) = @_;
	#warn ">> on_write_file >>$file<< >>$new<<\n";
	$self->svn('add', $file) if $new;
	return 1;
}

sub touch {
	my $self = shift;
	my @added = $self->SUPER::touch(@_);
	$self->svn('add', $_) for @added;
	return @added;
}

# Escaped routines below because svn does not remove dirs
# scheduled for deletion directly, this leads to conflicts with
# the way zim works.

#sub move_file {
#	my ($self, $src, $dest) = @_;
#	$dest->dir->touch;
#	$self->svn('move', $src => $dest);
#	return 1;
#}

#sub copy_file {
#	my ($self, $src, $dest) = @_;
#	$dest->dir->touch;
#	$self->svn('copy', $src => $dest);
#	return 1;
#}

#sub cleanup {
#	my $self = shift;
#	my @deleted = $self->SUPER::cleanup(@_);
#	$self->svn('delete', $_) for @deleted;
#	return @deleted;
#}

#sub remove_file {
#	my ($self, $file) = @_;
#	Zim::FS::Dir::_check_nested($file, $self);
#	$self->svn('delete', $file);
#}

#sub remove_dir {
#	my ($self, $subdir) = @_;
#	Zim::FS::Dir::_check_nested($subdir, $self);
#	$self->svn('delete', $subdir);
#}	

=back

=head2 Private Interface

These methods are used to call the svn command.

=over 4

=item C<svn(@ARG)>

Run the C<svn> command in the appropriate directory and return any output
to STDOUT or STDERR. Will die on error with output in C<$@>.

=cut

sub svn {
	my $self = shift;
	my @arg = grep defined($_), @_;
	@arg = map {s/"/\\"/g; /\W/ ? "\"$_\"" : $_} @arg;
		# proper quoting of arguments, quotemeta is not win32 compat
	warn "# svn @arg\n";

	chdir $$self{svn_root} or die "Could not chdir to: $$self{svn_root}\n";
	if (open SVN, "svn @arg 2>&1 |") {
		binmode SVN, ':utf8';
		my $text = join '', <SVN>;
		my $r = close SVN;
		chdir $ENV{PWD};
		if (!$r) {
			# NOK - error code on exit
			my $error = join "\n", grep /^svn:/, split "\n", $text;
			die "Failed: svn @arg\n\n$error\n";
		};
		return $text;
	}
	else {
		chdir $ENV{PWD};
		die "Failed: svn @arg\n";
	}
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

=cut

