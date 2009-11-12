package Zim::GUI::Automount;

use strict;
use File::BaseDir qw(config_files);
use Zim::Utils;

our $VERSION = '0.27';

=head1 NAME

Zim::GUI::Automount - automount code for zim

=head1 DESCRIPTION

This class contains methods to automount directories before
opening a zim notebook. See the manual for details on the 
configuration.

=head1 METHODS

=over 4

=item C<mount(PATH)>

Tries to find a mount point for PATH.
If successfull or if path already mounted returns the path for the mount point.

=item C<umount(PATH, MOUNTPOINT)>

Tries to umount MOUNTPOINT for notebook PATH. Fails if C<< Zim::Daemon->list >> 
shows other notebooks using the same mount point.

=cut

sub mount {
	# Try to mount a notebook location, if no success just return,
	# calling routine will throw error or notebook will show empty
	my ($class, $path) = @_;
	$path = Zim::FS->abs_path($path);
	my $file = config_files(qw/zim automount/) or return;
	my $config = Zim::FS::File::Config->new($file)->read;
	for my $key (keys %$config) {
		my $glob = Zim::FS->abs_path($key);
		next unless $path =~ /^\Q$glob\E/;

		return $glob # input needed for umount
			if -f $path || -f "$path/notebook.zim" ; 

		warn "Mounting: $key\n";
		my $opt = $$config{$key};
		my $cmd = $$opt{mount};
		$cmd =~ s/\%f/$path/;
		if ($$opt{passwd}) {
			my $val = Zim::GUI::Component->run_prompt(
				__('Password'), #. dialog title
				['passwd'], {passwd => [__('Password'), 'password', '']}, #. dialog prompt
				undef, undef,
				__("Please provide the password for\n{path}", path => $path), #. dialog text
			);
			return unless $val;
			my $passwd = $$val[0];
			if ($$opt{passwd} eq 'stdin') {
				open MOUNT, "| $cmd" or return;
				print MOUNT $passwd, "\n";
				close MOUNT;
			}
			elsif ($$opt{passwd} eq 'file') {
				my $tmp = Zim::FS->tmp_file('mount');
				$tmp->write($passwd);
				$cmd =~ s/\%p/$tmp/;
				system $cmd;
				$tmp->remove;
			}
			else { die "Unknown passwd option in automount\n" }
		}
		else { system $cmd }
		return $glob; # input needed for umount
	}
	return undef;
}

sub umount {
	my ($class, $path, $mountpoint) = @_;
	#warn "Umount $path, $mountpoint\n";

	# check for other notebooks using this path - skip self
	$path =~ s/\/*$//;
	my @list = eval { Zim::GUI::Daemon->list() };
	for (@list) {
		#warn "CHECK $$_[1]\n";
		next if $$_[1] =~ /^\Q$path\E\/*$/;
		return 0 if $$_[1] =~ /^\Q$mountpoint\E/;
	}
	#warn "OK - no other clients using same path\n";

	my $file = config_files(qw/zim automount/) or return;
	my $config = Zim::FS::File::Config->new($file)->read;
	my ($key) = grep { Zim::FS->abs_path($_) eq $mountpoint } keys %$config;
	return unless defined $key;
	
	warn "Umounting: $key\n";
	my $cmd = $$config{$key}{umount};
	system $cmd;

	return 1;
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

