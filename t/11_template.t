use strict;
require 't/env.pm';

use Zim::Template;

my $tests = 18;
my @templates;
open MAN, 'MANIFEST' or die $!;
while (<MAN>) {
	next unless m!/templates/!;
	chomp;
	push @templates, $_;
}
close MAN;
$tests += scalar @templates;

eval "use Test::More tests => $tests";
die $@ if $@;

is_deeply(
	Zim::Template::_parse_args(
		q{"foo", 'bar', "foo'bar", "f,b", "\n"} ),
	['foo', 'bar', 'foo\'bar', 'f,b', "\n"],
	'_parse_args works' );

my $data = {
	foo => 'bar',
	dus => 'ja',
	list => [qw/a b c/],
	empty => [],
	hash => {
		bar => 'baz',
	},
	code => sub { return 'test 123' },
	code_list => sub {return [qw/test 1 2 3/] },
	true => 1,
	false => 0,
};

my $i = 1;
for (
	['foo [% foo %] baz' => 'foo bar baz'], # simple GET
	['foo [% hash.bar %] biz' => 'foo baz biz'], # GET hash key
	['foo [% foo %] baz [% GET dus %] dus' => 'foo bar baz ja dus'], # double GET
	["foo [% foo %] baz\nhmm ?\n[% dus %] dus\n",
	 "foo bar baz\nhmm ?\nja dus\n"], # multiline GET
	['foo [% code %] baz' => 'foo test 123 baz'], # Code ref
	["foo [% IF true %][% foo %][% END %] - [% IF false %][% hash.bar %][% END %]\n",
	 "foo bar - \n"], # IF .. ELSE .. construct
	["foo [% IF empty %]bar[% ELSE %]baz[% END %] dus",
	 "foo baz dus"], # idem with other boolean type
	["foo\n\t[% IF empty %]\nbar\n\t[% ELSE %]\nbaz\n\t[% END %]\ndus",
	 "foo\nbaz\ndus"], # block IF .. ELSE  - removal of whitespace
	["foo [% FOREACH  item = list %]++[% item %] [% END %]bar",
	 "foo ++a ++b ++c bar"], # FOREACH construct
	["foo [% FOREACH  item = list %]\n++[% item %]\n[% END %]bar",
	 "foo \n++a\n\n++b\n\n++c\nbar"], # FOREACH on multiple lines
	["foo [% FOREACH  item = code_list %]++[% item %] [% END %]bar",
	 "foo ++test ++1 ++2 ++3 bar"], # FOREACH from code ref
	["foo [% IF true %][% FOREACH  item = code_list %]++[% item %] [% END %]bar [% ELSE %] duss [% END %]- ja",
	 "foo ++test ++1 ++2 ++3 bar - ja"], # FOREACH nested in IF .. ELSE
) {
	my ($template, $expected) = @$_;
	my $output = '';
	my $t = Zim::Template->new(\$template);
	$t->process($data => \$output);
	is($output, $expected, 'template '.$i++);
}

# test re-use
my $t = Zim::Template->new(\"foo [% i %] bar");
for my $i (1 .. 3) {
	my $output = '';
	$t->process( {i => $i} => \$output ); 
	is($output, "foo $i bar", "template re-use $i");
}

# SET construct
$t = Zim::Template->new(\"foo [% SET dus = ja %] bar");
$data = {};
my $output = '';
$t->process( $data => \$output );
is($output, "foo  bar", "set var 1");
is_deeply($data, {dus => 'ja'}, "set var 2");

## Test if all templates in the package are valid
for (@templates) {
	eval { Zim::Template->new($_) };
	warn $@ if $@;
	ok($@ ? 0 : 1, $_);
}

