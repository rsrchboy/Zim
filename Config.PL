#!/usr/bin/perl

use lib './lib';
use Zim::FS;
use Zim::Page;
use Zim::Formats::Pod;
use Zim::Formats::Wiki;

# This script is triggered by ./Build distmeta or ./Build dist

# This script reads the default config values from GUI.pm
# and writes the config files ia ./share/zim .
# The default config is written to default.conf,
# __DATA__ below contains other profiles like reader.conf .
# This script is called by "./Build distmeta".

# Next it gets all the commandline options from the bin/zim
# POD description and writes share/zim/doc/Usage/commandline.txt
# (this is not really config but well...)

$SIG{__WARN__} = sub { print STDERR @_ unless $_[0] =~ /^#/ };

# Parse config

open IN, 'lib/Zim/GUI.pm' or die $!;
while (<IN>) { last if /CONFIG/ }
while (<IN>) {
	/\{/ and next;
	/\}/ and last;
	chomp;
	($k, $v) = split /\s+/, $_, 2;
	$CONFIG{$k} = $v;
}
close IN;

#use Data::Dumper;
#print Dumper \%CONFIG;

$f = Zim::FS::File::Config->new(qw/share zim default.conf/);
print "Writing $f\n";
$f->write(\%CONFIG, 'Config');

while (<DATA>) {
	if (/^%%\s*(\S+)\s*%%$/) {
		$f = Zim::FS::File::Config->new(qw/share zim/, $1);
		%config = %CONFIG;
		print "Writing $f\n";
	}
	elsif (/^(.+?)=(.*)/) {
		$config{$1} = $2;
	}
	else { $f->write(\%config, 'Config') }
}

# Parse POD
my $pod = Zim::FS::File->new(qw/bin zim/);
my $doc = Zim::FS::File->new(qw/share zim doc Usage commandline.txt/);
my $page = Zim::Page->new(undef, ':Usage:commandline');
die "$_ does not exist" for grep {! -f $_} $pod, $doc;

my $tree = Zim::Formats::Pod->load_tree($pod->open('r'), $page);

# extract OPTIONS section
my $options = 0;
@$tree = grep {
	$options = ($$_[2] eq 'OPTIONS') ? 1 : 0
		if ref($_) eq 'ARRAY' and $$_[0] eq 'head1';
	$options;
} @$tree;

# remove bullets and redundant empty line
for (grep {! ref $_} @$tree) {
	s/^(\n|\x{2022} )//;
}
@$tree = grep length($_), @$tree;

# turn head to level 2 and add header
splice @$tree, 0, 1, ['head2', {}, 'Options'], "\n";
unshift @$tree, 'Page', {},
	['head1', {}, 'Commandline Usage'], << "EOT";

Usage: zim [OPTIONS] [NOTEBOOK [PAGE]]

\x{2022} OPTIONS: see below
\x{2022} NOTEBOOK: name or directory
\x{2022} PAGE: the page to open

EOT

# Dump as wiki text
my $io = $doc->open('w');
warn "Writing $doc\n";
Zim::Formats::Wiki->save_tree($io, $tree, $page);
$io->close;

__DATA__
%% reader.conf %%
read_only=1
plugins=

