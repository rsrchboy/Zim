#!/usr/bin/perl

use Module::Build;

# Define our custom build actions
my $class = Module::Build->subclass(
	class => 'My::Builder',
	code => << 'EOC'

use strict;
use File::Copy ();
use File::Path;

$ENV{PERL5LIB} ||= ''; # get rid of some warnings...

__PACKAGE__->add_property(data_files => {});

sub check_prereq {
	my $self = shift;

	eval 'use Gtk2';
	my $gtk_ok = ! $@;

	if ($gtk_ok and Gtk2->CHECK_VERSION(2, 10, 0)) {
		my $recommends = $self->recommends;
		delete $recommends->{'Gtk2::TrayIcon'};
	}

	my $prereq_ok = $self->SUPER::check_prereq(@_);
	
	if (! $gtk_ok) {
		$self->log_warn(" * ERROR: Could not load perl module Gtk2\n");
		$self->log_warn(<<EOF) if $prereq_ok;

ERRORS/WARNINGS FOUND IN PREREQUISITES.  You may wish to install the versions
of the modules indicated above before proceeding with this installation

EOF
	}
	elsif (! Gtk2->CHECK_VERSION(2, 4, 0)) {
		my $version = join '.', Gtk2->GET_VERSION_INFO;
		$self->log_warn(<<"EOF");

 * ERROR: gtk+ version $version is installed, but we need >= 2.4.0
   If you think you have the right version of gtk+ installed, try
   recompiling the Gtk2 perl package.

EOF
	}

	return $prereq_ok && $gtk_ok;
}

sub install_types {
	my $self = shift;
	my @types = $self->SUPER::install_types;
	push @types, keys %{$$self{properties}{data_files}};
	return sort @types;
}

sub install_destination {
	my ($self, $type) = @_;
	return $self->SUPER::install_destination($type)
		unless exists $$self{properties}{data_files}{$type};

	return $self->install_path($type) if $self->install_path($type);

	my $relpath = $$self{properties}{data_files}{$type};

	return File::Spec->catdir($self->install_base, $relpath)
		if $self->install_base;

	return File::Spec->catdir($self->prefix, $relpath)
		if $self->prefix;
	
	# Fall back to heuristic determination of prefix based on
	# the 'bin' directory.
	my $bindir = $self->install_sets($self->installdirs)->{'bin'};
	my @prefix = File::Spec->splitdir($bindir);
	pop @prefix; # loose 'bin'
	return File::Spec->catdir(@prefix, $relpath);
}

sub process_share_files {
	my $self = shift;
	my $blib = $self->blib;

	# Copy but exclude dev documentation
	for (@{$self->rscan_dir('share')}) {
		next if /(^|[\/\\])\.|Development/ or -d $_;
		$self->copy_if_modified(
			from => $_,
			to   => File::Spec->catfile($blib, $_) );
	}
	
	# Add changelog
	my $dir = File::Spec->catdir($blib, qw/share zim doc/);
	$self->copy_if_modified(
		from => 'Changes',
		to   => File::Spec->catfile($dir, 'changelog.txt'));

	# Set correct config for manual
	my $conf = File::Spec->catfile($dir, 'notebook.zim');
	open CONF, '<', $conf or die $!;
	my $text = join '', <CONF>;
	close CONF;
	
	if ($text =~ s/^#(?!\s)//mg) { # un-escape some lines
		my $mode = (stat $conf)[2];
		chmod($mode | oct(222), $conf) or die $!;
		print "Making the manual a read-only notebook\n";
		open CONF, '>', $conf or die $!;
		print CONF $text;
		close CONF;
		chmod($mode, $conf);
	}
}

sub ACTION_install {
	my $self = shift;
	$self->SUPER::ACTION_install(@_);
	$self->depends_on('postinstall');
}


sub ACTION_test {
	my $self = shift;

	# Multiple tests depend on data from the MANIFEST, so it needs to 
	# be correct. However only do this in dev tree when we can actually
	# rebuild the manifest.
	if (-e 'MANIFEST.SKIP') {
		my $error = 0;
		local $SIG{__WARN__} = sub {$error++; warn @_};
		$self->depends_on('distcheck');
		die "Please update the MANIFEST before testing\n" if $error;
	}

	$self->depends_on('test_data');
	$self->SUPER::ACTION_test(@_);
}

sub ACTION_test_data {
	my $self = shift;

	for (qw#t/html t/notebook t/config t/share t/cache#) {
		next unless -e $_;
		$self->delete_filetree($_);
	}

	print "Extracting test notebook\n";

	open IN, 't/notebook.txt' or die "t/notebook.txt: $!";
	binmode IN, ':utf8' if not $] < 5.008;

	my ($file, $fh);
	while (<IN>) {
		if (/^%%\s+(\S+)\s+%%$/) {
			close $fh if $fh;
			$file = $1;
			mkpath $1 if $file =~ m#(.*/)#;
			open $fh, ">$file" or die "$file: $!\n";
			binmode $fh, ':utf8' if not $] < 5.008;
		}
		elsif ($fh) {
			print $fh $_;
		}
		else { die "oops" }
	}
	close $fh if $fh;
}

#sub ACTION_distmeta {
	#my $self = shift;
	#$self->depends_on('messages');
	#$self->run_perl_script('Lingua.PL') or return;
	#$self->run_perl_script('Config.PL') or return;
	#$self->SUPER::ACTION_distmeta(@_);
#}

sub ACTION_disttest {
	my $self = shift;
	$self->SUPER::ACTION_disttest(@_);

	# Check how clean we build
	my $start_dir = $self->cwd;
	my $dist_dir = $self->dist_dir;
	chdir $dist_dir or die "Cannot chdir to $dist_dir: $!";
	$self->run_perl_script('Build', [], ['realclean']);
	chdir $start_dir;

	my %manifest;
	open MANIFEST, 'MANIFEST' or die "Cannot open MANIFEST: $!";
	while (<MANIFEST>) {
		chomp;
		s/\s.*//;
		$manifest{$_}++;
	}
	close MANIFEST;
	my @dirt;
	my @files = grep {-f $_} @{$self->rscan_dir($dist_dir)};
	for (@files) {
		s/^$dist_dir[\/\\]//;
		push @dirt, $_ unless $manifest{$_};
	}
	die "ERROR: The following files where not cleaned up properly:\n",
		map "\t$_\n", @dirt
		if @dirt;
	print "Cleanup OK\n";
}

sub ACTION_realclean {
	my $self = shift;
	$self->SUPER::ACTION_realclean(@_);
	my @files = grep /(\~|\.bak)$/, @{$self->rscan_dir('.')};
	return unless @files;
	warn "Also cleaning up:\n", map "\t$_\n", @files;
	unlink $_ or die $! for @files;
}

=head1 ACTIONS

=over 4

=item C<postinstall>

Runs commands to update the XDG databases.

=cut

sub ACTION_postinstall {
	my $self = shift;
	my $sharedir = $self->install_destination('share');
	my $mimedir = File::Spec->catdir($sharedir, 'mime');
	my $icon = File::Spec->catfile($sharedir, 'pixmaps', 'zim.png');
	for (
		['update-desktop-database'],
		['update-mime-database', $mimedir],
	#	[qw{xdg-icon-resource install --context apps --size 64},
	#		$icon],
		[qw{xdg-icon-resource install --context mimetypes --size 64},
			$icon, q{application-x-zim-notebook}],
	) {
		print "Trying: @$_\n";
		print system(@$_) == 0 ? "Ok\n\n" : "Failed\n\n" ;
	}

}

=item C<messages>

Generates a new F<zim.pot> file. Only works from development tree,
not from dist.

=cut

sub ACTION_messages {
	my $self = shift;
	die "This is not a development tree, can not build messages.\n"
		unless -d './dev';
	$self->do_system($self->perl, './dev/xgettext.pl');
}

=item C<static>

Builds a self-contained excutable for zim. Needs the L<PAR> and
L<ExtUtils::PkgConfig> modules.

=back

=cut

sub ACTION_static {
	my $self = shift;
	warn "## WARNING: Static building is experimental - feedback is welcome\n";
	warn "## You need to have zim installed before running this command\n";
	warn "## You can pass extra options to 'pp' using PP_OPTS\n";
	eval 'use ExtUtils::PkgConfig';
	die $@ if $@;
	sleep 5;
	$self->depends_on('build');
	my @libs = map {s/^-l//i; ('-l', $_)} grep {length $_} split /\s+/,
		ExtUtils::PkgConfig->libs('gtk+-2.0');
	my @add = ('-a', 'share');
	open MANIFEST, '<MANIFEST' or die "Could not read MANIFEST";
	my @modules;
	for (<MANIFEST>) { # grep modules from the manifest
		/^lib\/(\S+?)\.pm/ or next;
		my $mod = $1;
		$mod =~ s/\//::/g;
		push @modules, '-M', $mod;
	}
	close MANIFEST;
	my $script = File::Spec->catfile(qw/script zim/);
	my $blib = File::Spec->catdir($ENV{PWD}, $self->blib);
	my $libdir = File::Spec->catdir($blib, 'lib');
	print ">> cd $blib\n";
	chdir $blib or die "Could not open dir $blib\n";
	$ENV{PWD} = $blib;
	print ">> pp -I $libdir -o zim @libs @add @modules $script\n";
	system qw{pp -o ../zim}, @libs, @add, @modules, $script;
	warn "\n## Your executable is ready\n";
}

#=item C<testflow>
#
#Run test suite and record which method calls which other methods.
#
#=cut

sub ACTION_testflow {
	# TODO: Move "tmon.out" after each test, now it gets overwritten
	# TODO: wrap script around "dprofpp -T" to make summaries or graphs
	my $self = shift;

#	$self->add_to_cleanup('flow_db');
	$self->depends_on('code');

	local $Test::Harness::switches    =
	local $Test::Harness::switches    =
	local $ENV{HARNESS_PERL_SWITCHES} = '-d:DProf';

	$self->depends_on('test');
#	$self->do_system('./dev/flow.pl');
}

EOC
);

# Define the build parameters
my $build = $class->new(
	dist_name => 'Zim',
	dist_version_from => 'lib/Zim.pm',
	dist_abstract => 'A desktop wiki',
	dist_author => 'Jaap Karssenberg <pardus@cpan.org>',
	license => 'perl',
	script_files => ['bin/zim'],
	data_files => { share => 'share' },
	requires => {
		'perl'           => '5.8.0',
		'Gtk2'           => '1.040',
		# Older doesn't support Gtk2::UIManager I think
		'POSIX'          => 0,
		'IO::File'       => 0,
		'File::Spec'     => 0,
		'File::Copy'     => 0,
		'File::BaseDir'  => 0.03,
		'File::MimeInfo' => '0.12',
		'File::DesktopEntry' => 0.03,
		'Encode'         => 0,
	},
	recommends => {
		'Gtk2::TrayIcon' => 0,
			# This recommendation is removed on the
			# fly when gtk+ >= 2.10 is detected because
			# in that case we can use Gtk2::StatusIcon
		'Gtk2::Spell'    => 0,
	},
	build_requires => {
		'Module::Build'  => '0.28',
		'Test::More'     => 0,
		'File::Path'     => 0,
	},
	add_to_cleanup => [
		'./cover_db/',	# from Build testcover
		'./tmon.out',	# from dprof
		'./tmp',
		# Used by tests:
		't/notebook/',
		't/html/',
		't/config/',
		't/share/',
		't/cache/',
	],
	create_makefile_pl => 'passthrough',
	dynamic_config => 1,
);

# Add share dir as something to be build
$build->add_build_element('share');

# And finally create the script "./Build"
$build->create_build_script;

