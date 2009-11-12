require Test::More;
require File::Spec;
use strict;

my $devnull = File::Spec->devnull;

# Check if we have a working msgfmt
my $has_msgfmt = eval { system("msgfmt -V > '$devnull'") == 0 };
unless ($has_msgfmt) {
	Test::More->import(skip_all => 'msgfmt not available');
	exit;
}

# Run msgfmt -c for all po files to check for errors
my @files = <po/*.po>;
Test::More->import(tests => scalar @files);

for my $f (@files) {
	ok( system('msgfmt', '-o', $devnull, '-c', $f) == 0, $f );
}

