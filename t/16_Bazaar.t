use Test::More;
require 't/env.pm';

use strict;
use File::Path;
use Zim;
use Zim::Utils;
use Zim::FS::Bazaar;

# We use /tmp here because ./t can already be under version control
my $root = dir(Zim::FS->tmpdir, 'Zim-test-Bazaar');

rmtree("$root") or die "Could not remove dir: $root\n" if $root->exists;
$root->touch or die "Could not create dir: $root\n";

eval { $root = Zim::FS::Bazaar->init($root) };
if ($@) {
	plan skip_all => 'bzr not available';
	exit;
}
else {
	plan tests => 14;
}

my $subdir = $root->subdir('foo', 'bar');
is(ref($subdir), 'Zim::FS::Bazaar', 'subdir has proper class');

my $vcs = Zim->check_version_control("$subdir");
is(ref($vcs), 'Zim::FS::Bazaar', 'Bazaar root detected');
is($vcs->path, $root, 'Bazaar root ok');

my $file = $subdir->file('baz.txt');
$file->write("foo\nbar\n");

is($root->status, <<'EOT', 'status()');
added:
  .bzrignore
  foo/
  foo/bar/
  foo/bar/baz.txt
EOT

$root->commit('commit 1 foo bar');
my $diff = $root->diff(undef, 0, 1);
my $added = join '', map "$_\n", grep /^=== /, split /\n/, $diff;
is($added, <<'EOT', 'commit() 1');
=== added file '.bzrignore'
=== added directory 'foo'
=== added directory 'foo/bar'
=== added file 'foo/bar/baz.txt'
EOT

is($root->diff(), "=== No Changes\n", 'commit() 2');

$file->write("foo\nbaz\n");
$diff = $root->diff;
$diff =~ s/^(\+\+\+|---) .*$//mg;
$diff =~ s/\n\n+/\n/g;
is($diff, <<'EOT', 'diff() current');
=== modified file 'foo/bar/baz.txt'
@@ -1,2 +1,2 @@
 foo
-bar
+baz
EOT

$root->revert($file);
is($root->diff(), "=== No Changes\n", 'revert()');
$file->write("foo\nbaz\n");

$root->commit('commit 2 baz');
$diff = $root->diff(undef, 1, 2);
$diff =~ s/^(\+\+\+|---) .*$//mg;
$diff =~ s/\n\n+/\n/g;
is($diff, <<'EOT', 'diff() versions');
=== modified file 'foo/bar/baz.txt'
@@ -1,2 +1,2 @@
 foo
-bar
+baz
EOT

# checklist_version
my @versions = $root->list_versions;
#use Data::Dumper; warn Dumper \@versions;
# FIXME difficult to check contents with time stamps etc.
is(scalar(@versions), 2, 'list_versions()');

is($root->cat_version($file, 1), "foo\nbar\n", 'cat_version()');

my $ann = $root->annotate($file);
$ann =~ s/^(\d).*?\|/$1|/mg;
is($ann, <<'EOT', 'annotate()');
1| foo
2| baz
EOT

$file->move($root->file('bar.txt'));
is($root->diff, <<'EOT', 'move()');
=== renamed file 'foo/bar/baz.txt' => 'bar.txt'
EOT

eval { $root->diff('/foo') };
my $error = $@;
$error =~ s/^/# /mg;
print $error;
ok($@, 'die on exception');

