use strict;

my $app = Zim::GUI->current();

eval 'use Zim::GUI::Spell';
if ($@) {
	$app->error_dialog(
		"Failed to load Spell plugin,\n".
		"do you have Gtk2::Spell installed ?", $@);
	$app->unplug('Spell');
}

$app->Spell; # load object - HACK - more (all?) code from module should be here

return 1;
