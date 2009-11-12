use Test::More tests => 15;
use lib './t';
use env;

use strict;
use Zim::Page;
use Zim::Selection;

my %moved = ( # moved pages
	':in'		=> ':out',
	':foo:bar:old'	=> ':foo:bar:new',
	':aa' 		=> ':bb',
);
my @pages = (':foo:aa', values %moved); # pages in notebook

my $selection = Zim::Selection->new(undef, {}, @pages);
my $p = Zim::Page->new($selection, ':foo:bar:baz');

## Test base stuff
is($p->name(), ':foo:bar:baz', 'name()');
is($p->namespace(), ':foo:bar:', 'namespace()');
is($p->basename(), 'baz', 'basename()');
is_deeply([$p->namespaces], ['foo', 'bar'], 'namespaces()');

## Test resolve_name when using Selection
#warn "Pages in selection: @{$r->{list}}\n";
for (
	['dus' => ':foo:bar:dus'],
	[':out' => ':out'],
	['out' => ':out'],
	['bar:test' => ':foo:bar:test'],
	['foo:test:aa' => ':foo:test:aa'],
) {
	my $name = $p->resolve_name($$_[0]);
	is($name, $$_[1], "Selection resolved $$_[0] => $$_[1]");
}

## Test updating links
for (
	# [link => updated]
	[':in' => 'out'],
	['in' => 'out'],
	['bar:old' => 'new'],
	['old' => 'new'],
	['aa' => 'aa'], # should resolve to :foo:aa not :aa
) {
	my ($old, $new) = @$_;
	$p->properties->{read_only} = 0;
	$p->set_parse_tree(['Page', {}, ['link', {to => $old}, $old]]);
	$p->update_links(%moved);
	is_deeply(
		$p->get_parse_tree(),
		['Page', {}, ['link', {to => $new}, $new], "\n"],
       		"update link $old => $new" );
}

## Test update links in the page that moved
{
	my @links = ( # links in moved page
		['dus' => 'foo:bar:dus'],
		[':in' => 'in'],
		['bar:test' => 'foo:bar:test'],
		['foo:test:aa' => 'test:aa'],
	);

	my $old_tree = ['Page', {},
		map ['link', {to => $$_[0]}, $$_[0]], @links ];
	my $new_tree = ['Page', {},
		map ['link', {to => $$_[1]}, $$_[1]], @links ];
	push @$new_tree, "\n";
	$p->set_parse_tree($old_tree);
	$p->name(':foo:test'); # "move" to new name
	$p->update_links_self(':foo:bar:test'); # old name
	is_deeply($p->get_parse_tree, $new_tree, 'update_links_self');
}
