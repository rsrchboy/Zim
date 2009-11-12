use Test::More tests => 27;
require 't/env.pm';

use strict;
use Zim;
use Zim::Selection;

my $root = File::Spec->rel2abs( File::Spec->catdir(qw/t notebook/) );
my @parse = (
	'a b'
		=> {any => [qw/a b/]},
	'a AND b'
		=> {any => [qw/a b/]},
	'"a AND b"'
		=> {any => 'a AND b'},
	'a "AND" b'
		=> {any => [qw/a AND b/]},
	'a and b'
		=> {any => [qw/a b/]},
	'a && b'
		=> {any => [qw/a b/]},
	'+a +b'
		=> {any => [qw/a b/]},
	'a OR b'
		=> [ {any => 'a'}, {any => 'b'} ],
	'a or b'
		=> [ {any => 'a'}, {any => 'b'} ],
	'a || b'
		=> [ {any => 'a'}, {any => 'b'} ],
	'a b AND c OR d'
		=> [ {any => [qw/a b c/]}, {any => 'd'} ],
	'"a b" AND c OR d'
		=> [ {any => ["a b", 'c']}, {any => 'd'} ],
	'- a'
		=> {'not-any' => 'a'},
	'-a'
		=> {'not-any' => 'a'},
	'- a b'
		=> {any => 'b', 'not-any' => 'a'},
	'-a AND b'
		=> {any => 'b', 'not-any' => 'a'},
	'+ b -a'
		=> {any => 'b', 'not-any' => 'a'},
	'content: a'
		=> {content => 'a'},
	'content:a'
		=> {any => 'content:a'},
	'Content:"a"'
		=> {content => 'a'},
	'content: -a'
		=> {'not-content' => 'a'},
	'content: foo: a'
		=> {content => 'foo:', any => 'a'},
	'content: a Name: b'
		=> {content => 'a', name => 'b'},
	'content: a AND NAME: b'
		=> {content => 'a', name => 'b'},
	'content: a OR name: b'
		=> [ {content => 'a'}, {name => 'b'} ],
	'name: a AND name: b: d OR NAME: a AND Links: c OR -e'
		=> [
			{name => [qw/a b:/], any => 'd'},
			{name=> 'a', links => 'c'},
			{'not-any' => 'e'}
		],
);

my $i = 0;
while (@parse) {
	my ($text, $ref) = splice @parse, 0, 2;
	#use Data::Dumper; print "STRING: $text\n", Dumper parse($text);
	is_deeply( Zim::Selection->parse_query($text), $ref,
		'parse search query '.++$i );
}

{
	my $rep = Zim->new(dir => $root);
	my @res;
	my $cb = sub { push @res, @_ };
	$rep->search({string => "\x{2022}\x{2022} Search Me \x{2022}\x{2022}"}, $cb);
	#use Data::Dumper; print Dumper \@res;
	ok(scalar( grep {$$_[0] eq ':Test:foo:bar' and $$_[1] > 0} @res),
		"utf8 search pattern" );
}

