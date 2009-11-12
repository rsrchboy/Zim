use Test::More tests => 5;
require 't/env.pm';

use strict;
use Zim;
use Zim::Utils;

my $file = file('t/cache/test.gjots');
$file->write(<<'EOT');
Some test file in gjots format

By me
\NewEntry

Front page without title
\NewEntry
Pages
\NewFolder
\NewEntry
Foo

FooBaR!
\NewEntry
Bar

Dusss
\EndFolder
\NewEntry
Some toplevel page
\NewEntry
More Pages
\NewFolder
level1
\NewFolder
level2
\NewEntry
Hmmm

dus
\EndFolder
\EndFolder
EOT

my $nb = Zim->new(file => $file);
is(ref($$nb{':'}), 'Zim::Store::Gjots', 'gjots file detected correctly');
#use Data::Dumper; warn Dumper $nb;

is_deeply([$nb->list_pages(':')], ['test.gjots:'], 'list_pages 1');

my @pages = ('More_Pages:', 'no-title', 'Pages:', 'Some_toplevel_page',); 
is_deeply([$nb->list_pages(':test.gjots')], \@pages, 'list_pages 2');

my $tree = ['Page', {}, "Foo\n\nFooBaR!\n"];
is_deeply($nb->get_page(':test.gjots:Pages:Foo')->get_parse_tree, $tree, 'get_page 1');

$tree = ['Page', {}, "Hmmm\n\ndus\n"];
is_deeply($nb->get_page(':test.gjots:More_Pages:level1:Hmmm')->get_parse_tree, $tree, 'get_page 2');

