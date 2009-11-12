#!/usr/bin/perl

use strict;
use File::DesktopEntry 0.03;
use Data::Dumper;
use Encode;

# This script is triggered by ./Build distmeta or ./Build dist

# This script converts all the .po files in ./po/ into perl hashes in
# ./share/zim/lingua/ . It also updates ./TRANSLATORS and $TRANSLATORS
# in Zim.pm (which is used for the "About" dialog) and the translatable
# srings in ./share/applications/zim.desktop .
# This script is called by "./Build distmeta".

# Note: This script does _not_ use binmode :utf8, the reason for this is 
# that we don't want Data::Dumper to escape all utf8. As a consequence we 
# need to use Encode before we hand over text to File::DesktopEntry, which
# expects utf8.

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;

my $dir = "share/zim/lingua";
mkdir $dir or die $! unless -e $dir;

my $translators = '';

for my $file (<po/*.po>) {
	$file =~ /po\/(.*)\.po$/;
	my $lang = $1;
	my $out = "$dir/$lang.pl";
	warn "Compiling $file -> $out\n";

	my ($fuzzy, $empty) = (0, 0);

	# parse po keys
	open IN, $file or die $!;
	my @t;
	my $l = 0;
	my $meta = '';
	my $head = 1;
	while (<IN>) {
		$l++;
		$fuzzy++ if /^#,/ and /fuzzy/;
		if (/^#/ and $head) { $meta .= $_ }
		else { $head = 0 }
		next if /^#/;
		next if ! /\S/;
		chomp;
		s/\s*$//;
		if (/^(\w+(\[\d+\])?)\s+".*?"$/) {
			my $k = $1;
			s/^\Q$k\E\s+//;
			if ($k eq 'msgid') {
				die "unexpected key '$k' at line $l\n"
					unless $#t % 2; # 0, 2, 4, ..
				push @t, value($_);
			}
			elsif ($k eq 'msgid_plural') {
				die "unexpected key '$k' at line $l\n"
					unless not $#t % 2; # 1, 3, 5, ..
				push @t, [];
			}
			elsif ($k eq 'msgstr') {
				die "unexpected key '$k' at line $l\n"
					unless not $#t % 2; # 1, 3, 5, ..
				push @t, value($_);
			}
			elsif ($k =~ /^msgstr\[(\d+)\]$/) {
				my $i = $1;
				die "unexpected key '$k' at line $l\n"
					unless ref $t[-1];
				push @{$t[-1]}, value($_);
				die "plural out of sequence at line $l\n"
					unless $#{$t[-1]} == $i;
			}
			else { die "unknown key '$k' at line $l\n" }
		}
		elsif (/^".*?"/) {
			if   (ref $t[-1]) { $t[-1][-1] .= value($_) }
			else              { $t[-1] .= value($_)     }
		}
		else { die "unknown string >>$_<< at line $l\n" }
	}
	close IN;

	# array to hash
	my %t = (@t);

	# some checks
	for my $k (keys %t) {
		my $s = $t{$k};
		unless (length $s) {
			$empty++;
			next;
		}
		my @param = ($k =~ /(\{\w+\})/g);
		if (ref $s) {
			for my $i (0 .. $#$s) {
				warn "Translation missing parameter(s)\n".
				     "msgid: $k\n".
				     "msgstr[$i]: $$s[$i]\n"
					if  $$s[$i] =~ /\S/ and
					grep {$$s[$i] !~ /\Q$_\E/} @param;
			}
		}
		else {
			warn "Translation missing parameter(s)\n".
			     "msgid: $k\n".
			     "msgstr: $s\n"
				if grep {$s !~ /\Q$_\E/} @param;
		}
	}

	# get translators
	my $trans = delete $t{'translator-credits'};
	#$trans = Encode::decode_utf8($trans);
	$trans =~ s/Launchpad Contributions:\n//g;
	$trans =~ s/\s*https?:\/\/.*//g;
	$trans =~ s/^\s*//mg;
	$trans =~ s/$/ ($lang)/mg;
	$translators .= $trans . "\n";
	$meta .= "\nTRANSLATORS:\n$trans\n\n";

	# get other meta data
	$meta .= delete $t{''};
	#$meta = Encode::decode_utf8($meta);
	$meta =~ s/^#? ?/# /gm;

	# HACK-unsave extraction of code
	my $plural = "# sub {my \$n = shift; \$n != 1},\n";
	if ($meta =~ /Plural-Forms:\s+nplurals=\d+;\s+plural=(.*?);/) {
		my $expr = $1;
		$expr =~ s/n/\$n/g;
		$plural = "sub {my \$n = shift; $expr},\n";
	}
	$plural = "# Subroutine to determine plural:\n".$plural;

	# dump hash to string
	my $hash = Dumper \%t;
	$hash =~ s/^\$VAR1\s*=\s*/# Hash with translation strings:\n/;
	
	# write out everything
	open OUT, '>', $out or die $!;
	print OUT join "\n", $meta, "use utf8;\n", $plural, $hash;
	close OUT;

	# update desktop file
	my $df = File::DesktopEntry->new('share/applications/zim.desktop');
	for my $key (qw/Name Comment GenericName/) {
		my $value = $df->get($key.'[C]');
		my $trans = $t{$value};
		$trans = Encode::decode_utf8($trans);
		$df->set("$key\[$lang\]" => $trans) if length $trans;
	}
	$df->write;

	warn "$empty not translated, $fuzzy fuzzy\n" if $empty || $fuzzy;
}

# Loose doubles, and sort names
my %translators = map {($_ => 1)} 
	grep {$_ !~ /Jaap Karssenberg/} # false positives on launchpad
	split /\n+/, $translators;
$translators{'Jaap Karssenberg (nl)'} = 1;
$translators = join "\n", sort keys %translators;

# update TRANSLATORS
open TRANSLATORS, '>TRANSLATORS' or die $!;
print TRANSLATORS $translators, "\n";
close TRANSLATORS;

# update credits in Zim.pm
my $zim = '';
our $skip = 0;
open ZIM, 'lib/Zim.pm' or die $!;
while (<ZIM>) {
	if (/our \$TRANSLATORS/) {
		$zim .= $_ . $translators . "\n";
		$skip = 1;
	}
	elsif (/}/) { $skip = 0 }
	$zim .= $_ unless $skip;
}
close ZIM;

open ZIM, '>lib/Zim.pm' or die $!;
print ZIM $zim;
close ZIM;

exit;

sub value {
	my $str = shift;
	$str =~ s/^"|"$//g;
	# reduce escapes etc. HACK un-save !
	$str =~ s/([\$\@\%\&])/\\$1/g;
	$str = eval "qq#$str#";
	return $str;
}

