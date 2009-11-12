use Test::More tests => 5;
require 't/env.pm';

use strict;
use Zim::Formats;
use Zim::Utils;

# TODO test registering
# TODO test listing

my $tree = [
	'Document', {},
	['head1', {}, 'a b c'],
	['head2', {}, 'd 1'],
	"text 1",
	['head3', {}, 'e 2'],
	"text 2",
	['head4', {}, 'f 3'],
	"text 3",
];

Zim::Formats->update_heads($tree, 3, 5);
is_deeply($tree, [
	'Document', {},
	['head3', {}, 'a b c'],
	['head4', {}, 'd 1'],
	"text 1",
	['head5', {}, 'e 2'],
	"text 2",
	['head5', {}, 'f 3'],
	"text 3",
],
'update_heads' );

my ($l, $t) = Zim::Formats->get_first_head($tree);
is_deeply([$l, $t], ['3', 'a b c'], 'get_first_head');


my $headers = {
	'x-test-this' => "Foo bar",
	'Multiline1' => "foo\nbar\nbaz\n",
	'Multiline2' => "foo\nbar\nbaz",
};
my $text = <<'EOT';
Multiline1: foo
	bar
	baz
Multiline2: foo
	bar
	baz
x-test-this: Foo bar
EOT

my $block = Zim::Formats->dump_rfc822_headers($headers);
is($block, $text, 'dump headers');

# clean ups that should be done in the parse code
s/\n$// for values %$headers;
$$headers{'X-Test-This'} = delete $$headers{'x-test-this'};

my $hash = Zim::Formats->parse_rfc822_headers($block);
is_deeply($hash, $headers, 'parse headers');

# double check headers end up right order and lower case is ignored
my $page = {
	properties => {
		'Foo-Bar' => 'test',
		'Content-Type' => 'text/x-zim-wiki',
		'Creation-Date' => 'Sun, 20 Jul 2008 23:14:32 +0200',
		'Wiki-Format' => 'zim 0.25',
		'do-not-dump' => 'foo',
		'Modification-Date' => 'Sun, 20 Jul 2008 23:14:32 +0200',
	}
};

my $prop = <<'EOT';
Content-Type: text/x-zim-wiki
Wiki-Format: zim 0.25
Creation-Date: Sun, 20 Jul 2008 23:14:32 +0200
Modification-Date: Sun, 20 Jul 2008 23:14:32 +0200
Foo-Bar: test
EOT

is(Zim::Formats->dump_page_properties($page), $prop, 'dump page headers');

