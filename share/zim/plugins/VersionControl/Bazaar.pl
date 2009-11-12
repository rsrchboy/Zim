use strict;

my $app = Zim::GUI->current;
my $dir = $$app{notebook}{vcs};

# Check if bzr is installed and check if we have the gtk plugin
my $plugins = $dir->bzr('plugins');
my $has_gtk_plugin = ( $plugins =~ /^gtk\b/m );
warn "## bzr has gtk plugin - ".($has_gtk_plugin ? 'Yes' : 'No')."\n";

# TODO menu items in the Tools menu for push, pull etc.

return 1 unless $has_gtk_plugin;

# Bootstrap overloaded VersionsDialog
$$app{autoload}{VersionsDialog} = 'Zim::GUI::VersionsDialog::Bazaar';

$INC{'Zim/GUI/VersionsDialog/Bazaar.pm'} = 1;
	# fake loading this module for require to be happy




package Zim::GUI::VersionsDialog::Bazaar;

use strict;
use vars '$AUTOLOAD';
our @ISA = qw/Zim::GUI::VersionsDialog/;

sub new {
	# called by autoload - load parent class and initialize
	my $class = shift;
	eval 'require Zim::GUI::VersionsDialog';
	die $@ if $@;
	my $self = $class->SUPER::new(@_);
	bless $self, $class;
}

sub gdiff {
	my ($self, $page, $path, $v1, $v2) = @_;
	my $dir = $$self{app}{notebook}{vcs};

	# We assume $dir to be of class Zim::FS::Bazaar
	my @arg = $dir->bzr_rev_arg($v1, $v2);
	chdir $$dir{bzr_root};
	Zim::Utils->run('bzr', 'gdiff', @arg, $path);
	chdir $ENV{PWD};

	return 1;
}

sub gannotate {
	my ($self, $page, $path, $v) = @_;
	my $dir = $$self{app}{notebook}{vcs};

	# We assume $dir to be of class Zim::FS::Bazaar
	my @arg = $dir->bzr_rev_arg($v);
	chdir $$dir{bzr_root};
	Zim::Utils->run('bzr', 'gannotate', @arg, $path);
	chdir $ENV{PWD};

	return 1;
}

1;
