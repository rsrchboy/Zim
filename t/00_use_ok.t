require Test::More;
require 't/env.pm';

my @classes;
my @skip = qw/
	Zim::Formats::Pod
	Zim::GUI::Daemon
	Zim::GUI::TrayIcon
	Zim::GUI::Spell
	Zim::OS::Win32
	Gtk2::Ex::DesktopEntryMenu
/;

open MAN, 'MANIFEST' or die "Could not open MANIFEST\n";
while (<MAN>) {
	chomp;
	next unless /^lib\/(.*?)\.pm\b/;
	my $c = $1;
	$c =~ s#/#::#g;
	push @classes, $c unless grep {$_ eq $c} @skip;
}
close MAN;

my $t = @skip + @classes;
Test::More->import(tests => $t);

for (sort @classes) {
	use_ok($_);
}

SKIP: {
	eval "use Pod::Simple";
	skip('No Pod:Simple available', 1) if $@;
	use_ok('Zim::Formats::Pod');
}

SKIP: {
	skip('No Daemon support for Win32', 1) if $^O eq 'MSWin32';
	use_ok('Zim::GUI::Daemon');
}

SKIP: {
	eval "Gtk2->CHECK_VERSION(2, 10, 0) or require Gtk2::TrayIcon";
	skip('Gtk+ verion < 2.10 and no Gtk2::TrayIcon available', 1) if $@;
	use_ok('Zim::GUI::TrayIcon');
};

SKIP: {
	eval "use Gtk2::Spell";
	skip('No Gtk2::Spell available', 1) if $@;
	use_ok('Zim::GUI::Spell');
};

SKIP: {
	skip("Win32 specific", 1) unless $^O eq 'MSWin32';
	use_ok('Zim::OS::Win32');
};

SKIP: {
	eval 'use File::MimeInfo::Applications';
	skip('No File::MimeInfo::Applications available', 1) if $@;
	use_ok('Gtk2::Ex::DesktopEntryMenu');
};

