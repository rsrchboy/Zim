# Can't use test builder because of different processes :(
use lib './t';
use env;

BEGIN {
	if ($^O eq 'MSWin32') {
		print "1..0 # Skip no Daemon support for Win32\n";
		exit;
	}
}

print "1..13\n";
our $I = 1;

use strict;
use Zim::GUI::Daemon;

$Zim::DEBUG = 1;
$Zim::GUI::Daemon::File = './t/cache/gui_daemon_socket';
	# Avoid conflict with running zim instance
mkdir './t/cache';

## Helper routines
is(
	Zim::GUI::Daemon::join_line('foo', 'b a r', undef, '.', 'baz', undef),
	"foo b\\ a\\ r . \\. baz",
	"join_line");
is(
	[Zim::GUI::Daemon::split_line(" foo b\\ a\\ r . \\. baz ")],
	['foo', 'b a r', undef, '.', 'baz'],
	"split_line");

## Client to Daemon communication
{
	$I = 3;
	my $parent = $$;
	eval { Zim::GUI::Daemon->do('tell', 'foo') };
	is($@?1:0, 1, 'do dies without server');

	if (my $pid = fork) {
		# Parent process
		print "# Sleeping 3 seconds\n";
		sleep 3;
		Zim::GUI::Daemon->do('check1', qw/foo bar/);
		Zim::GUI::Daemon->do('check2', 'foo bar');
		Zim::GUI::Daemon->do('exit');
	}
	else {
		# Child process
		$I = 4;
		Zim::GUI::Daemon::Test->daemonize;
		$Zim::GUI::Daemon::Test::parent = $parent;
		Zim::GUI::Daemon::Test->main;
		exit;
	}
	wait;
}

## Daemon to Client communication
{
	$I = 7;
	my ($read_fh, $write_fh) = open_pipe();
	if (my $pid = fork) {
		# Parent process
		close $read_fh;
		$Zim::GUI::Daemon::Background = 0;
			# quit loop after child exits
		Zim::GUI::Daemon->daemonize;
		$Zim::GUI::Daemon::Proc{$pid} = $write_fh;
		Zim::GUI::Daemon->main;
	}
	else {
		# Child process
		close $write_fh;
		print "# Sleeping 3 seconds\n";
		sleep 3;
		Zim::GUI::Daemon->do('tell', $$, qw/open foo bar/);
		my $l = <$read_fh>;
		is($l, "open foo bar\n", 'client read 1');
		Zim::GUI::Daemon->do('tell', $$, 'open', 'foo bar');
		$l = <$read_fh>;
		is($l, "open foo\\ bar\n", 'client read 2');
		exit;
	}
	wait;
}

## Test forking behavior
{
	$I = 9;
	my $parent = $$;
	my ($read_fh, $write_fh) = open_pipe();
	if (my $pid = fork) {
		# Parent process
		close $write_fh;
		print "# Sleeping 3 seconds\n";
		sleep 3;
		Zim::GUI::Daemon->do('open', 'test');
		Zim::GUI::Daemon->do('tell', 'test', $$, 'says hi!');
		my $l = <$read_fh>;
		is($l, "client got: 1: $$ says\\ hi!\n", 'open 1');
		Zim::GUI::Daemon->do('open', 'test', 'foo');
			# should not re-open but ping existing process
		$l = <$read_fh>;
		is($l, "client got: 2: JumpTo foo\n", 'open 2');
		$l = <$read_fh>;
		is($l, "got SIGUSR1 !\n", 'got SIGUSR1');
		open STDIN, '<&', $read_fh;
		my @list = Zim::GUI::Daemon->list;
		#use Data::Dumper; warn Dumper \@list;
		die unless @list == 2;
		is($list[0], ['bar', 'test'], 'list 1');
		is($list[1], ["parent\x{2022}", '/foo'], 'list 2');
		Zim::GUI::Daemon->do('broadcast', 'Close');
		Zim::GUI::Daemon->do('exit');
	}
	else {
		# Child process
		close $read_fh;
		Zim::GUI::Daemon::Test->daemonize(
			sub {
				# Child of child process
				$SIG{USR1} = sub {
					print $write_fh "got SIGUSR1 !\n";
				};
				Zim::GUI::Daemon->do('register', 'bar');
				my $l = 1;
				while (<STDIN>) {
					last if /^Close/;
					print $write_fh "client got: $l: $_";
					$l++;
				}
			}
		);
		$Zim::GUI::Daemon::Proc{$parent} = $write_fh;
		$Zim::GUI::Daemon::Names{'/foo'} = [$parent, "parent\x{2022}"];
			# including utf8 char to test binmode
		Zim::GUI::Daemon::Test->main;
	}
	wait;
}

unlink './t/gui_daemon_socket~'; # clean up

exit;

sub is {
	# Limited functionality only as needed in this test
	my ($a, $b, $comment) = @_;
	my $ok = 1;
	if (ref $a xor ref $b) { $ok = 0 } # only one is ref
	elsif (ref $a) { # array refs
		$ok = 0 unless $#$a == $#$b;
		for (0 .. $#$a) {
			if (! defined $$a[$_]) { $ok = 0 if defined $$b[$_] }
			else { $ok = 0 unless $$a[$_] eq $$b[$_] }
		}
	}
	else { $ok = $a eq $b }
	print "# >>$a<< neq\n  >>$b<<\n" if ! $ok;
	$ok = $ok ? 'ok' : 'nok';
	print $ok, ' ', $I++, ' - ', $comment, "\n";
}

sub open_pipe {
	my ($r, $w);
	pipe $r => $w;
	my $fh = select $w;
	$| = 1;
	select $fh;
	return $r, $w;
}

package Zim::GUI::Daemon::Test;

use strict;
use base qw/Zim::GUI::Daemon/;

our $parent;

sub ACTION_exit {
	exit;
}

sub ACTION_check1 {
	my ($class, $pid, @args) = @_;
	is($pid, $parent, 'server got pid');
	is(\@args, [qw/foo bar/], 'server got args 1');
}
sub ACTION_check2 {
	my ($class, $pid, @args) = @_;
	is(\@args, ['foo bar'], 'server got args 2');
}

sub is {
	# Limited functionality only as needed in this test
	my ($a, $b, $comment) = @_;
	my $ok = 1;
	if (ref $a xor ref $b) { $ok = 0 } # only one is ref
	elsif (ref $a) { # array refs
		$ok = 0 unless $#$a == $#$b;
		for (0 .. $#$a) { $ok = 0 unless $$a[$_] eq $$b[$_] }
	}
	else { $ok = $a eq $b }
	print "# >>$a<< neq\n  >>$b<<\n" if ! $ok;
	$ok = $ok ? 'ok' : 'nok';
	print $ok, ' ', $I++, ' - ', $comment, "\n";
}

