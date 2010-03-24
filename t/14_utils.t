use Test::More tests => 20;
require 't/env.pm';

use strict;
use Zim::Utils;

my $i = 0;
for (
	["24/12/2007", 2007,12,24],
	["2007 12 24", 2007,12,24],
	["2007_12_24", 2007,12,24],
	["24.12.2007", 2007,12,24],
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
	["24.12.2007", 0,0,0, 24,11,107],	
	[$t, localtime($t)],
) {
	my ($fmt, @date) = @$_;
	my @result = Zim::Utils::parse_date_l($fmt);
	#warn "$fmt => ", join ' ', map ">>$_<<", @result;
	is_deeply(\@result, \@date, 'parse_date_l '.++$i);
}

for (
	['2007-12-24', 2007,12,24 ],
	['',           0,   0, 0  ], 
	['2007-07-30', 2007,7 ,30 ],
) {
	my ($iso, @date) = @$_;
	my $result = Zim::Utils::iso_date(@date);
	#warn join(' ', @date), " => >>$result<<";
	is($result, $iso, 'iso_date');
}

for (
	[1900, 0],
	[2000, 1], 
	[2001, 0],
	[2004, 1],
) {
	my ($year, $is_leapyear) = @$_;
	my $result = Zim::Utils::leapyear($year);
	is($result, $is_leapyear, 'leapyear');
}

for (
	[1, 2009,12,24 ],
	[0, 2009,11,31 ], 
	[1, 2008,02,29 ],
	[0, 2009,02,29 ],
) {
	my ($valid, @date) = @$_;
	my $result = Zim::Utils::date_is_valid(@date);
	is($result, $valid, 'date_is_valid');
}