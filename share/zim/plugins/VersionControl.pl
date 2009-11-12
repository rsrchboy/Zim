use strict;
use File::BaseDir qw/data_files/;

# This plugin mimics part of the plugin loading code in
# Zim::GUI->plug() in order to load a sub-script for a specific VCS

my $app = Zim::GUI->current;
my $vcs = $$app{notebook}{vcs};
return 1 unless $vcs;

$vcs = ref $vcs;
$vcs =~ s/.*:://;
my $file = data_files('zim', 'plugins', 'VersionControl', $vcs.'.pl');
return 1 unless $file;

warn "# Loading plugin VersionControl/$vcs\n";
warn "## from $file\n";
my $return = do $file;
$app->error_dialog(
	__("Failed to load plugin: {name}", name => "VersionControl/$vcs"), #. error
	$@ || $! )
	if $@ or ! defined $return;

1;

