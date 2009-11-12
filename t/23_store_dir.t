use Test::More tests => 4;
require 't/env.pm';

use strict;
use Zim;

# This test is intended to test if calls to the store object
# end up correctly in the Dir object if we use a special class
# for the toplevel notebook dir.
#
# This test should make sure that e.g. Bazaar.pm will work

{
	# Empty package, see sub "curry" below
	package Zim::FS::MyVCS;
	our @ISA = qw/Zim::FS::Dir/;
}

# New repository
my $vcs = Zim::FS::MyVCS->new('t/notebook');
my $rep = Zim->new(
	dir => 't/notebook',
	vcs => $vcs,
);

# new page
my $page = $rep->get_page(':sdfsdfsdfsdf');
$page->delete if $page->exists;

# test "on_write_file"
curry(on_write_file => sub {
	my ($dir, $file, $new) = @_;
	if ($new) { is($file, $$page{source}, 'on_write called 1') }
	else      { fail('on_write called 1') }
});
$page->set_parse_tree(['Document', {}, ['head1', {}, 'FOO']]);

curry(on_write_file => sub {
	my ($dir, $file, $new) = @_;
	if (!$new) { is($file, $$page{source}, 'on_write called 2') }
	else       { fail('on_write called 2') }
});
$page->set_parse_tree(['Document', {}, ['head1', {}, 'FOOBAR']]);

my $new = $rep->get_page(':sfsdfsdfsdfggg');
$new->delete if $new->exists;

# test move_file
curry('move_file' => sub {
	my ($dir, $src, $dest) = @_;
	ok($src eq $$page{source} && $dest eq $$new{source}, 'move_file 1');
});
$page->move($new);

curry('move_file' => sub {
	my ($dir, $src, $dest) = @_;
	ok($src eq $$new{source} && $dest eq $$page{source}, 'move_file 2');
});
$rep->move_page($new, $page);

$page->delete if $page->exists;
$new->delete if $new->exists;

exit;

sub curry {
	# Add watcher to mock object
	my ($sub, $code) = @_;
	my $class = "Zim::FS::MyVCS";
	no warnings;
	no strict 'refs';
	*{"$class\::$sub"} = sub {
		delete ${"$class\::"}{$sub};  # remove hook again at run
		$code->(@_);                  # call hook
		&{"Zim::FS::Dir::$sub"}(@_);  # call SUPER
	};
}

