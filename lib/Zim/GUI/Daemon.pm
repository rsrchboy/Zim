package Zim::GUI::Daemon;

use strict;
use POSIX qw/:sys_wait_h setsid/;
	# first import symbol needs to be group else Exporter
	# does no special processing. Bug with Exporter <= 5.57
use Config;
use IO::Socket ();
use File::Spec;
use Zim;

our $VERSION = '0.27';

=head1 NAME

Zim::GUI::Daemon - IPC module for the zim GUI

=head1 SYNOPSIS

	# Daemon process
	Zim::GUI::Daemon->daemonize( sub { ... } );
	exit;

	# Client process
	Zim::GUI::Daemon->do('open', $notebook, $page);

=head1 DESCRIPTION

This module contains all the IPC code to make various processes work together.
The idea is to have one process without a interface running as a daemon. This
daemon listens to a UNIX domain socket for commands. This daemon spawns clients
to open multiple notebooks. The daemon keeps filhandlers to the STDIN of each
client to communicate with them.

This module is not object oriented because we only use a single instance
of the daemon per process anyway.

=head1 METHODS

=over 4

=cut

our $File = File::Spec->catfile(
	File::Spec->tmpdir, "zim-$ENV{USER}-gui-daemon" );
# name like Zim::FS->tmp_file, but without the PID

our $Loop = 0;
our $Background = 1;

our $Socket;	# Socket object
our %Proc;	# PID to FH mapping
our %Names;	# maps KEY to [PID, NAME]
		# where KEY is a unique name: a path or a special like '_new_'
		# and NAME is a short alias that is not unique
our $Code;	# CODE callback for ACTION_open

our $USR1;

BEGIN: {
	my @sig = split /\s+/, $Config{sig_name};
	($USR1) = grep {$sig[$_] eq 'USR1'} 0 .. $#sig;
}

=item C<exists()>

Returns boolean to check if we have a daemon or not.

=cut

sub exists {
	eval {
		my $server = IO::Socket::UNIX->new(Peer => $File);
		$server->close;
	};
	return $@ ? 0 : 1 ;
}

=item C<do(CMD, @ARGS)>

Method for the clients to pass a single command to the daemon.
Arguments should be scalar and will be passed to the command routine.

Wrap this within method an C<eval { }> block because it will die if no
daemon is listening.

=cut

sub do {
	my ($class, @args) = @_;

	my $server = IO::Socket::UNIX->new(Peer => $File);
	die "Could not connect to daemon: $!\n" unless $server;
	
	binmode $server, ':utf8';
	print $server "pid $$\n";
	print $server join_line(@args), "\n";
	$server->close;
}

=item C<list()>

Method for clients to request a list of notebooks.
Assumes that STDIN is flushed.

=cut

sub list {
	my $class = shift;
	$class->do('list');
	return () unless <STDIN> eq "notebooks:\n";
	my @list;
	binmode STDIN, ':utf8';
	while (<STDIN>) {
		last if $_ eq "...\n";
		my ($name, $path) = split_line($_);
		push @list, [$name => $path] unless $path =~ /^_.*_$/;
	}
	return @list;
}

=item C<daemonize(CODE)>

Unless C<$Zim::DEBUG> is set this dissociates the current process from its
parent process (like your shell). Then it opens the daemon socket.

CODE is the callback that is called when a new client is opened in the child 
process. It should get the notebook and the page as arguments when called.

=cut

sub daemonize {
	my ($class, $code) = @_;
	$Code = $code if $code;

	# Dissociate from parent (see perlipc)
	unless ($Zim::DEBUG) {
		chdir '/' or die "Can't chdir to '/': $!\n";
		
		my $null = Zim::FS->devnull;
		open STDIN, $null or die "Can't read $null: $!\n";
		open STDOUT, '>', $null or die "Can't write $null: $!\n";
		# leave STDERR as is, verbose messages are filtered anyway

		my $pid = fork;
		die "Can't fork: $!\n" unless defined $pid;
		exit if $pid; # exit original process
		setsid or die "Can't start a new session\n";
			# put us in our own process group to break control
	}
	# else keep terminal control over the process

	# Open socket
	unlink $File;
	$Socket = IO::Socket::UNIX->new(
		Local => $File,
		Listen => 10, # queue of 10 seems enough for single user
	);
	die "Could not setup daemon: $!" unless $Socket;
}

=item C<main()>

Called after C<daemonize()> to wait for input.
Does not return untill a client calls the command "quit".

=cut

sub main {
	my $class = shift;

	$SIG{CHLD} = \&REAPER;
	warn "## Daemon: Listening at PID $$\n";

	# Loop for input
	$Loop = 1;
	while ($Loop) {
		my $client = $Socket->accept(); # Blocking
		unless ($client) { # error or interrupt
			next if $!{EINTR}; # interupted by signal, e.g. CHLD
			warn "ERROR: Daemon: accept: $!\n";
			last;
		}

		my $pid;
		$client->autoflush(1);
		binmode $client, ':utf8';
		while (<$client>) {
			chomp;
			if (/^pid\s+(\d+)/) { # special case
				$pid = $1;
				next;
			}
			warn "## Daemon: PID $pid says: $_\n";
			s/^(\w+)\s*// or next;
			my $sub = "ACTION_$1";
			$class->can($sub)
				? $class->$sub($pid, split_line($_))
				: warn "BUG: Daemon: unknown command: $1\n" ;
		}
		$client->close;
	}

	warn "## Daemon: Exiting\n";
	$Socket->close;
	delete $SIG{CHLD};

	# In theory all child processes closed already and send a SIGCHLD
	# before we get here. Do not close filehandles here, doing so will 
	# kill child processes forcibly. Wait to besure all procs ended.
	wait;
}

sub REAPER {
	# Connected to SIGCHLD to clean up exiting children
	# without this function we leave zombie processes.
	my $pid;
	my $stat = $!; # save EINTR
	while (($pid = waitpid(-1, WNOHANG)) > 0) {
		warn "## Daemon: Client with PID $pid exited\n";
		delete $Proc{$pid};
		delete $Names{$_}
			for grep {$Names{$_}[0] == $pid}
			    keys %Names ;
	}
	warn "## Daemon: Last client exited\n" unless %Proc;
	$Loop = 0 unless %Proc or $Background;
		# Stop main loop if last child exits unless background was set.
	$SIG{CHLD} = \&REAPER; # not sure why this is needed
	$! = $stat;
}

=back

=head2 Commands

All commands have method that starts with "ACTION_". These are the routines
that clients are allowed to call, so they are our public interface.

The daemon calls these with the PID of the client followed by any arguments
passed by the client. To call these remotely use C<do()> and provide the
arguments after PID for each function.

=over 4

=item C<ACTION_open(PID, NOTEBOOK, PAGE, @ARGS)>

If there is a child process open for NOTEBOOK it is called to open PAGE.
Else a new child is spawn to open NOTEBOOK and PAGE.

NOTEBOOK and PAGE are both optional, PID is the PID of the calling client,
not of the child handling NOTEBOOK. If NOTEBOOK is undefined a new child is
spawn that could for example show the notebook dialog.

=cut

sub ACTION_open {
	my ($class, undef, $notebook, $page, @args) = @_;
	$notebook = _notebook($notebook);

	if (exists $Names{$notebook}) {
		my $pid = $Names{$notebook}[0];
		print {$Proc{$pid}} join_line('JumpTo', $page), "\n"
			if length $page;
		print {$Proc{$pid}} join_line('ShowWindow', @args), "\n"
			if @args;
		kill $USR1 => $pid;
	}
	else {
		my $pid = _fork($Code, $notebook, $page, @args);
		$Names{$notebook} = [$pid];
	}
}

sub _notebook {
	# Lookup directory if possible, but do not check existence
	# and pass on notebook name if we can not resolve it.
	# Make sure that we get the same unique path no matter how
	# the notebook in question is called.
	my $name = shift;
	my $dir = ($name =~ m#[/\\]#) ? $name : Zim->get_notebook($name) ;
	return $name unless defined $dir;
	$dir =~ s/[\/\\]*$//;
		# abs_path preserves a trailing '/',
		# so this can harm uniqueness
	return Zim::FS->abs_path($dir, $ENV{HOME});
}

sub _fork {
	my ($code, @args) = @_;
	my ($read_fh, $write_fh) = _open_pipe();
	$SIG{USR1} = sub { }; # Don't die - set here for child to avoid race
	if (my $pid = fork) {
		# Daemon process
		warn "## Daemon: Forked client with PID $pid\n";
		close $read_fh;
		$Proc{$pid} = $write_fh;
		return $pid;
	}
	else {
		# Client process
		close $write_fh;
		open STDIN, '<&'.fileno($read_fh)
			or die "ERROR: Could not dup fh to STDIN\n";
		delete $SIG{CHLD}; # no reaping in child process
		$code->(@args);
		exit;
	}
	delete $SIG{USR1};
}

sub _open_pipe {
	my ($r, $w);
	pipe $r => $w;
	my $fh = select $w;
	$| = 1;
	select $fh;
	binmode $r, ':utf8';
	binmode $w, ':utf8';
	return $r, $w;
}

=item C<ACTION_run(PID, NAME, CLASS, @ARGS)>

If there is no child with NAME run one using C<CLASS->run(@ARGS)>.
Can be used by plugins to run a special process.

=cut

sub ACTION_run {
	my ($class, undef, $name, $module, @args) = @_;
	return if exists $Names{$name};
	
	my $code = sub {
		eval "use $module\n";
		die $@ if $@;
		$module->run(@args);
	};

	my $pid = _fork($code, @args);
	$Names{$name} = [$pid];
}

=item C<ACTION_register(PID, NAME)>

Allows the child process to tell it's short name to the daemon.
THis name does not need to be unique.

=cut

sub ACTION_register {
	my ($class, $pid, $name) = @_;
	my ($key) = grep {$Names{$_}[0] == $pid} keys %Names;
	$Names{$key}[1] = $name;
}

=item C<ACTION_list(PID)>

Will print a list of open notebooks to STDIN of PID.
Or to STDOUT if PID is not a child process.

=cut

sub ACTION_list {
	my ($class, $pid) = @_;
	my $fh = exists($Proc{$pid}) ? $Proc{$pid} : *STDOUT;
	my @list = map [$Names{$_}[1] || $_, $_], keys %Names; # [NAME => KEY]
	@list = sort {$$a[0] cmp $$b[0]} @list; # sort by name
	binmode $fh, ':utf8'; # just in case it is STDOUT
	print $fh "notebooks:\n";
	print $fh join_line(@$_), "\n" for @list;
	print $fh "...\n";
}

=item C<ACTION_tell(PID, TO, @ARGS)>

Pass @ARGS to a child process. TO can be either a PID or a NOTEBOOK.
Used for testing or to interact directly with other process instances.

=cut

sub ACTION_tell {
	my ($class, undef, $name, @args) = @_;
	my $pid = _pid($name) or return;
	print {$Proc{$pid}} join_line(@args), "\n";
}

sub _pid {
	# Check if the input is a notebook and if so return is PID
	# else assume input to be a PID and check if we know it.
	my $name = _notebook( shift );
	my $pid = exists($Names{$name}) ? $Names{$name}[0] : $name;
	unless (exists $Proc{$pid}) {
		warn "WARNING: Daemon: Could not find client: $name\n";
		return undef;
	}
	return $pid;
}

=item C<ACTION_broadcast(PID, @ARGS)>

Send ARGS to all processes except the one that is broadcasting.

=cut

sub ACTION_broadcast {
	my ($class, $pid, @args) = @_;
	my $string = join_line(@args)."\n";
	for (grep {$_ ne $pid} keys %Proc) {
		my $fh = $Proc{$_};
		print $fh $string;
	}
}

=item C<ACTION_quit(PID)>

Quit the daemon if all children have exited.
To quit all children try something like C<broadcast Close FORCE>.

=cut

sub ACTION_quit {
	$Background = 0;
	$Loop = 0 unless %Proc;
}

=back

=head2 Other routines

=over 4

=item C<join_line(@STRING)>

Function that serializes list into a single string.

=item C<split_line(STRING)>

Function that splits line into list.

=cut

sub join_line {
	my @args = @_;
	# loose trailing undef and replace undef by "."
	while (@args and ! defined $args[-1]) { pop @args }
	for (@args) {
		if    (! defined $_) { $_ = '.'   }
		elsif ($_ eq '.'   ) { $_ = '\\.' }
	}
	join ' ', map {$a = $_; $a =~ s/(\s)/\\$1/g; $a} @args;
}

sub split_line {
	my $string = shift;
	my @args;
	while ($string =~ s/((\\.|\S)+)//) {
		push @args, $1;
	}
	return map {
		if   ($_ eq '.') { $_ = undef   }
		else             { s/\\(.)/$1/g }
		$_;
	} @args;
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2008 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

