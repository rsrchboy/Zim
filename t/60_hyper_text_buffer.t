use Test::More tests => 2;
require 't/env.pm';

use strict;
use Gtk2::Ex::HyperTextBuffer;

my $buffer = Gtk2::Ex::HyperTextBuffer->new();
$buffer->create_default_tags;

$buffer->set_parse_tree(&tree1);
is_deeply(
	$buffer->get_parse_tree(),
	&tree1,
	'parse tree round trip' ); # 1
#use Data::Dumper;
#warn "<"x40, "\n", Dumper &tree1;
#warn ">"x40, "\n", Dumper $buffer->get_parse_tree;

$buffer->set_parse_tree(&tree2);
is_deeply(
	$buffer->get_parse_tree(),
	&tree2,
	'parse tree with image' ); # 2

sub tree1 {
	['Page', {},
		['head1', {empty_lines => 1}, 'Test page'],
		"This is a test page showing some syntax:\n\n",
		['bold', {}, 'Bold text'], "\n",
		['italic', {}, 'Italic text'], "\n",
	#	['bold', {},
	#		'more bold and ',
	#		['italic', {}, 'Bold and Italic']
	#	], "\n",
	]
}

sub tree2 {
	['Page', {},
		['head1', {empty_lines => 2}, 'Test page'],
		"This is a test page showing some syntax:\n\n",
		['bold', {}, 'Bold text'], "\n",
		['italic', {}, 'Italic text'], "\n",
		['image', {src => './foo.png', file => './share/pixmaps/zim.png'}], # The 'file' argument here needs to exist
	#	['bold', {},
	#		'more bold and ',
	#		['italic', {}, 'Bold and Italic']
	#	], "\n",
	]
}
