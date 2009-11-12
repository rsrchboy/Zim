use Test::More tests => 3;
require 't/env.pm';

use strict;
use Zim::GUI;
use Zim::Utils;

file('t/share/zim/plugins/Test.pl')->write(<<'EOT');
my $app = Zim::GUI->current;

$app->signal_connect('NewPage', sub {return 'b4r!'});

return 1;

sub Foo { return 'f00!' }

EOT

my $gui = Mock::Object->new(
	ISA => 'Zim::GUI',
	on_NewPage => sub{ Zim::GUI::on_NewPage(@_) }, # force autoload
);
$gui->plug('Test');

ok($$gui{plugins}{Test}, 'plugin loaded');

is($gui->Foo, 'f00!', 'plugin can define method');

is($gui->on_NewPage, 'b4r!', 'plugin can overload action');

