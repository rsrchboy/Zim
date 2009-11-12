use Test::More tests => 4;
require 't/env.pm';

use strict;
use Zim::Events;

my $object = Mock::Object->new(ISA => 'Zim::Events');

$object->signal_connect(foo => sub { die unless $_[0]->isa('Zim::Events'); return 0 });
$object->signal_connect(foo => sub { return $_[1] ? 1 : 0 });
$object->signal_connect(foo => sub { return 'f00!' });
$object->signal_connect(foo => sub { shift; return @_ }, 'bar', 'baz');

is_deeply(
	[$object->signal_emit('foo')],
	[qw/0 0 f00! bar baz/],
	'emit' );

is_deeply(
	[$object->signal_emit('foo', 'test', '123')],
	[qw/0 1 f00! test 123 bar baz/],
	'emit with args' );

is_deeply(
	[$object->signal_dispatch('foo')],
	['f00!'],
	'dispatch 1');

is_deeply(
	[$object->signal_dispatch('foo', 'bar')],
	['1'],
	'dispatch 2');

