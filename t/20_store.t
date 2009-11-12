use Test::More tests => 85;
require 't/env.pm';

use strict;
use File::Spec;
use Zim::Store::Files;
use Zim::Utils;
use Zim;

# This sub removes the cache file, forcing re-indexing
# called at multiple places below. Note that the cache algorithm
# uses FS filestamps. This granularity is high enough for the
# user, but not for automated testing.
sub DELETE_CACHE {
	my $cache = file(qw#t notebook .zim index.cache#);
	$cache->remove if $cache->exists;
}

# Test how config and cache are resolved
print "## get config and cache ##\n";
{
	my $dir = Zim::FS->abs_path('./t/notebook');
	my $path = Zim::FS->abs_path('./t/notebook/notebook.zim');
	is(Zim->get_notebook_config($dir), $path, 'get_notebook_config');
	
	$path = Zim::FS->abs_path('./t/notebook/.zim/');
	is(Zim->get_notebook_cache($dir), $path, 'get_notebook_cache');

	SKIP: {
		$dir = "t/cache/read-only/";
		mkdir "t/cache"; mkdir $dir;
		chmod 0444, $dir;
		skip('chmod doesn\'t work', 1) if -w $dir;
		$path = Zim::FS->abs_path('./t/cache/read-only');
		$path =~ s/[\/\\:]+/_/g;
		$path =~ s/^_+|_+$//g;
		$path = Zim::FS->abs_path('./t/cache/zim/'.$path.'/');
		is(Zim->get_notebook_cache($dir), $path, 'get_notebook_cache RO');
		chmod 0777, $dir or die;
	}
}


# Test a bunch of stuff in the "Files" backend
print "\n## Zim::Store::Files ##\n";
DELETE_CACHE;

my $root = File::Spec->rel2abs( File::Spec->catdir(qw/t notebook/) );
my $rep = Zim::Store::Files->new( dir => dir($root) );
$$rep{parent} = $rep;

is($rep->{format}, 'wiki', 'format');

#print "\n## 2 pagefile(foo:bar) resulted in:\n" .
#	"\t".$rep->page2file('foo:bar')->path."\n";
ok($rep->page2file('foo:bar')->path =~ m#/t/notebook/foo/bar.txt$#,
	'filename 1' ); #

my $page = $rep->get_page(':foo:bar');
is($page->status, 'new', 'status new page');
ok(@{$page->get_parse_tree} > 2, 'template');
is($page->{format}, 'Zim::Formats::Wiki', 'format class');

ok($rep->page2file('Test:wiki')->path =~ m#/t/notebook/Test/wiki.txt$#,
	'filename 2' ); #
ok($page->{source}->isa('Zim::FS::File::CheckOnWrite'), 'file class');

my $i = 1;
{
	# resolve name on Zim object
	my ($link, $target) = ('test:WIKI', ':Test:wiki');
	#print "# resolve_name '$link' => '$target'\n";
	is($rep->resolve_name($link), $target, 'resolve_name '.$i++);
}

# resolve_name on Page objects
$page = $rep->get_page(':Test:foo:bar') or die "BUG";
for my $t (
	['Dus', ':Test:foo:Dus'],
	['wIKi', ':Test:wiki'],
	['Test:Dus', ':Test:Dus'],
	['test:Dus', ':Test:Dus'],
	['test:WIKI:bar', ':Test:wiki:bar'],
	[':Dus', ':Dus'],
) {
	my ($link, $target) = @$t;
	#print "# resolve_name '$link' => '$target'\n";
	is($page->resolve_name($link), $target, 'resolve_name '.$i++);
}

# parse_link on Page objects
$page = $rep->get_page(':Test:foo:bar') or die "BUG";
Zim->set_notebook_list([foo => '/foo/bar']);
my $dir = dir(qw/t notebook Test foo/);
file($dir, $_)->touch for 'file1.png', 'file2.png', 'bar/file1.png' ;
for my $t (
	['wp?Test' => 'http', 'http://en.wikipedia.org/wiki/Test', 'interwiki'],
	['man?test' => 'man', 'test', 'man'],
	['file:///foo/bar' => 'file', '/foo/bar', 'file uri'],
	['./file0.png', => 'file', $dir->file('bar', 'file0.png'), 'file'], # does not exist
	['./file1.png', => 'file', $dir->file('bar', 'file1.png'), 'file'], # both exist
	['./file2.png', => 'file', $dir->file('file2.png'), 'file'], # only backwards compat exists
	['mailto:user@host.com' => 'mail', 'mailto:user@host.com', 'mail 1'],
	['user@host.com' => 'mail', 'mailto:user@host.com', 'mail 2'],
	['wIKi' => 'page', ':Test:wiki', 'page 1'],
	['.baz' => 'page', ':Test:foo:bar:baz', 'page 2'],
	[':foo & bar:' => 'page', ':foo___bar', 'page 3'],

) {
	my ($link, $t, $l, $name) = @$t;
	$l = Zim::FS->abs_path($l) if $t eq 'file';
		# needed on e.g. win32 to be able to compare
	is_deeply([$page->parse_link($link)], [$t, $l], 'parse_link '.$name);
}

#$page = $rep->open_page('test:utf8-acchars');

DELETE_CACHE;
my @pages = $rep->list_pages(':');
#warn "Pages: ", map(">>$_<< ", @pages), "\n";
is_deeply(\@pages, [qw/Test: TODOList:/], 'list_pages 1');

SKIP: {
	DELETE_CACHE;
	my ($old, $new) = map file(@$_),
		[qw/t notebook Test/], [qw/t notebook link/] ;
	skip('symlink not supported '.$!, 1)
		unless eval { symlink("",""); 1 }
		and symlink($old => $new) ;
	@pages = $rep->list_pages(':');
	is_deeply(\@pages, [qw/link: Test: TODOList:/], 'list_pages symlink');
}

@pages = sort $rep->list_pages(':Test:');
#warn "Pages: ", map(">>$_<< ", @pages), "\n";
is_deeply(\@pages, [qw/foo: wiki/], 'list_pages 2');

# repeating previous test to catch bad caching
@pages = sort $rep->list_pages(':Test:');
#warn "Pages: ", map(">>$_<< ", @pages), "\n";
is_deeply(\@pages, [qw/foo: wiki/], 'list_pages 3');

# test caching in combo with new content
print "# sleeping 3 seconds ...\n";
print "# The following test may fail depending on IO buffering\n";
sleep 3; # make sure mtime is changed
file(qw/t notebook Test bar.txt/)->write("=== Bar ===\n\nfoo bar !\n" );
@pages = sort $rep->list_pages(':Test:');
#warn "Pages: ", map(">>$_<< ", @pages), "\n";
is_deeply(\@pages, [qw/bar foo: wiki/], 'list_pages 4');

# create / move / copy / delete
$page = $rep->get_page(':new');
is($page->status, 'new', 'new page 1');

$page->set_parse_tree(['Page', {}, 'test 1 2 3']);
$page = $rep->get_page(':new');
ok($page->exists, 'create page 1');

$page = $rep->get_page(':New:Foo');
is($page->status, 'new', 'new page 2');

$page->set_parse_tree(['Page', {}, 'test 1 2 3']);
$page = $rep->get_page(':New:Foo');
ok($page->exists, 'create page 2');

$page = $rep->get_page(':new');
$page->move( $rep->get_page(':move') ); # no root wrapper, so need object
$page = $rep->get_page(':new');
ok(! $page->exists, 'page move 1');
$page = $rep->get_page(':move');
is($page->get_parse_tree()->[2][2], "test 1 2 3\n", 'page move 2');
	# Returns like ['Page', {}, ['Para', {}, 'test 1 2 3']]

$page->copy( $rep->get_page(':copy') ); # no root wrapper, so need object
$page = $rep->get_page(':move');
is($page->get_parse_tree()->[2][2], "test 1 2 3\n", 'page copy 1');
$page = $rep->get_page(':copy');
is($page->get_parse_tree()->[2][2], "test 1 2 3\n", 'page copy 2');

$rep->get_page(':move')->move( $rep->get_page(':Move') );
is($rep->resolve_name('move'), ':Move', 'move is case sensitive');

$rep->get_page(':Move')->delete;
$rep->get_page(':copy')->delete;
$page = $rep->get_page(':Move');
ok(!$page->exists, 'delete page 1');
$page = $rep->get_page(':copy');
ok(!$page->exists, 'delete page 2');

# Test dispatching to child rep
print "## Zim parent object ##\n";
{
	my $rep = Zim->new(
		dir => $root,
		config => { no_vcs => 1 },
	);

	my $page = $rep->get_page(':test:wiki');
	is($page->{store}{namespace}, ':', 'Store dispatch 1');

	$page = $rep->get_page(':foo:bar');
	is($page->{store}{namespace}, ':', 'Store dispatch 2');

	# add child rep
	my $node = File::Spec->catdir($root, 'Foo');
	$rep->add_child(':foo', 'Files', dir => $node);

	$page = $rep->get_page(':test:wiki');
	is($page->{store}{namespace}, ':', 'Store dispatch 3');

	$page = $rep->get_page(':foo:bar');
	is($page->{store}{namespace}, ':foo:', 'Store dispatch 4');

	$page = $rep->get_page(':Foo');
	is($page->{store}{namespace}, ':foo:', 'Store dispatch 5');

	$page = $rep->get_page(':fooBar');
	is($page->{store}{namespace}, ':', 'Store dispatch 6');
}

## Documents API
print "\n## Documents API ##\n";
{
	my ($vol, undef, undef) = File::Spec->splitpath($ENV{PWD});
	my $rep = Zim->new(
		dir => $root,
		config => { no_vcs => 1 },
	);
	$rep->{document_root} = undef;
	$page = $rep->resolve_page(':test:wiki'); # physically "Test/wiki.txt"

	# document_dir
	{
		my $path = $page->{source}->path;
		$path =~ s/\.txt$/\//;
		is($page->document_dir, $path, 'document_dir');
	}

	# relative_path and resolve_file
	my $i = 1;
	my $j = 1;
	for my $t (
		# Paths in the notebook dir
		# $root - ./t/notebook - so we feed absolute paths
		[$root, 'foo.pdf'              => '../../foo.pdf'],
		[$root, qw/Test foo.pdf/       => '../foo.pdf'   ],
		[$root, qw/Test wiki bar.pdf/  => './bar.pdf'    ],

		# Path in the home dir
		[$ENV{HOME}, qw/foo bar.pdf/   => '~/foo/bar.pdf'],

		# Path in the file system root
		[$vol, qw/foo bar.pdf/        =>
			($^O eq 'MSWin32' ? "$vol/foo/bar.pdf" : '/foo/bar.pdf') ],
	) {
		my $rel = pop @$t;
		my $path = File::Spec->catfile(@$t);
		is($page->relative_path($path), $rel, 'relative_path '.$i++);
		my $resolved = Zim::FS->localize( $page->resolve_file($rel) );
			# $path is localized on e.g. win32, localize resolved
			# to be able to compare
		is($resolved, $path, 'resolve_file '.$j++);
	}

	{
		# URL in the notebook dir
		my $path = File::Spec->catfile($root, qw/Test wiki bar.pdf/);
		my $url = Zim::FS->path2uri( $path );
		is($page->relative_path($url), './bar.pdf', 'relative_path '.$i++);
		my $resolved = Zim::FS->localize( $page->resolve_file($url) );
			# $path is localized on e.g. win32, localize resolved
			# to be able to compare
		is($resolved, $path, 'resolve_file '.$j++);
	}

	# relative_path after setting document_root
	$rep->{document_root} = Zim::FS::Dir->new('./t');
	my $doc_root = File::Spec->rel2abs( File::Spec->catdir(qw/t/) );
	for my $t (
		# Path in document_root
		[$doc_root, qw/foo bar.pdf/ => '/foo/bar.pdf' ],

		# Path below both notebook dir and document_root
		[$root, qw/Test foo.pdf/       => '../foo.pdf'   ],
		
		# Path in file system root
		[$vol, qw/foo bar.pdf/      => 'file:///foo/bar.pdf' ],
	) {
		my $rel = pop @$t;
		$rel = Zim::FS->localize($rel) if $rel =~ m#^file://#;
		my $path = File::Spec->catfile(@$t);
		is($page->relative_path($path), $rel, 'relative_path '.$i++);
		my $resolved = Zim::FS->localize( $page->resolve_file($rel) );
			# $path is localized on e.g. win32, localize resolved
			# to be able to compare
		is($resolved, $path, 'resolve_file '.$j++);
	}

	{
		# URL below both notebook dir and document_root
		my $path = Zim::FS->path2uri(
			File::Spec->catfile($root, qw/Test wiki bar.pdf/) );
		is($page->relative_path($path), './bar.pdf', 'relative_path '.$i++);
	}

	# resolve_file backwards compatibility < 0.24
	my $page_dir = $page->{source}->dir;
	file($page_dir, 'baz.pdf')->touch;
	for my $t (
		['./foo.pdf' => qw/Test wiki foo.pdf/], # does not exist => default
		['./baz.pdf' => qw/Test baz.pdf/     ], # does exist => backward
	) {
		my $rel = shift @$t;
		my $path = File::Spec->catfile($root, @$t);
		my $resolved = Zim::FS->localize( $page->resolve_file($rel) );
			# $path is localized on e.g. win32, localize resolved
			# to be able to compare
		is($resolved, $path, 'resolve_file '.$j++);
	}

	# store_file
	$i = 1;
	my $doc_dir = $page->document_dir;
	file($doc_dir, 'equation_01.png')->touch;
	file($doc_dir, 'equation.png')->touch;

	die "BUG: this file should not exist"
		if -e file($doc_dir, 'equation_01.tex');
	for my $f (
		# dry run the private method _unique(DIR, FILE)
		['equation.png'     => 'equation_02.png'   ],
		['equation_XX.png'  => 'equation_02.png'   ],
		['equation_XXX.png' => 'equation_001.png'  ],
		['equation.tex'     => 'equation.tex'      ],
		['equation_XX.tex'  => 'equation_02.tex'   ],
	) {
		my ($name, $unique) = @$f;
		is( Zim::Store::_unique_name($doc_dir, $name),
			$unique, 'unique_name '.$i++);
	}

	my $buffer = buffer("This is a PNG :)\n");
	my $rel = $page->store_file($buffer, 'equation_XX.png', 0);
	is($rel, './equation_02.png', 'store_file copy name');
	is(
		"".file($doc_dir, 'equation_02.png')->read,
		"This is a PNG :)\n",
		'store_file copy content' );
	
	$rel = $page->store_file($buffer, 'equation_XX.png', 1);
	is($rel, './equation_03.png', 'store_file move name');
	is(
		"".file($doc_dir, 'equation_03.png')->read,
		"This is a PNG :)\n",
		'store_file move content' );
	ok(! $buffer->exists, 'move worked');

}

## Notebook list API
print "\n## Notebook list API ##\n";
{
	my @list = (
		['_default_' => 'foo'],
		['foo' => '/foo/bar/'],
		['foo bar!' => '/bar/foo']
	);
	my $path = ($^O eq 'MSWin32') ? 'C:/foo/bar/' : '/foo/bar/' ;
	Zim->set_notebook_list(@list);
	is_deeply([Zim->get_notebook_list], \@list, 'get/set notebook list');
	is(Zim->get_notebook('foo'), $path, 'get notebook');
	is(Zim->get_notebook('_default_'), $path, 'get default notebook');
}

