use Test::More tests => 7;
require 't/env.pm';

use strict;
use Zim::Utils;

my $i = 0;
for (
	["24/12/2007", 2007,12,24],
	["2007 12 24", 2007,12,24],
	["2007_12_24", 2007,12,24],
) {
	my ($fmt, @date) = @$_;
	my @result = Zim::Utils::parse_date($fmt);
	#warn "$fmt => ", join ' ', map ">>$_<<", @result;
	is_deeply(\@result, \@date, 'parse_date '.++$i);
}

$i = 0;
my $t = time;
for (
	["24/12/2007", 0,0,0, 24,11,107],
	["2007 12 24", 0,0,0, 24,11,107],
	["2007_12_24", 0,0,0, 24,11,107],
	[$t, localtime($t)],
) {
	my ($fmt, @date) = @$_;
	my @result = Zim::Utils::parse_date_l($fmt);
	#warn "$fmt => ", join ' ', map ">>$_<<", @result;
	is_deeply(\@result, \@date, 'parse_date_l '.++$i);
}

