package Zim::Store::Gjots;

use Moose;
use namespace::autoclean;

extends 'Zim::Store';

use Carp;
use Zim::Page;
use Zim::Utils;

our $VERSION = '0.26';

=head1 NAME

Zim::Store::Gjots - Class for opening .gjots files

=head1 DESCRIPTION

This module read .gjots files. The format is the format used by the 
L<gjots2>(1) program. Acording to the man page of this program the format 
is also the same as used for the (old) L<kjots>(1) and L<jots>(1) programs.

The format is very simple, there are just 3 directives:

	\NewEntry	start a new page
	\NewFolder	start a new namespace
	\EndFolder	end of the namespace

Pages do not have any formatting and the first line, which may be empty,
is used as the page title. Titles do not have to be unique.

We read the whole file to memory, which puts certain limits on scalebility,
however the gjots format seems to be mainly used for large numbers of
very short entries, which may take a lot of overhead when saved as individual
files.

This Store only implements reading gjots files for now.
Adding write support is left as an exercise for the reader.

=head1 METHODS

=over 4

=cut

# FIXME -- needs refactoring
sub BUILD {
	my $self = shift;
	$self->check_file;
	$$self{tree} = $self->parse_gjots($$self{file});
	#use Data::Dumper; warn Dumper $$self{tree};
}

=item C<list_pages(NAMESPACE)>

This method should return a list of pages in NAMESPACE.
The list is used by the gui to produce a hierarchical index,
it does not tell anything about the actual existence of the pages.

The default returns an empty list.

=cut

sub list_pages { 
	my ($self, $ns) = @_;
	#warn "Gjots list_pages $ns\n";
	$ns =~ s/^\Q$$self{namespace}\E//i;
	return $$self{tree}[0].':' unless $ns =~ /[^:]/;
	my $node = $self->get_entry($$self{tree}, $ns);
	my @pages;
	for my $n (grep ref($_), @$node) {
		my $p = $$n[0];
		$p .= ':' if @$n > 2;
		push @pages, $p;
	}
	return sort @pages;
}

=item C<get_page(NAME)>

Returns a L<Zim::Page> object or C<undef>.

=cut

sub get_page {
	my ($self, $name) = @_;
	#warn "Gjots get_page($name)\n";
	my $node = $self->get_entry($$self{tree}, $name);
	return undef unless $node;

	my $page = Zim::Page->new($self, $name);
	$$page{properties}{read_only} = 0;
	$page->set_parse_tree( ['Page', {}, $$node[1]] );
	$$page{properties}{read_only} = 1;

	return $page;
}

=item C<resolve_case(\@NAME, \@REF)>

B<Private> method called by C<resolve_name()>.
To be overloaded by child classes.

NAME contains the parts of the pagename we are looking for.
REF contains parts of the pagename we use as base for a relative lookup.
Try to match the first part of NAME in the path defined by REF.
If REF is undefined, just start from ":".

=cut

sub resolve_case {
	my ($self, $name, $ref) = @_;
	warn "TODO resolve case for: @$name\n";
	return undef;
}

=item C<document_dir(PAGE)>

Returns the dir where the gjots file is.
Just in case anyone tries to atach files etc.

=cut

sub document_dir { $$_[0]{dir} }

=back

=head2 Private Methods

=over 4

=item C<parse_gjots(FILE)>

Reads a gjots file and returns a data structure like:

	[ title, body,
		[title, body],
		[title, body,
			[title, body],
			...
		],
		...
	]

Title is simply the first line of the body, but can have a number attached
to make it unique. The file name is used as title for the top level node.

=cut

sub parse_gjots {
	my ($class, $file) = @_;
	$file = file($file) unless ref $file;

	my $title = $file->name;
	$title =~ s/\:/_/g;
	Zim::Store->clean_name($title, 'REL');
	my $tree = [$title]; # top level folder
	my @stack = ($tree);
	my $buffer = '';

	# This parser reads the file line by line looking for directives
	# When a directive is found the current entry is closed and added
	# to the parent folder. When a new folder is opened we push it on
	# the stack and pop it when it is closed again.

	my $fh = $file->open('r');
	my $l = 0;
	while (<$fh>) {
		my $l++;
		if (/^\\NewEntry\s*$/) { # end previous entry
			_add_entry($stack[-1], $buffer);
			$buffer = '';
		}
		elsif (/^\\NewFolder\s*$/) { # use current entry as folder
			push @stack, _add_entry($stack[-1], $buffer);
			$buffer = '';
		}
		elsif (/^\\EndFolder\s*$/) { # end last entry in folder
			_add_entry($stack[-1], $buffer);
			$buffer = '';
			if (@stack == 1) {
				warn "Unmatched \"\\EndFolder\" at line $l\n";
			}
			else { pop @stack }
		}
		else { $buffer .= $_ } # add text to current entry
	}
	_add_entry($stack[-1], $buffer); # end last entry
	$fh->close;
	warn "Unmatched \"\\NewFolder\" at end of file\n" unless @stack == 1;

	# TODO check titles are unique

	return $tree;
}

sub _add_entry {
	my ($tree, $buffer) = @_;
	return unless $buffer =~ /\S/;
	$buffer =~ /^(.*)$/m; # get first line
	my $title = length($1) ? $1 : 'no-title'; # title can be empty line
	$title = substr($title, 0, 30).'...' if length($title) > 33;
		# some files have whole paragraphs as title
	$title =~ s/\:/_/g;
	$title = Zim::Store->clean_name($title, 'REL'); # make valid page name
	if (@$tree == 1) {
		# special case for first entry, title is file name
		push @$tree, $buffer;
		return $tree;
	}
	else {
		my $node = [$title => $buffer];
		push @$tree, $node;
		return $node;
	}
}

=item C<get_entry(TREE, NAME)>

Returns the node in the tree that maps to a page name.

=cut

sub get_entry {
	my ($class, $tree, $name, $no_case) = @_;
	my @parts = grep length($_), split /:/, $name;
	#warn "PARTS: ", map(">>$_<< ", @parts), "\n";
	return undef if $no_case
		? (lc($parts[0]) ne lc($$tree[0]))
		: ($parts[0] ne $$tree[0]) ;
	shift @parts; # loose tree title
	my $node = $tree;
	while (@parts) {
		my $part = shift @parts;
		$node = _grep_tree($node, $part, $no_case);
		last if not defined $node;
	}
	return $node;
}

sub _grep_tree {
	my ($tree, $title, $no_case) = @_;
	my ($node) = grep {$$_[0] eq $title} @$tree[2 .. $#$tree];
	if (! defined $node and $no_case) { # case in-sensitive lookup
		my $t = lc $title;
		my @suspects = grep {lc($$_[0]) eq $t} @$tree[2 .. $#$tree];
		@suspects = sort {$$a[0] cmp $$b[0]} @suspects;
		$node = $suspects[0];
	}
	return $node;
}

1;

__END__

=back

=head1 BUGS

Please mail the author if you find any bugs.

=head1 AUTHOR

Jaap Karssenberg || Pardus [Larus] E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2008 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>, L<Zim::Store>, L<gjots2>(1)

=cut
