package Zim::Store::Man;

use Moose;
use namespace::autoclean;

extends 'Zim::Store';

our $VERSION = '0.26';

=head1 NAME

Zim::Store::Man - Man page store for zim

=head1 DESCRIPTION

This module can be used to read man pages in L<zim>.
It assumes that you have the GNU man program, if not it fails silently.

It derives from L<Zim::Store>.

=head1 METHODS

=over 4

=cut

# FIXME was init() -- needs refactoring to behave properly
sub BUILD {
	my $self = shift;
	$self->{no_show_in_sidepane} = 1; # temp HACK

	my $version = man('--version');
	$$self{has_man} = $version;
	if ($$self{has_man}) {
		warn "# man(1) version: $version\n";
		my $path = man('-w');
		$path = `manpath` unless length $path;
			# At least for man 2.5.1 on ubuntu -w does not work
			# to get the global path and we need to use manpath(1)
			# instead.
		$self->{path} = [grep length($_), split /:+/, $path];
		#warn "MANPATH: @{$self->{path}}\n";
	}
	else {
		warn "# man(1) not available\n";
	}
}

=item C<list_pages(NAMESPACE)>

Lists all manpages in a certain section.

=cut

sub list_pages {
	my ($self, $namespace) = @_;
	return unless $self->{has_man};
	$namespace =~ s/^\Q$self->{namespace}\E:*//;
	return $self->list_sections unless length $namespace;
	return unless $namespace =~ /^(\d+\w*):*$/;
	my $section = $1;
	my @pages;
	for (@{$self->{path}}) {
		my $dir = dir($_, 'man'.$section);
		next unless -d $dir;
		#warn "Listing man pages in $dir\n";
		push @pages, map {s/\..*$//; $_} $dir->list;
	}
	$self->wipe_array(\@pages);
	return @pages;
}

=item C<list_sections()>

Used by C<list_pages()> when no section is given.

=cut

sub list_sections {
	my $self = shift;
	my @sections;
	for my $dir (@{$self->{path}}) {
		next unless -d $dir;
		#warn "Listing man sections in $dir\n";
		push @sections, grep s/^man(\d+\w*)/$1/, dir($dir)->list;
	}
	$self->wipe_array(\@sections);
	return map "$_:", @sections;
}

=item C<get_page(NAME)>

Returns a page object for man page NAME.

=cut

sub get_page {
	my ($self, $name) = @_;
	return unless $self->{has_man};
	#warn "Get man page: $name\n";
	
	my $n = $name;
	$n =~ s/^\Q$self->{namespace}\E:*//;
	$n =~ s/^(\d+\w*):+//;
	my $sect = $1 || '';
	
	#warn "!! trying: man $sect $n\n";
	my $path = man('-w', $sect, $n);
	$path = undef unless $path =~ /\S/;
	if (! $path and $n =~ s/:/::/g) { # perl module ?
		#warn "!! trying: man $sect $n\n";
		$path = man('-w', $sect, $n);
		$path = undef unless $path =~ /\S/;
	}
	return unless $path;

	my $page = Zim::Man::Page->new($self, $name);
	$page->{format} = '_man'; # to force formatted interface
	$page->{_manpage} = [$n, $sect];
	
	return $page;
}

=item C<resolve_name(NAME, REF, EXIST)>

Case in-sensitive check whether a page exists or not.
REF is ignored since man pages don't have relative links.

=cut

sub resolve_name {
	my ($self, $name, undef, $exist) = @_;
	return ($exist ? undef : $name) unless $self->{has_man};

	$name = ':'.$name;
	$name =~ s/^:*\Q$self->{namespace}\E:*(?:(\d+\w*):+)?//i;
	$name =~ s/^://;
	my $sect = lc($1) || '';
	$sect = lc($1) if $name =~ s/\((\d+\w*)\):*$//;

	my @try = ($name);
	if ($name =~ /:/) { # perl module ?
		my $n = $name;
		$n =~ s/:+/::/;
		push @try, $n;
	}
	push @try, lc $name if $name =~ /[[:upper:]]/;

	my ($path, $n);
	for (@try) {
		$n = $_;
		#warn "Resolving $name in section $sect\n";
		$path = man('-w', $sect, $n);
		$path = undef unless $path =~ /\S/;
		last if $path;
	}
	$sect = lc($1) if ! $sect and $path =~ /man(\d+\w*)\W/;
	$n = $self->{namespace}.($sect ? $sect.':' : '').($n || $name);
	warn "## ".__PACKAGE__."::resolve_name $name => $n\n";

	return $n if $path;
	return $exist ? undef : $n ;
}

=item C<man(ARGS)>

Runs the "man" command and returns output.

=item C<open_man(ARGS)>

Runs the "man" command and returns a file handle.

=cut

sub man {
	my $fh = open_man(@_);
	return undef unless $fh;
	return join '', <$fh>;
}

my $null = Zim::FS->devnull;

sub open_man {
	my $fh;
	open $fh, "man @_ 2> $null |" or return undef;
	# no binmode :utf8 here because man output can contain invalid chars
	# instead we use the eval Encode option per line in get_parse_tree
	return $fh;
}

package Zim::Man::Page;

use Encode;
use Zim::Page;

our @ISA = qw/Zim::Page/;

=item C<get_parse_tree()>

Returns parse tree for man page.

=cut

sub get_parse_tree {
	my ($self) = @_;
	return $self->{parse_tree} if defined $self->{parse_tree};
	my ($name, $sect) = @{$self->{_manpage}};
	
	$ENV{MANWIDTH} = 80; # FIXME get window size (via Env ?)
	my $fh = Zim::Store::Man::open_man($sect, $name) or return undef;
	my ($block, @data) = ('');
	while (<$fh>) {
		# FIXME implement parsing algo like in Zim.pm
		# include bold and head2
		#s/((\S\cH\S)+)/<b>$1<\/b>/g;
		chomp;
		eval { $_ = Encode::decode('utf8', $_, 1) };
		s/.\cH//g; # remove backspace (^H)
		s/^(\s*)\xB6/$1\x{2022}/; # Change middot by bullet
		if (/^[A-Z]+[A-Z\s]*$/) { # heading
			push @data, $block if length $block;
			push @data, ['head1', {}, $_];
			$block = '';
		}
		elsif (/\b[\w\:\.\-]+\(\w+\)/) { # links
			push @data, $block if length $block;
			while (s/(.*?)\b(([\w\:\.\-]+)\((\d+\w*)\))//) {
				push @data, $1 if length($1);
				push @data, ['link', {to => ":$4:$3"}, $2];
			}
			$block = $_ . "\n";
		}
		else { $block .= $_ . "\n" }
	}
	push @data, $block if length $block;
	close $fh;
	
	$self->{parse_tree} = ['Page', {}, @data];
	return $self->{parse_tree};
}

=item C<set_parse_tree(TREE)>

Man pages can not be saved, thus it throws away all data.

=cut

sub set_parse_tree { warn "Man pages are not writable.\n" }

=item C<parse_link(LINK)>

Man pages contain no relative links, only absolute in same namespace.

=cut

sub parse_link {
	my $self = shift;
	my ($t, $l) = Zim::Formats->parse_link(@_[0, 1], 'NO_RESOLVE');
	$l =~ s/^:*/$$self{store}{namespace}/ if $t eq 'page';
	return ($t, $l);
}


1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim::Store>

=cut

