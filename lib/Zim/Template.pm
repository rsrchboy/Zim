package Zim::Template;

use strict;
use vars qw/$CODESET/;
use Carp;
use Encode;
use Zim::Utils;

our $VERSION = '0.24';

*CODESET = \$Zim::CODESET;
$CODESET ||= 'utf8';

=head1 NAME

Zim::Template - Simple templating module

=head1 SYNOPSIS

	my $data = {
		version => '1.0',
		links => [qw/a b c/],
		body => \&page_to_html,
	};
	my $t = Zim::Template->new('./template.html');
	$templ->process($data => './page.html');

=head1 DESCRIPTION

Simple templating module. Template syntax is as follows:

	[% var %]
	[% hash.key %]
	[% strftime("%c", var) %]
	[% IF var %] .. [$ END %]
	[% IF var %] .. [% ELSE %] ... [$ END %]
	[% FOREACH name = var %] ... [% name %] ... [% END %]

The template is tokenized and kept in memory. Thus this module is most
efficient when you want to dump many pages with one template.

=head1 IO

This module supports various IO methods for both in- and output.
IO arguments can be any of the following: a file name, a File object,
an IO object or file handle or a scalar reference.

=head1 DATA

The DATA hash used contains the variables and data structures used to fill in
template fields. Any code references in the data structure are used to autoload data
and will be called only once.

=head1 METHODS

=over 4

=item C<new(IO, NAME, LINE)>

Constructor. Reads and parses a template from IO.
NAME and LINE are optional and are used for error reporting.

=cut

sub new {
	my ($class, $io, $name, $line) = @_;
	my $self = bless {name => $name}, $class;
	my $fh = $self->_open_io($io, 'r', 1);
	$self->{tokens} = $self->_tokenize($fh, $line || 1);
	close $fh;
	#use Data::Dumper; warn "Tokens for '$$self{name}' : ", Dumper $$self{tokens};
	return $self;
}

sub _die { die sprintf "\%s in template '\%s' at line \%u\n", $_[1], $_[0]{name}, $_[2] }

sub _open_io {
	my ($self, $io, $mode, $set_name) = @_;

	if (ref($io) eq 'SCALAR') {
		$self->{name} = "$io" if $set_name;
		return buffer($io)->open($mode);
	}
	elsif (! ref $io or $io->can('path')) { # file name or object
		my $f = ref($io) ? $io : file($io);
		$self->{name} = $f->path if $set_name;
		return $f->open($mode);
	}
	else { # assume it to be an IO handle
		$self->{name} = "$io" if $set_name;
		return $io;
	}
}

sub _tokenize_string {
	my ($self, $string, $count) = @_;
	return unless defined $string and length $string;
	my $fh = buffer(\$string)->open('r');
	my $t = $self->_tokenize($fh, $count, 1);
	close $fh;
	return $t;
}

sub _tokenize { # Parses text and builds a token tree
	my ($self, $in, $count, $is_block) = @_;
	my @tokens;
	while (my $line = <$in>) {
		$line =~ s/^\s*(\[\%\s[^\%]*\s\%\])\s*$/$1/; # beatify block statements
		while ($line =~ s/^(.*?)\[\%\s+//) {
			push @tokens, $1 if length $1;
			$line =~ s/^(.*?)\s+\%\]// or $self->_die("Unmatched '[\%'", $count);
			my $expr = $1;
			if ($expr =~ /^IF\s+([\w\.]+)$/) {
				my $t = {
					token => 'IF',
					line => $count,
					var => $1,
				};
				my $c;
				($expr, $line, $c) = $self->_collect($line, $in);
				my ($if, $else) = split /\[\%\s+ELSE\s+\%\]/, $expr, 2;
				$$t{if_branch}   = $self->_tokenize_string($if,   $count);
				$$t{else_branch} = $self->_tokenize_string($else, $count);
				$count = $c;
				push @tokens, $t;
			}
			elsif ($expr =~ /^FOREACH\s+([\w\.]+)\s*=\s*([\w\.]+)$/) {
				my $t = {
					token => 'FOREACH',
					line => $count,
					key => $1,
					var => $2,
				};
				my $c;
				($expr, $line, $c) = $self->_collect($line, $in);
				$$t{loop_branch} = $self->_tokenize_string($expr, $count);
				$count = $c;
				push @tokens, $t;
			}
			elsif ($expr =~ /^(?:SET\s+)?([\w\.]+)\s*=\s*(\S+)$/) {
				push @tokens, {
					token => 'SET',
					line => $count,
					var => $1,
					val => $2,
				};
			}
			elsif ($expr =~ /^(?:GET\s+)?([\w\.]+)$/) {
				$line ||= "\n" unless $is_block; # reverse beautification
				push @tokens, {
					token => 'GET',
					line => $count,
					var => $1
				};
			}
			elsif ($expr =~ /^([\w\.]+)\((.*?)\)$/) {
				$line ||= "\n" unless $is_block; # reverse beautification
				push @tokens, {
					token => 'CALL',
					line => $count,
					function => $1,
					args => _parse_args($2),
				};
			}
			else { $self->_die("Unknown expression '$expr'") }
		}
		push @tokens, $line if length $line;
		$count++; # increment line count
	}
	return \@tokens;
}

my %special = (n => "\n", t => "\t");

sub _parse_args {
	# parse a string into an argument list
	# all arguments are strings by defnition, NO CODE EVAL!
	my $string = shift;
	return [] unless $string =~ /\S/;
	my @args;
	while ($string =~ s/^\s*((["'])(\\.|[^'"])*\2|[^\s,]+)\s*,?//) {
		#warn ">>$1<< >>$string<<\n";
		my $arg = $1;
		$arg =~ s/^(['"])(.*)\1$/$2/; # remove quotes
		$arg =~ s/\\(.)/$special{$1}||$1/eg; # remove escapes
		push @args, $arg;
	}
	return \@args;
}

sub _collect { # Collect template content till next (not nested) "[% END %]"
	my ($self, $line, $in, $count) = @_;
	my ($blob, $stack) = ('', 0);

	while (defined $line) {
		while ($line =~ s/^(.*?)(\[\%\s+(IF|FOREACH|END)\b.*?\s\%\])//) {
			$blob .= $1;
			if ($3 eq 'END') {
				return ($blob, $line, $count) if ! $stack;
				$stack--;
			}
			else { $stack++ }
			$blob .= $2;
		}
		$blob .= $line;
		$line = <$in>;
		$count++;
		$line =~ s/^\s*(\[\%\s[^\%]*\s\%\])\s*$/$1/; # beatify block statements
	}

	return ($blob, $line, $count);
}

=item C<< process(\%DATA => IO) >>

Wraps C<set_data()> and C<output()> in one call.

=cut

sub process {
	my ($self, $data, $io) = @_;
	croak "DATA is not a hash" unless ref($data) eq 'HASH';
	$self->set_data($data);
	$self->output($io);
}

=item C<set_data(\%DATA)>

Set the data hash.

=cut

sub set_data {
	my ($self, $data) = @_;
	croak "DATA is not a hash" unless ref($data) eq 'HASH';
	#use Data::Dumper; warn Dumper $data;
	$self->{data} = $data;
}

=item C<output(IO)>

Combine the template with the data and write to IO.

=cut

sub output {
	my ($self, $io) = @_;
	croak "No data set to use in the template" unless $self->{data};

	my $fh = $self->_open_io($io, 'w');
	$self->_output($fh, $self->{tokens});
	close $fh;
}

sub _output { # Processes a token tree
	my ($self, $fh, $tokens) = @_;
	return unless $tokens;
	for my $t (@$tokens) {
		if (ref $t) {
			if ($$t{token} eq 'GET') {
				my $val = $self->_var(@$t{'var', 'line'}, $fh);
				print $fh $val if defined $val;
			}
			elsif ($$t{token} eq 'SET') {
				my ($var, $hash) = ($$t{var}, $self->{data});
				if ($var =~ s/^(.*)\.//) {
					$hash = $self->_var($1, $$t{line});
					my $r = ref $hash || 'scalar';
					$self->_die("Var '$1' is of type $r - not HASH", $$t{line}) unless $r eq 'HASH';
				}
				$hash->{$var} = $$t{val};
			}
			elsif ($$t{token} eq 'IF') {
				my $var = $self->_var(@$t{'var', 'line'});
				my $r = ref $var;
				$var = ($r eq 'ARRAY') ? scalar(@$var) :
				       ($r eq 'HASH' ) ? scalar(%$var) : $var ;
				if ($var) { $self->_output($fh, $$t{if_branch})   }
				else      { $self->_output($fh, $$t{else_branch}) }
			}
			elsif ($$t{token} eq 'FOREACH') {
				my $var = $self->_var(@$t{'var', 'line'});
				my $r = ref($var) || 'scalar';
				$self->_die("Var '$$t{var}' is of type $r - not ARRAY")
					unless ref($var) eq 'ARRAY';
				foreach (@$var) {
					local $$self{data}{$$t{key}} = $_;
					#warn "local '$key' is '$_'\n";
					$self->_output($fh, $$t{loop_branch});
				}
			}
			elsif ($$t{token} eq 'CALL') {
				die "TODO: allow other functions except strftime"
					unless $$t{function} eq 'strftime';
				my $fmt = $$t{args}[0] || "%c";
				my $time = $$t{args}[1]
					? $self->_var($$t{args}[1], $$t{line})
					: time;
				my @date = Zim::Utils::parse_date_l($time);
				print $fh Encode::decode($CODESET,
					Zim::Utils::strftime($fmt, @date) );
			}
			else { die "BUG: unknown token: $$t{token}" }
		}
		else { print $fh $t }
	}
}

sub _var { # Evaluates a variable
	my ($self, $var, $line, $fh) = @_;
	my ($key, $val) = ('', $self->{data});
	for my $k (split /\./, $var) {
		my $v;
		if (ref($val) eq 'HASH') {
			$v = $val->{$k};
			$key .= length($key) ? $key.'.'.$k : $k ;
		}
		else {
			my $t = ref($val) || 'scalar';
			$self->_die("Var '$key' is of type $t - not HASH", $line);
		}

		if (ref($v) eq 'CODE') {
			$v = $v->($key, $fh);
			$val->{$k} = $v if defined $v;
			$val = $v;
		}
		else { $val = $v }
	}
	#warn "Returning '$val' for '$key'\n";
	return $val;
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

