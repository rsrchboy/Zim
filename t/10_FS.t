use Test::More tests => 111;
require './t/env.pm';

use strict;
use File::Spec;
use Zim::Utils;
use File::Path;

my $root = File::Spec->rel2abs(
		File::Spec->catdir('t', 'cache') ).'/';
my ($vol, undef, undef) = File::Spec->splitpath($ENV{PWD});

my $f = File::Spec->rel2abs(
	File::Spec->catfile($root, 'test_file.txt~') );
unlink $f;

my $d = File::Spec->rel2abs(
	File::Spec->catdir($root, qw/test_file foo bar baz/) ).'/';
my $p = File::Spec->rel2abs(
	File::Spec->catdir($root, qw/test_file/) ).'/'; # parent dir

if ($^O eq 'MSWin32') {
		# translate backslash to slash
		s#\\#/#g for $root, $f, $d, $p;
}


## Zim::FS
print "## FS\n";
{
	# ENV
	ok(length($ENV{HOME}) && -d $ENV{HOME}, 'Home dir set');
	ok(length($ENV{PWD}) && -d $ENV{PWD}, 'Working dir set');

	# Paths
	my @path = ($^O eq 'MSWin32')
		? (
			'/foo//bar\../c/d/e\.././../q/./baz',
			'C:/xx',
			'C:/foo/c/q/baz'
		) : (
			'/foo//bar/../c/d/e/.././../q/./baz',
			'x',
			'/foo/c/q/baz'
		) ;
	is(
		Zim::FS->abs_path($path[0], $path[1]), $path[2],
		'path cleanup 1');
	ok(length Zim::FS->abs_path('/../../../'), 'path cleanup 2');

	# Absulote and Relative paths
	ok(Zim::FS->is_abs_path('/foo/bar'),    'is_abs_path 1');
	ok(! Zim::FS->is_abs_path('./foo/bar'), 'is_abs_path 2');
	ok(! Zim::FS->is_abs_path('bar'),       'is_abs_path 3');
	ok(Zim::FS->is_abs_path('file:///bar'), 'is_abs_path 4');
	SKIP: {
		skip("Win32 specific", 3) unless $^O eq 'MSWin32';
		ok(Zim::FS->is_abs_path('C:/foo/bar'),   'is_abs_path 5');
		ok(Zim::FS->is_abs_path('C:\\foo\\bar'), 'is_abs_path 6');
		ok(Zim::FS->is_abs_path('\\\\foo\bar'),  'is_abs_path 7');
	}
	
	is(Zim::FS->abs_path('t/cache/test_file.txt~'), $f, 'abs_path');
	is(Zim::FS->abs_path('foo', '/bar'), '/bar/foo',  'abs_path with ref 1');
	is(Zim::FS->abs_path('/foo', '/bar'), '/foo',     'abs_path with ref 2');
	is(Zim::FS->abs_path('~/foo'), $ENV{HOME}.'/foo', 'abs_path home dir');
	is(Zim::FS->abs_path('file:///foo'),
			($^O eq 'MSWin32' ? $vol.'/foo' : '/foo'), 'abs_path uri');
		# On Win32 a volume is added by abs_path()
		# however if the reference lacks volume, the same goes for the result
	
	is(Zim::FS->rel_path('/foo/bar/baz/dus', '/foo/bar'), './baz/dus',
		'rel_path');
	is(Zim::FS->rel_path('/foo/bar', '/dus/ja'), undef,
		'rel_path fail');
	is(Zim::FS->rel_path('/foo/bar/hmm', '/foo/bar/baz/dus', 1), '../../hmm',
		'rel_path upward');

	# localize
	my ($vol, undef, undef) = File::Spec->splitpath($ENV{PWD});
	is( Zim::FS->localize('/foo/bar'),
		($^O eq 'MSWin32' ? "$vol\\foo\\bar" : '/foo/bar'),
		'localize file' );
	is( Zim::FS->localize('file:///foo/bar'),
		($^O eq 'MSWin32' ? "file:///$vol/foo/bar" : 'file:///foo/bar'),
		'localize file uri' );

	# Uris
	my @uris = (
		['file:///foo/bar', '/foo/bar'],
		['file:/foo/bar',   '/foo/bar'],
		['file://localhost/foo/bar', '/foo/bar'],
		['file://foo/bar',  'file://foo/bar'],
	);

	# Win32 uris
	SKIP: {
		skip("Win32 specific", 5) unless $^O eq 'MSWin32';

		push @uris,
			['file:///C:/foo',   'C:/foo'], # and not /C:/foo
			['file:////foo/bar', 'smb://foo/bar'] ;

		my $i = 0;
		for (
			['C:/foo/bar',    'C:\foo\bar'],
			['smb://foo/bar', '\\\\foo\bar'],
		) {
			is(Zim::FS->localize($$_[0]), $$_[1],
				"win32 localize ".++$i );
		}

		my $f = "C:\\foo\\bar";
		$f = Zim::FS->path2uri($f);
		$f = Zim::FS->uri2path($f);
		$f = Zim::FS->localize($f);
		ok($f eq "C:\\foo\\bar", 'win32 uri round trip');
	};

	my $i = 0;
	is(
		Zim::FS->uri2path($$_[0]), $$_[1],
		'parse_uri '.++$i
	) for @uris;

	# cache_file
	my $tfile = Zim::FS::File->new(qw/t cache zim tmp_cached.txt/);
	$tfile->remove if $tfile->exists;
	my $cfile = Zim::FS->cache_file('/tmp/cached.txt');
	print "# cache_file: $cfile\n";
	$cfile->write("Test cache_file 1 2 3\n");
	is($tfile->read, "Test cache_file 1 2 3\n", 'cache_file');
	
	# tmp_file
	$ENV{USER} ||= 'USER'; # prevent warnings if not set
	$tfile = Zim::FS::File->new(
		File::Spec->tmpdir, "zim-$ENV{USER}-$$-test.txt");
	$tfile->remove if $tfile->exists;
	my $tmpfile = Zim::FS->tmp_file('test.txt');
	print "# tmp_file: $tmpfile\n";
	$tmpfile->write("Test tmp_file 1 2 3\n");
	SKIP: {
		skip('tmp_file mode not supported on Win32', 1) if $^O eq 'MSWin32';
		is((stat($tmpfile))[2] & 07777, 0600, 'tmp_file mode');
	}
	is($tfile->read, "Test tmp_file 1 2 3\n", 'tmp_file');
	$tfile->remove if $tfile->exists;
}


## Zim::FS::File
print "## File\n";
{
	# Construct
	my $file = file($root, 'test_file.txt~');
	ok($file->isa('Zim::FS::File'), 'constructor');
	ok(! $file->exists, 'file does not yet exist');
	ok(-d $file->dir, 'dir does exist');

	# Path info
	is($file->path, $f, 'path');
	is($file->uri, Zim::FS->path2uri($f), 'uri');
	is($file->dir, $root, 'dir');
	ok($file->dir->isa('Zim::FS::Dir'), 'dir is object');
	is($file->name, 'test_file.txt~', 'name');
	is($file->basename, 'test_file', 'basename');
	is("$file", $f, 'overload');

	# Write
	$file->write("test 123\ntest 456\n");
	is(cat($f), "test 123\ntest 456\n", 'write');
	$file->append("test 789\n");
	is(cat($f), "test 123\ntest 456\ntest 789\n", 'append');

	# Read
	is($file->read, "test 123\ntest 456\ntest 789\n", 'read as scalar');
	is_deeply(
		[$file->read],
		["test 123\n","test 456\n","test 789\n"],
		'read as list' );

	# Stat
	ok($file->exists, 'exists');

	# TODO touch - also touch something case-sensitive
	# TODO move
	# TODO copy

	# Remove
	$file->remove();
	ok(! -e $f && ! $file->exists, 'remove');
}


## Zim::FS::Dir
print "## Dir\n";
{
	# Constructor
	my $dir = dir( dir($root), qw/test_file foo bar baz/);
	ok($dir->isa('Zim::FS::Dir'), 'constructor');
	rmdir $dir if -d $dir;
	ok(! $dir->exists, 'dir does not yet exist');

	# Path info
	is($dir->path, $d, 'path');
	is("$dir", $d, 'overload');
	is($dir->uri, Zim::FS->path2uri($d), 'uri');
	is($dir->name, "baz", 'name');

	# Create / Delete
	$dir->touch;
	ok(-d $dir, 'touch');
	$dir->cleanup;
	ok(! -e $d && ! -e $p, 'cleanup');
}

{
	# List and lookup
	my $dir = dir(qw#t notebook Test#);
	is_deeply(
		[sort $dir->list],
		[qw/foo foo.txt wiki.txt/],
		'list dir' );
	ok($dir->file('foo.txt')->read =~ /= Foo =/, 'get file');
}

{
	# Files
	my $dir = dir( dir($root), qw/test_file foo bar baz/);

	my $file = $dir->file('dus', 'ja.txt');
	$file->touch;
	ok(-f "$dir/dus/ja.txt", 'autovivicate dir');
	$dir->cleanup($file);
	ok(! -e "$dir/dus" && -d $dir, 'cleanup file');

	$dir->cleanup;
}

{
	# Subdir
	my $dir = dir(qw#t notebook Test#);

	# normal case
	my $subdir1 = $dir->subdir(qw#foo bar#);
	is("$subdir1", "".dir(qw#t notebook Test foo bar#), 'subdir works 1');
	is("".$subdir1->parent, "$dir", 'subdir works 2');

	# special cases
	my $dir2 = dir(qw#t notebook Test foo bar#);
	my $subdir2 = $dir->subdir($dir2);
	is("$subdir2", "$subdir1", 'subdir works with object arg 1');
	is("".$subdir2->parent, "$dir", 'subdir works with object arg 2');

	my $subdir3 = $dir->subdir('.');
	is("$subdir3", "$dir", 'subdir works for \'.\' arg');
}

{
	# Case-insensitive lookup
	my $dir = dir($root, 'Case');
	file($dir, 'Test.txt')->write("test 1 2 3\n");
	my $case_sensitive = ! -f "$dir/tesT.txt";
	warn "# Case in-sensitive file system\n" if ! $case_sensitive;
	
	$dir->file($_.'.txt')->touch for qw/Test TestIt foo Foo/;
		# Note that for case in-sensitive FS only 'foo' is touched.
		# When we try to touch 'Foo' it already exists.
	$dir->subdir('Bar')->touch;

	# Here we test look-up, should also work for in-sensitive FS
	my $i = 0;
	for (
		['test' => 'Test'],
		['Test' => 'Test'],
		['TEST' => 'Test'],
		['bar'  => 'Bar' ]  # resolve case based on dir
	) {
		is($dir->resolve_file('txt', $$_[0]), $dir."$$_[1].txt",
			'resolve_file '.++$i);
	}

	SKIP: {
		skip("Case in-sensitive file system", 3) if ! $case_sensitive;
		# Here we test with two files with the only difference in
		# the naming of the case.
		for (
		['foo'  => 'foo' ],
		['Foo'  => 'Foo' ],
		['FOO'  => 'Foo' ], # "Foo" sorts for "foo"
	) {
		is($dir->resolve_file('txt', $$_[0]), $dir."$$_[1].txt",
			'resolve_file '.++$i);
	}
	}

	is($dir->resolve_file('.txt', 'TEST', 'foo'), $dir."Test/foo.txt",
			'resolve_file '.++$i);
			# Case for non-existing dir based on file name.
			# put in ".txt" instead of "txt" to test robustness
	
	# Here we test look-up, should also work for in-sensitive FS
	$i = 0;
	for (
		['bar'  => 'Bar' ],
		['Bar'  => 'Bar' ],
		['BAR'  => 'Bar' ],
		['test' => 'Test']  # case based on file
	) {
		is($dir->resolve_dir('txt', $$_[0]), $dir."$$_[1]/",
			'resolve_dir '.++$i);
	}

	SKIP: {
		skip("Case in-sensitive file system", 1) if ! $case_sensitive;
		# Here we test with two files with the only difference in
		# the naming of the case.
		for (
		['FOO'  => 'Foo' ],
				# case based of file, "Foo" sorts for "foo"
	) {
		is($dir->resolve_dir('txt', $$_[0]), $dir."$$_[1]/",
			'resolve_dir '.++$i);
	}
	}

	is($dir->resolve_dir('txt', 'TEST', 'foo'), $dir."Test/foo/",
			'resolve_dir '.++$i);
			# Case for non-existing dir based on file name.
	
}


## Zim::FS::IO
print "## IO\n";
{
	{
		package Zim::FS::Dir::Test;
		our @ISA = qw/Zim::FS::Dir/;
		sub on_write_file { $_[0]{on_write} && $_[0]{on_write}->() }
	}

	my $dir = Zim::FS::Dir::Test->new($root);
	my $file = $dir->file('test_file.txt~');
	$file->write("Test 123\n");

	my $io = $file->open;
	ok($io->isa('Zim::FS::IO'), 'open returns object');
	$io->close;

	my $check = 0;
	$dir->{on_write} = sub { $check = 1 };
	$io = $file->open('w');
	print $io "Test 123\n";
	$io->close;
	ok($check, 'write event');

	$file->write("foo\r\n");
	is($file->read, "foo\n", "DOS line ending conversion");
}


## Zim::FS::File::Config
print "## Config file\n";
{
	my $file = Zim::FS::File::Config->new($root, 'test_file.txt~');
	
	Zim::FS::File::write($file, "a=1\nc=2\nb=3\n"); # write raw
	is_deeply($file->read(), {a => 1, b => 3, c => 2},
		'backwards compat for config' );
	
	$file->write({a => 1, b => 3, c => 2});
	is(cat($f), "[Default]\na=1\nb=3\nc=2\n\n# vim: syntax=desktop\n",
		'write config');
	
	Zim::FS::File::write($file,
		"[Default]\na=1\n# comment\nc=2\n; garbage\nb=3\n"); # write raw
	is_deeply($file->read(), {a => 1, b => 3, c => 2}, 'read config' );
	
	my $hash = {
		foo => 'bar',
		test => 0,
		empty => '',
		Settings => {
			is_fubar => 0,
			true => 'false',
		},
		Questions => {
			yes => 'no',
			number => 5,
		}
	};
	$file->write($hash);
	die unless exists $$hash{foo} and exists $$hash{Settings};
		# make sure we do not delete from hash
	is_deeply($file->read({empty => 'non-empty'}), $hash, 'write/read nested data');
		# also checks if empty values reset default values

	$file->remove;
}


# Zim::FS::File::CheckOnWrite
print "## Checked file\n";
{
	my $raw = file($root, 'test_file.txt~');
	$raw->remove if $raw->exists;

	my $file = Zim::FS::File::CheckOnWrite->new($root, 'test_file.txt~');
	die unless "$raw" eq "$file"; # just to be sure
	
	$file->write('Test 1 2 3');
	print "# sleeping 3 seconds ...\n";
	sleep 3; # make sure we have new mtime
	$raw->write('Foo');
	eval { $file->write('Test 4 5 6') };
	ok($@, 'check mtime 1');

	$file->read;
	eval { $file->write('Test 4 5 6') };
	ok(!$@, 'check mtime 2');

	$file->write('Hmmm..');
	ok( ($file->read eq 'Hmmm..' and ! -e $$file{tmp_path}), 'Atomic write 1');

	$raw->write('Foo Bar!');
	eval {
		local $SIG{__WARN__} = sub {};
		my $fh = $file->open('w');
		print $fh 'Hmm';
		die;
	};
	is($file->read, 'Foo Bar!', 'Atomic write 2');
}

# Zim::FS::File::CacheOnWrite
print "## Cached file\n";
{
	my $raw = file($root, 'test_file.txt~');
	$raw->remove if $raw->exists;
	my $cache = Zim::FS->cache_file("$raw");
	$cache->remove if $cache->exists;

	my $file = Zim::FS::File::CacheOnWrite->new($root, 'test_file.txt~');
	die unless "$raw" eq "$file"; # just to be sure
	is("$$file{cache_file}", "$cache", "correct cache file");
	
	$file->write('Test 1 2 3');
	print "# sleeping 3 seconds ...\n";
	sleep 3; # make sure we have new mtime
	$raw->write('Foo');
	eval {
		$file->write('Test 4 5 6');
		$file->commit_change
	};
	ok($@, 'check mtime 1');

	$file->discard_change;
	$file->read;
	eval {
		$file->write('Test 4 5 6');
		$file->commit_change
	};
	ok(!$@, 'check mtime 2');

	$raw->write('FOO!');
	$file->write('Hmmm..');
	is($raw->read, 'FOO!', 'Cached write 1');
	is($cache->read, 'Hmmm..', 'Cached write 2');
	$file->commit_change;
	ok(
		(
			$file->read eq 'Hmmm..' and
			! ($$file{tmp_path} && -e $$file{tmp_path}) and
			! $cache->exists
		),
	       	'Atomic write 1');

	$raw->write('Foo Bar!');
	eval {
		local $SIG{__WARN__} = sub {};
		my $fh = $file->open('w');
		print $fh 'Hmm';
		die;
	};
	is($file->read, 'Foo Bar!', 'Atomic write 2');
}

{
	# start with new object using existing cache
	my $raw = file($root, 'test_file.txt~');
	my $cache = file( Zim::FS->cache_file($raw) );

	$cache->write('Test 1 2 3');
	my $file = Zim::FS::File::CacheOnWrite->new($root, 'test_file.txt~');
	is($file->read, 'Test 1 2 3', 'use existing cache file');

	print "# sleeping 3 seconds ...\n";
	sleep 3; # make sure we have new mtime
	$raw->write('Hmm');
	eval { $file->commit_change };
	ok($@, 'check mtime on commit');
	$file->discard_change; # prevent error in clean-up
}

## Zim::FS::URI
print "## URI object\n";
{
	my $uri = uri('/foo/bar');
	is($uri->uri, '/foo/bar', 'uri');

	my $dir = $uri->dir;
	is($dir, '/foo/', 'dir 1');
	is($dir->dir, '/', 'dir 2');

	$uri = uri('http://foo.bar/');
	is($uri->subdir('baz'), 'http://foo.bar/baz/', 'subdir');
	is($uri->file(qw/dus ja.html/), 'http://foo.bar/dus/ja.html', 'file');
}

## Zim::FS::Buffer
print "## Memory buffer\n";
{
	my $buffer = buffer("Test 1 2 3\nFOO BAR !\n");
	is_deeply([$buffer->read],
		["Test 1 2 3\n", "FOO BAR !\n"], 'read buffer');
	my $fh = $buffer->open('r');
	is_deeply([<$fh>],
		["Test 1 2 3\n", "FOO BAR !\n"], 'open buffer');
	$buffer->append("Hmmm ?\n");
	is("".$buffer->read, "Test 1 2 3\nFOO BAR !\nHmmm ?\n", 'append to buffer');
	ok($buffer->exists, 'buffer exists');
	$buffer->remove;
	ok(!$buffer->exists, 'remove buffer');

	my $text;
	$buffer = buffer(\$text);
	$buffer->write('Foo Bar Baz !');
	is($text, 'Foo Bar Baz !', 'write buffer');

}

exit;


sub cat { # Method to check file contents
	my $file = shift;
	CORE::open FILE, $file or die "$!: $file\n";
	my $content = join '', <FILE>;
	CORE::close FILE;
	return $content;
}

