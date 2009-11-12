package Zim::Utils::Win32;

use strict;
use Win32::Process;

our $VERSION = '0.24';

=head1 NAME

Zim::Win32 - win32 specific routines for zim

=head1 DESCRIPTION

This module contains some routines that are specific
for the windows platform.

=cut

## Spawning processes ##

$Zim::GUI::DEFAULTS{browser} = 'firefox.exe';
$Zim::GUI::DEFAULTS{file_browser} = 'explorer.exe';
$Zim::GUI::DEFAULTS{text_editor} = 'notepad.exe';

sub run {
	my ($self, @args) = @_;
	my ($prog, $cmdline);
	if (@args > 1) {
		$cmdline = join ' ', map {/\s/ ? qq/"$_"/ : $_} @args;
		$prog = $args[0];
	}
	else {
		$cmdline = $args[0];
		$args[0] =~ /^(['"])(.+?)\1|^(\S+)/;
		$prog = $2 || $3;
	}
	$prog = _lookup_exec($self, $prog) unless $prog =~ /\\/;
	return unless $prog;
	
	warn "Executing $prog, $cmdline\n";
	my $ProcessObj;
	Win32::Process::Create(
		$ProcessObj, $prog, $cmdline, 0, NORMAL_PRIORITY_CLASS, "." );
};

sub _lookup_exec {
	my ($self, $prog) = @_;
	for (split /;/, $ENV{PATH}) {
		my $try = File::Spec->catfile($_, $prog);
		return $try if -f $try;
	}
	warn "Could not find program: $prog";
	return undef;
}

sub strftime {
	# We want to be able to use %e in labels, but is not portable
	# to win32, so we port it ourselves here ...
	my $fmt = shift;
	my $e = POSIX::strftime('%d', @_);
	$e =~ s#^0# #; # day of month, so max 1 zero
	$fmt =~ s#(%%|%e)#$1 eq '%e' ? $e : $1#eg;
	return POSIX::strftime($fmt, @_);
}

package Zim::FS::Win32;

our @ISA = qw/Zim::FS::Unix/;

# Turn /foo into C:/foo
# wrap unix abs_path function by using /C:/path

sub abs_path {
	my ($class, $file, $ref) = @_;
	
	if ($file =~ m#file:/#) { $file = $class->uri2path($file) }
	else { $file =~ s#\\#/#g } # foo\bar => foo/bar
	
	$file =~ s#^([a-z]:/)#/$1#i; # C:/foo => /C:/foo
	$file = Zim::FS::Unix::abs_path($class, $file, $ref);
	$file =~ s#^/+([a-z]:/)#$1#i; # /C:foo => C:/foo
	
	return $file unless $file =~ m#^/#i;

	$ref ||= $ENV{PWD};
	my ($vol, undef, undef) = File::Spec->splitpath($ref);
	return $vol.$file;
};

# support file:///C:/path
# translate file:////host/share => smb://host/share

sub uri2path {
	my ($class, $file) = @_;
	$file =~ m#^file:/# or return $file;
	return $file if $file =~ s#^file:////(?!/)#smb://#;
	$file = Zim::FS::Unix::uri2path($class, $file);
	$file =~ s#^/+([a-z]:/)#$1#i;
	return $file;
};

sub localize {
	my ($class, $file) = @_;
			my ($vol, undef, undef) = File::Spec->splitpath($ENV{PWD});
	if    ($file =~ s#^smb://+##) { $file = '\\\\'.$file } # shared folder
	elsif ($file =~ s#^file://##) { # file uri
		$file = $class->uri2path($file);
		$file = $class->localize($file); # recurs
		return $file if $file =~ m#^\w[\w\+\-\.]+:/#;
		return $class->path2uri($file);
	}
	elsif ($file =~ m#^\w[\w\+\-\.]+:/#) { return $file } # uri
	elsif ($file =~ m#^/#) {
		$file = $vol.$file
			unless $file =~ s#^/+([a-z]:/)#$1#i;
	}
	$file =~ s#/+#\\#g;
	return $file;
};

1;

__END__

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

