package main;
require 't/env.pm';

use Test::More tests => 16;

use strict;
use Zim::FS;
use Zim::History;

my $file = File::Spec->catfile('t', 'notebook', 'test_hist.cache');
unlink $file if -e $file;
die "File exists allready" if -e $file;

my $gui = Mock::Object->new(get_state => sub { return {cursor => 42} });
my $hist = Zim::History->new($file, 10, $gui);

my @pages = qw/
	:foo:bar
	:foo
	:foo:baz
	:foo:bar
	:foo:bar:dus
	:test
	:foo:test
/;
my @rec = (
	{name => ':foo:bar', basename => 'bar', namespace => ':foo:', state => {cursor => 42 }},
	{name => ':foo', basename => 'foo', namespace => ':', state => {cursor => 42 }},
	{name => ':foo:baz', basename => 'baz', namespace => ':foo:', state => {cursor => 42 }},
	{name => ':foo:bar', basename => 'bar', namespace => ':foo:', state => {cursor => 42 }},
	{name => ':foo:bar:dus', basename => 'dus', namespace => ':foo:bar:', state => {cursor => 42 }},
	{name => ':test', basename => 'test', namespace => ':', state => {cursor => 42 }},
	{name => ':foo:test', basename => 'test', namespace => ':foo:', state => {cursor => 42 }},
);

$hist->set_current($_) for @pages;
$hist->back(2);
$hist->write;
#use Data::Dumper; warn Dumper $hist;

print "# All tests are done twice, once before and once after write/read\n";
test();
$hist = Zim::History->new($file, 10, $gui);
test();

sub test {
	is($hist->get_current->{name}, ':foo:bar:dus', 'get_current()');

	my ($p, @h) = $hist->get_history;
	is($p, 4, 'get_history() 1');
	is_deeply(\@h, \@rec, 'get_history() 2');

	my @r = @rec[1..6];
	($p, @h) = $hist->get_recent;
	is($p, 3, 'get_recent() 1');
	is_deeply(\@h, \@r, 'get_recent() 2');

	$hist->back(1);
	my $ns = $hist->get_namespace;
	is($ns, ':foo:bar:dus', 'get_namespace()');
	$hist->forw(1);

	my $s = $hist->get_state;
	is_deeply($s, {back => 4, forw => 2, up => 0, down => 0}, 'get_state()');

	is_deeply($hist->get_record(':foo'), $rec[1], 'get_record()');
}

unlink $file;

