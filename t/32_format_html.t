use Test::More tests => 1;
require 't/env.pm';

use strict;
use Zim::Formats::Html;

my $list = << 'EOT';
* foo
* bar
	* baz
		* A
		* B
	* dus
	* Ja
* Foo
EOT
$list =~ s/\*/\x{2022}/g;

my $html = << 'EOT';
<p>
<ul>
<li>foo</li>
<li>bar</li>
<ul>
<li>baz</li>
<ul>
<li>A</li>
<li>B</li>
</ul>
<li>dus</li>
<li>Ja</li>
</ul>
<li>Foo</li>
</ul>

</p>
EOT

is(dump_node(['Para', {}, $list]), $html, 'List are parsed correctly');

sub dump_node {
	# FIXME: We use _dump_node to circumvent template logic this 
	# should be fixed when tempalte logic moves to parent class.
	my $node = shift;
	my $html = '';
	open OUT, '>', \$html or die $!;
	my $stdout = select OUT;
	eval { Zim::Formats::Html->_dump_node($node) };
	select $stdout;
	close OUT;
	warn $@ if $@;
	return $html;
}
