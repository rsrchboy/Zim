package Zim::Formats::Pod;

use strict;
use Pod::Simple::SimpleTree;

our $VERSION = 0.28;

our %ALIASES = (
	Document  => 'Page',
	B         => 'bold',
	C         => 'verbatim',
	I         => 'italic',
	L         => 'link',
	U         => 'underline',
	F         => 'underline', # <strong><a name="item_devnull"><code>devnull</code></a></strong><br />
);
	# head1 .. headX is the same
	# Verbatim and Para are the same
	# links have objects in the "to" field
	# lists come as "over-text" grouping "item-text"
       	
# FIXME what to use for strike ??
#	bold      => 'B',
#	verbatim  => 'C',
#	italic    => 'I',
#	link      => 'L',
#	underline => 'U',

=head1 NAME

... - simple module

=head1 SYNOPSIS

FIXME simple code example

=head1 DESCRIPTION

FIXME descriptve text

=head1 EXPORT

None by default.

=head1 METHODS

=over 4

=item C<load_tree()>

=cut

sub load_tree {
	my ($class, $io, $page) = @_;
	my $parser = Pod::Simple::SimpleTree->new;
	$parser->parse_file($io);
	my $tree = $parser->root;
	#use Data::Dumper; warn Dumper $tree;
	return _transform_tree($tree);
}

sub _transform_tree {
	my $tree = shift;
	my ($type, $meta) = splice @$tree, 0, 2;
#warn "Kerle: $type", Dumper($meta);

	$$meta{to} = "$$meta{to}" if $type eq 'link';
	if (exists $ALIASES{$type}) {
		return [$ALIASES{$type}, $meta, _recurs($tree)]
	}
	# stuff to indent
	# FIXME are there some more?
	elsif ($type =~ m'^over-.*') {
		# we get ident from
		# 'over-text', 'over-bullet' and 'over-block'
		# distribute and sum indent value over all blockitems
		for (@$tree) {
			$_->[1]->{indent} += $$meta{indent}
				if ($_->[1]->{indent});
		}
		return ['Para', $meta, _recurs($tree)];
	}
	# * bullet items
	elsif ($type eq 'item-text') {
		return ['bullet', $meta, "\x{2022} ", _recurs($tree), "\n"];
	}
	elsif ($type eq 'item-bullet') {
		return ['bullet', $meta, "\x{2023} ", _recurs($tree), "\n"];
	}
	else {
		$$meta{empty_lines} = 2 if $type =~ /^[A-Z]/;
		$$meta{empty_lines} = 1 if $type =~ /^head/;
# looks ugly for me
#
#		if ($type eq 'Verbatim') {
#			if ($$tree[0] =~ /^(\s+)/) {
#				my $l = length $1;
#				$$tree[0] =~ s/^\s{$l}/X/mg;
#				#s/^\s{0,$l}//mg for @$tree;
#			}
#		}
		return [$type, $meta, _recurs($tree)];
	}
}

sub _recurs {
	my $tree = shift;
	return map {
		ref($_) ? _transform_tree($_) : $_ ;
	} @$tree;
}

=item C<parse_link(LINK)>

page links may need the namespace prefix

links in index cache should not get "mount"- namespace prefix,
however I can't manage this here.

=cut
#use Carp qw|cluck|;
#use Data::Dumper;
#$Data::Dumper::Maxdepth = 3;
sub parse_link {
	# my (undef, $link, $page (Zim::Page), $no_resolve) = @_;
	my $self = shift;
	my ($link, $page, $no_resolve) = @_;
#cluck "$self l: $link, p: $page->{name}";
	my ($t, $l) = Zim::Formats->parse_link($link, $page, $no_resolve);
#warn "parse_link1: $self / t: $t / l: $l\n";
#	$l =~ s/^$page->{store}->{namespace}//
#		if (($t eq 'page') && (!defined $no_resolve));
#warn "parse_link2: $self / t: $t / l: $l\n\n";
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

=cut

