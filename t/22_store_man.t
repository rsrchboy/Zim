use Test::More;
require 't/env.pm';

use strict;
use File::Spec;
use Zim::Store::Man;
use Zim;

my $rep = Zim::Store::Man->new();
plan $rep->{has_man}
	? (tests => 5)
	: (skip_all => "No man page support") ;

ok(@{$$rep{path}}, 'Found MANPATH');

sub check_man {
	my $cmd  = shift;
	return `man -w $cmd`;
}

SKIP: {
	skip('`man ls` not available', 1) unless check_man('ls');
	print "\n## 1 - resolve_name man => :1:man\n";
	my $name = $rep->resolve_name('man');
	is($name, ':1:man', 'resolve_name');
}

SKIP: {
	skip('`man man` not available', 1) unless check_man('man');
	my $page = $rep->get_page(':1:man');
	my $tree = $page->get_parse_tree();
	ok(@$tree > 3, "Page not empty");
}

SKIP: {
	skip('`man Module::Build` not available', 2)
		unless check_man('Module::Build');
	print "\n## 3 - resolve_name Module::Build => :3:Module::Build\n";
	my $name = $rep->resolve_name('Module::Build');
	is($name, ':3:Module::Build', 'resolve_name');

	my $page = $rep->get_page(':3:Module:Build');
	my $tree = $page->get_parse_tree();
	ok(@$tree > 3, "Page not empty");
}
