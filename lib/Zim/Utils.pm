package Zim::Utils;

use strict;
use File::BaseDir 0.03 qw/data_files/;
use Zim::FS;

our $VERSION = '0.26';

eval 'use Zim::OS::Win32' if $^O eq 'MSWin32';
die $@ if $@;

our @ISA = ($^O eq 'MSWin32') ? ('Zim::Utils::Win32')
                              : ('Zim::Utils::Unix' ) ;

our ($Plural, %Translation);
our @export = qw/__ __n __actions file dir uri buffer/;

=head1 NAME

Zim::Utils - Some useful functions and objects for zim.

=head1 DESCRIPTION

This package contains various utilities needed by the zim modules.

=head1 EXPORT

By default the methods C<__()>, C<__actions()>, C<file()>, C<dir()>
and C<buffer()> are exported.

=head1 METHODS

=over 4

=cut

sub import {
	shift; # class
	my ($caller) = caller;
	no strict 'refs';
	*{$caller.'::'.$_} = \&{$_} for @_ ? (@_) : (@export);
}

=item C<file(@PATH)>

Returns a new C<Zim::FS::File> object, see L<Zim::FS>.

=item C<dir(@PATH)>

Returns a new C<Zim::FS::Dir> object, see L<Zim::FS>.

=item C<uri(@URI)>

Returns a new C<Zim::FS::URI> object, see L<Zim::FS>.

=item C<buffer(\$STRING)>

=item C<buffer(@STRING)>

Returns a new C<Zim::FS::Buffer> object, see L<Zim::FS>.

=cut

sub file {
	return $_[0] if ref($_[0]) and @_ == 1;
	Zim::FS::File->new(@_);
}

sub dir  {
	return $_[0] if ref($_[0]) and @_ == 1;
	Zim::FS::Dir->new(@_);
}

sub uri {
	Zim::FS::URI->new(@_);
}

sub buffer {
	Zim::FS::Buffer->new(@_);
}

=item C<find_translation()>

Tries to load messages for the current locale.
Called automatically when this module is loaded.

=cut

sub find_translation {
	my ($file) = data_files('zim', 'lingua', $Zim::LANG.'.pl');
	unless ($file) {
		$Zim::LANG =~ /(\w+?)_(\w+)/; # e.g. nl_NL
		($file) = data_files('zim', 'lingua', $1.'.pl');
	}
	return () unless $file;
	warn "# Loading translation from: $file\n";
	eval {
		# file optionally defines a sub for plural forms
		# in any case contains hash ref with strings (and plural arrays)
		my @arg = do $file;
		$Plural = shift @arg if ref($arg[0]) eq 'CODE';
		%Translation = %{shift @arg};
	};
	$Plural ||= sub { my $n = shift; $n != 1 } ;
	warn $@ if $@;
	#use Data::Dumper; warn Dumper \%Translation;
}

=item C<< __(STRING, PARAM => VALUE, ...) >>

Return a translation for STRING. Parameters can be placed in
the string using C<{PARAM}> syntax.

=item C<< __n(STRING, PLURAL_STRING, number => N, PARAM => VALUE, ...) >>

Like C<__()> but deals with plural forms. The parameter C<{number}>
determines which plural is used (yes translations can have more than
one plural form ...).

=item C<__actions(BLOCK)>

Wrapper for C<__()> that can be used to translate actions.

=cut

sub __ {
	my ($string, %arg) = @_;
	#warn "Translating: >>$string<<\n";
	$string = $Translation{$string} || $string;
	#warn "\t>>$string<<\n";
	$string =~ s/\{(\w+)\}/$arg{$1}/g;
	return $string;
}

sub __n {
	my ($string, $plural, %arg) = @_;
	my $trans = $Translation{$string};
	if (! defined $trans) {
		# default, use english:
		# nplurals=2; plural=n != 1;
		$trans = ($arg{number} == 1) ? $string : $plural ;
	}
	elsif (ref $trans) {
		# use plural as supplied by template
		my $i = $Plural->($arg{number});
		$i = $#$trans if $i > $#$trans;
		$trans = $$trans[$i];
	}
	# else we had only single tranlation string
	$trans =~ s/\{(\w+)\}/$arg{$1}/g;
	return $trans;
}

sub __actions {
	my $block = shift;
	my $new;
	for my $l (split "\n", $block) {
		# The "is_menu" boolean is needed because autovivicating
		# tooltips for menu labels somehow invokes even more dark magic
		# on win32 this causes the main TextView to stop recieving
		# input ! see lp bug #252005 which was introduced by tooltip
		# fix for lp #226971 below :S
		next unless $l =~ /\S/;
		my @col = split /\t+/, $l;
		my $is_menu = (scalar(@col) < 4);
		$col[$_] ||= '' for 0 .. 4;
		my $key = __(qq{$col[2]|$col[4]});
			# HACK: avoid indexing by xgettext by not using quotes
		@col[2,4] = split /\|/, $key, 2;
		unless ($col[4] =~ /\S/) {
			# In theory tooltip can be empty, but this causes a
			# bug with certain strings in specific translations,
			# see lp bug #226971. No clue why adding a tooltip 
			# string fixes this, but it works. However just a 
			# space is not enoug. Must be dark magic ...
			$col[4] = $col[2];
			$col[4] =~ s/_//; # remove accelerator
		}
		@col = @col[0..2] if $is_menu;
		$new .= join("\t", @col)."\n";
	}
	#warn "ACTIONS >>\n$new<<\n\n";
	return $new;
}

=item C<parse_date(STRING)>

Parses various date strings and returns a list of year, month and day.
If the year is missing a reasonable guess is given.
Similar for the century.

Supported formats:

	dd/mm		d/mm d/m dd/m
	dd/mm/yy	...
	dd/mm/yyyy	...

	yyyy_mm_dd	yy_m_d ...
	yyyy mm dd	yy m d ...
	yyyy:mm:dd	yy:m:d ...

TODO: Add other common date formats ?

=item C<parse_date_l(STRING)>

Like C<parse_date()> but returns a list similar to C<localtime()>.
If STRING is an integer it calls C<localtime()> directly.

=cut

sub parse_date {
	my $s = shift;
	#warn "Parse date: >>$s<<\n";
	$s =~ s/^\D*|\D*$//g; # remove any prefix / postfix
	my @date = ($s =~ m/^\d+\/\d+(\/\d+)?$/) ? reverse(split '/', $s) :
	           ($s =~ m/^\d+_\d+_\d+$/)      ? split( '_', $s)        :
	           ($s =~ m/^\d+ \d+ \d+$/)      ? split( ' ', $s)        :
	           ($s =~ m/^\d+:\d+:\d+$/)      ? split( ':', $s)        : () ;
	return undef unless @date;
	#warn "Parse date: @date\n";
	my ($month, $year) = (localtime)[4,5];
	$year  += 1900;
	$month += 1;
	if (@date == 2) {
		# guess the year
		unshift @date, $year;
		$date[0] += 1 if $month - $date[2] >= 6;
	}
	elsif (length($date[0]) == 2) {
		# guess the century
		$date[0] += ($date[0] >= 50) ? 1900 : 2000;
		#$date[0] += ($year - $date[0] >= 50) ? 1900 : 2000; # FIXME
	}
	return @date;
}

sub parse_date_l {
	my $string = shift;
	if ($string =~ /\D/) {
		my ($y, $m, $d) = parse_date($string);
		$m -= 1; # base zero
		$y -= 1900; # years since 1900
		# ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
		# Returning undef for remaining fields here causes bugs
		# e.g. wday=undes causes each day to be sunday
		return (0,0,0, $d,$m,$y);

	}
	else { return localtime $string }
}

sub strftime { goto \&{"$ISA[0]::strftime"} }
	# FIXME: this feels like a HACK

package Zim::Utils::Unix;

use POSIX 'strftime';

=item C<run(PROGRAM, ARG, ...)>

Run background process (fork + exec).

=cut

sub run {
	my ($self, @args) = @_;
	@args = grep defined($_), @args;
	warn "# Executing: @args\n";
	unless (fork) { # child process
		exec @args;
		exit 1; # just to be sure
	}
}

=item C<strftime(FMT, @TIME)>

Wrapper for the L<POSIX/strftime> function.
Takes care of portability of "%e".

=cut

# strftime is actually imported from POSIX

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2007 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

