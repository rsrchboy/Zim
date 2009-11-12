use Test::More tests => 8;
use lib './t';
use env;

use strict;
use File::Spec;
use IO::File;
use Zim::Utils;
use Zim::Page;
use Zim::Formats::Wiki;

my $class = 'Zim::Formats::Wiki';

## Check bit and pieces of formatting

{ # headers and para
	my $text = <<'EOT';
Content-Type: text/x-zim-wiki
Wiki-Format: zim 0.26

====== Head 1 ======

Fooo bar baz
===== Head 2
Dus ja

====     Head 3 ========


Hmm

===  Head 4

== Head 5 ==

EOT
	my $tree = ['Page', {},
		['head1', {empty_lines => 1}, 'Head 1'],
		['Para', {}, "Fooo bar baz\n"],
		['head2', {}, 'Head 2'],
		['Para', {empty_lines => 1}, "Dus ja\n"],
		['head3', {empty_lines => 2}, 'Head 3'],
		['Para', {empty_lines => 1}, "Hmm\n"],
		['head4', {empty_lines => 1}, 'Head 4'],
		['head5', {empty_lines => 1}, 'Head 5'],
	];

	my $buffer = buffer($text);
	my $io = $buffer->open('r');
	my $t = $class->load_tree($io, page());
	$io->close;
	$$t[1] = {}; # no meta data for now
	#use Data::Dumper; warn Dumper $t;
	is_deeply($t, $tree, 'parse headers');

	my $dump = buffer('');
	$io = $dump->open('w');
	$class->save_tree($io, $tree, page());
	$text =~ s/^(=+)\s*(.*[^\s=]).*$/$1 $2 $1/mg; # rectify all headers
	$text =~ s/(Fooo bar baz)\n/$1\n\n/; # add empty line at end of para
	is(''.$dump->read, $text, 'dump headers');
}

{ # Verbatim and para
	# First test new 0.26 behavior, indented paragraphs stay normal
	# only "'''" quoted blocks are Verbatim
	my $tree = ['Page', {},
		['Verbatim', {empty_lines => 1},
		"=== hmm ===\nfoo **barrr**\n\n//foo// bar\nhttp://test.com\n"],
		['Para', {}, "\tfooo\n\tbar\n"],
	];
	my $text = << 'EOT';
Content-Type: text/x-zim-wiki
Wiki-Format: zim 0.26

'''
=== hmm ===
foo **barrr**

//foo// bar
http://test.com
'''

	fooo
	bar
EOT

	my $buffer = buffer('');
	my $io = $buffer->open('w');
	$class->save_tree($io, copy_tree($tree), page());
	$io->close;
	#warn ">>>\n", $buffer->read, "<<<\n"
	is($buffer->read, $text, 'dump Verbatim 1');

	# test dumping verbatim block with trailing newlines
	my $user_tree = ['Page', {},
		['Verbatim', {},
		"=== hmm ===\nfoo **barrr**\n\n//foo// bar\nhttp://test.com\n\n"],
		['Para', {}, "\tfooo\n\tbar\n"],
	];
	$io = $buffer->open('w');
	$class->save_tree($io, $user_tree, page());
	$io->close;
	#warn ">>>\n", $buffer->read, "<<<\n";
	is($buffer->read, $text, 'dump Verbatim 2');

	$io = $buffer->open('r');
	my $t = $class->load_tree($io, page());
	$io->close;
	$$t[1] = {}; # no meta data for now
	#use Data::Dumper; warn Dumper $t;
	is_deeply($t, $tree, 'parse Verbatim');

	# for backward compat < 0.26 we need to treat indented paragraphs
	# as Verbatim, but since everything without headers is regarded
	# as < 0.26 we also regard "'''" blocks as Verbatim to be more robust
	$tree = ['Page', {},
		['Para', {empty_lines => 1},
			"This is a normal Para\n"],
		['Verbatim', {empty_lines => 1},
			"=== hmm ===\nfoo **barrr**\n"],
		['Verbatim', {empty_lines => 1},
			"//foo// bar\nhttp://test.com\n"],
		['Verbatim', {}, "fooo\nbar\n"],
	];
	$buffer = buffer(<<'EOT');
This is a normal Para

	=== hmm ===
	foo **barrr**

	//foo// bar
	http://test.com

'''
fooo
bar
'''
EOT
	$io = $buffer->open('r');
	$t = $class->load_tree($io, page());
	$io->close;
	$$t[1] = {}; # no meta data for now
	#use Data::Dumper; warn Dumper $t;
	is_deeply($t, $tree, 'parse Verbatim <0.26 compat');
}

# TODO more separated formatting rules

## Check roundtrip
{
	my $file = File::Spec->catfile(qw/t notebook Test wiki.txt/);
	my $test = File::Spec->catfile(qw/t notebook Test wiki.txt~/);
	unlink $test or die "Could not unlink $test\n" if -e $test;

	my $page = page(':Test:wiki');
	my $io = IO::File->new($file, 'r');
	my $tree = $class->load_tree($io, $page);
	$io->close;

	#use Data::Dumper; print STDERR Dumper $tree;
	is($$tree[1]{'Content-Type'}, 'text/x-zim-wiki', 'Found header');

	$io = IO::File->new($test, 'w');
	$class->save_tree($io, $tree, $page);
	$io->close;

	ok(cat($file) eq cat($test), 'formatter round trip');
}

exit;

sub page {
	my $name = shift || ':NoName';
	Zim::Page->new(
		Mock::Object->new( # Mock store object
			resolve_file => sub { return $_[1] },
			root => sub { return $_[0] },
		),
	$name );
}

sub copy_tree {
	# need this routine because save_tree is destructive
	my $node = shift;
	my $copy;
	if (ref($node) eq 'ARRAY') {
		$copy = [];
		@$copy = map {ref($_) ? copy_tree($_) : $_} @$node;
	}
	elsif (ref($node) eq 'HASH') {
		$copy = {};
		%$copy = map {ref($_) ? copy_tree($_) : $_} %$node;
	}
	else { die "unknown ref: $node" }
	return $copy;
}

sub cat {
	my $file = shift;
	open FILE, $file or die "Could not open $file\n";
	my $txt = join '', <FILE>;
	close FILE;
	return $txt;
}
