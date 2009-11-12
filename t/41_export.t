use Test::More tests => 5;
require 't/env.pm';

use strict;
use Zim;
use Zim::Utils;
use Zim::Selection;

my $root = File::Spec->rel2abs( File::Spec->catdir(qw/t notebook/) );
my $rep = Zim->new(dir => $root);

my $file = file($root, qw/.. html Test wiki.html/);
$file->remove if $file->exists;
die "File already exists: $file" if $file->exists;

my $selection = Zim::Selection->new($rep, {}, ':Test:wiki');
$selection->export( {
	dir => File::Spec->catdir(qw/t html/),
	format => 'html',
	media => 'none',
} );

ok($file->exists, 'Exported file exists');
ok($file->read =~ m#This is a <b>test page</b> to see how parsing goes#, 'File has html content');

$file->remove if $file->exists;
die "File already exists: $file" if $file->exists;

SKIP: {
	system($^X, './bin/zim', '--version') == 0
		or skip('Executing ./bin/zim failed !?', 3);
	my $r = system($^X, './bin/zim', '--export', 'dir=./t/html,format=html', './t/notebook');
	ok($r == 0, 'command line export');
	ok($file->exists, 'Exported file exists');
	ok($file->read =~ m#This is a <b>test page</b> to see how parsing goes#, 'File has html content');
}

