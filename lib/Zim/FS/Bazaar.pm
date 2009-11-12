package Zim::FS::Bazaar;

use strict;
use Carp;
use Zim::Utils qw/buffer/; # be careful not to import file() and dir()

our $VERSION = '0.27';
our @ISA = qw/Zim::FS::Dir/;

=head1 NAME

Zim::FS::Bazaar - Bazaar version control

=head1 DESCRIPTION

This module handles a dir with Bazaar version control for Zim.

Bazaar (bzr) 1.3.1 was used to test this module.

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
	if ($$self{dir} and $$self{dir}{bzr_root}) {
		# inherit bzr_root from parent
		$$self{bzr_root} = $$self{dir}{bzr_root};
	}
	else {
		_check_bzr(); # only do this once per tree

		# ask bzr for root to be sure
		$$self{bzr_root} = $$self{path}; # tmp value for bzr()
		my $bzr_root = $self->bzr('root');
		chomp $bzr_root;
		die "Not a Bazaar directory: $self\n" unless length $bzr_root;
		$$self{bzr_root} = Zim::FS->abs_path($bzr_root);
	}
	return $self;
}

sub init {
	my $class = shift;
	_check_bzr();
	my $self = $class->SUPER::new(@_);
	$self->touch unless $self->exists;
	$$self{bzr_root} = $$self{path};
	$self->bzr('init'); # init dir
	$self->bzr('ignore', '**/.zim*'); # ignore cache
	$self->bzr('add', '.'); # add all existing files
	return $self;
}

sub _check_bzr {
	my $null = Zim::FS->devnull;
	system("bzr version > $null") == 0
		or die __("Can not find application \"{name}\"", name => 'bzr')."\n"; #. Error
}

=item C<commit(COMMENT)>

Commit a new version if there are any changes.
Returns FALSE if there are no changes.

=cut

sub commit {
	my ($self, $comment) = @_;
	carp 'usage: $bzr->commit(COMMENT)' unless defined $comment;

	my $status = $self->bzr('status');
	return 0 unless $status =~ /\w/;
	$self->bzr('add', '.') if $status =~ /^unknown:/m;

	# use a tmp file to avoid problems with newlines etc.
	my $file = Zim::FS->tmp_file('bzr-commit-msg.txt');
	$file->write($comment);
	$self->bzr('commit', '-F', "$file");
	$file->remove;

	return 1;
}

=item C<revert(PATH, VERSION)>

Revert a file to a certain version. Discards all local edits.
If version is undefined, assume latest saved version.

=cut

sub revert {
	my ($self, $path, $v) = @_;
	carp 'usage: $bzr->revert(PATH)' unless defined $path;
	my @arg = $self->bzr_rev_arg($v);
	$self->bzr('revert', @arg, $path);
	return 1;
}

=item C<status()>

Returns the `bzr status` output.

=cut

sub status { return $_[0]->bzr('status') }

=item C<list_versions(PATH)>

Returns a list with version info. PATH is an optional argument,
without this argument all versions are listed.

=cut

sub list_versions {
	my ($self, $path) = @_;
	my $log = buffer( $self->bzr('log', $path) );

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
	#use Data::Dumper; warn Dumper \@versions;

	# extract revno, date and user
	@versions = map {
		my ($revno) = ($_ =~ /revno:\s+(.*)/    );
		my ($date)  = ($_ =~ /timestamp:\s+(.*)/);
		my ($user)  = ($_ =~ /committer:\s+(.*)/);
		s/.*^(\s*)message:\n//sm; # remove headers
		my $l = length($1) + 2;
		s/^\s{0,$l}//mg; # remove whitespace prefix
		[$revno, $date, $user, $_];
	} @versions;

	#use Data::Dumper; warn Dumper \@versions;
	return @versions;
}

=item C<cat_version(PATH, VERSION1)>

Returns the content of a file a a specific version.

=cut

sub cat_version {
	my ($self, $path, $v) = @_;
	my @arg = $self->bzr_rev_arg($v);
	return $self->bzr('cat', @arg, $path);
}

=item C<diff(PATH, VERSION1, VERSION2)>

Returns the diff between VERSION1 and VERSION2 for PATH or undef.
If either version is undefined a diff versus the current
(possibly un-commited) version is returned. If PATH is undefined
a diff over the whole tree is returned.

=cut

sub diff {
	my ($self, $path, $v1, $v2) = @_;
	my @arg = $self->bzr_rev_arg($v1, $v2);
	return $self->bzr('diff', @arg, $path);
}

=item C<annotate(PATH, VERSION)>

Returns the annotated source for PATH or undef. VERSION is an optional
argument; if VERSION is not defined the current (possibly un-commited)
version is assumed.

=cut

sub annotate {
	my ($self, $path, $v) = @_;
	return $self->bzr('annotate', $self->bzr_rev_arg($v), $path);
}

=back

=head2 Directory Interface

With bzr we can just delete content without notifying the system.
So we only provide methods for "add" and "mv".

Overloaded methods:

=over 4

=item C<on_write_file>

=item C<touch>

=item C<move_file>

=cut

sub on_write_file {
	my ($self, $file, $new) = @_;
	#warn ">> on_write_file >>$file<< >>$new<<\n";
	$self->bzr('add', $file) if $new;
	return 1;
}

sub touch {
	my $self = shift;
	my @added = $self->SUPER::touch(@_);
	$self->bzr('add', @added) if @added;
	return @added;
}

sub move_file {
	my ($self, $src, $dest) = @_;
	$dest->dir->touch;
	$self->bzr('mv', $src => $dest);
	return 1;
}

=back

=head2 Private Interface

These methods are used to call the bzr command.

=over 4

=item C<bzr(@ARG)>

Run the C<bzr> command in the appropriate directory and return any output
to STDOUT or STDERR. Will die on error with output in C<$@>.

=cut

sub bzr {
	my $self = shift;
	my @arg = grep defined($_), @_;
	@arg = map {s/"/\\"/g; /\W/ ? "\"$_\"" : $_} @arg;
		# proper quoting of arguments, quotemeta is not win32 compat
	warn "# bzr @arg\n";

	chdir $$self{bzr_root} or die "Could not chdir to: $$self{bzr_root}\n";
	if (open BZR, "bzr @arg 2>&1 |") {
		binmode BZR, ':utf8';
		my $text = join '', <BZR>;
		my $r = close BZR;
		chdir $ENV{PWD};
		if ($arg[0] eq 'diff') {
			# exception that uses exit value for status
			# instead of error ...
			$r = $? >> 8; # get real return value
			if ($r == 3) {
				# real error
				my $error = join "\n", grep /ERROR/, split "\n", $text;
				die "Failed: bzr @arg\n\n$error\n";
			}
			elsif ($r == 0) {
				$text = "=== No Changes\n";
			}
			elsif ($r == 2) {
				$text = "=== Unrepresentable Changes\n";
			}
		}
		elsif (!$r) {
			# NOK - error code on exit
			my $error = join "\n", grep /ERROR/, split "\n", $text;
			die "Failed: bzr @arg\n\n$error\n";
		};

		if (defined wantarray) { return $text }
		elsif ($text =~ /\w/) {
			$text =~ s/^/#   /mg;
			$text =~ s/\n?$/\n/;
			warn $text;
		}
	}
	else {
		chdir $ENV{PWD};
		die "Failed: bzr @arg\n";
	}
}

=item C<bzr_rev_arg(VERSION1, VERSION2)>

Returns the revision commandline argument.

=cut

sub bzr_rev_arg {
	my (undef, $v1, $v2) = @_;
	if    (defined($v1) && defined($v2)) {
		($v1, $v2) = sort ($v1, $v2);
		return "-r", "$v1..$v2";
	}
	elsif (defined($v1) || defined($v2)) {
		return "-r", $v1 || $v2 || '0';
	}
	else { return undef }
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

