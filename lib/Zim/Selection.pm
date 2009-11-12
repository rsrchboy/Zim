package Zim::Selection;

use strict;
use Zim::Utils;
use Zim::Store;

our $VERSION = '0.24';
our @ISA = qw/Zim::Store/;

=head1 NAME

Zim::Selection - selection of pages

=head1 SYNOPSIS

FIXME simple code example

=head1 DESCRIPTION

This class is used to manage selections of pages.
The pages are still asociates with a repository, this object can
be used to call operations on a sub-set of a repository.

Inherits from L<Zim::Store>.

=head1 METHODS

=over 4

=item C<new($REPOSITORY, \%OPT, @PAGES)>

Constructor. REPOSITORY should be an object of class L<Zim> or L<Zim::Store>
and is the object used to look up the pages in the selection.

The OPT hash can contain several options. Curently only "recurse" and
"resolve" are recognized. If "recurse" is set for all pages the corresponding
namespace is also added. If "resolve" is set the page list is treated as
user input.

The list of PAGES can contain both pages and namespaces. Namespaces are always
added recursively.

=cut

sub new {
	my ($class, $rep, $opt, @pages) = @_;
	my $self = bless {rep => $rep}, $class;
	@pages = grep /\S/, map {
		/:$/ ? $self->{rep}->resolve_namespace($_)
		     : $self->{rep}->resolve_page($_)->name ;
	} @pages if $$opt{resolve} ;
	@pages = map {
		/:$/ ? ($_) : ($_, $_.':')
	} @pages if $$opt{recurse} ;
	$self->{list} = \@pages;
	#warn "Selection: @pages\n";
	return $self;
}

=item C<root()>

Returns self,  needed to use selection as mock repository in tests.

=cut

sub root { return $_[0] }

=item C<resolve_case(\@NAME, \@REF)>

Used to resolve pages against paths in the selection.

=cut

sub resolve_case {
	# TODO take care of recursion by calling the apropriate repositories
	my ($self, $name, $ref) = @_;
	if ($ref and @$ref) {
		my $a = shift @$name;
		my $m;
		for (reverse -1 .. $#$ref) {
			my $n = ':'.join ':', @$ref[0 .. $_], $a;
			for (@{$self->{list}}) {
				next unless /^(\Q$n\E)(:|$)/i;
				$m = $1;
				last;
			}
			last if $m;
		}
		return undef unless $m;
		my $n = join ':', $m, @$name;
		# TODO check case rest of path
		return $n;
	}
	else {
		# TODO partial matches ?
		my $n = ':'.join ':', @$name;
		for (@{$self->{list}}) {
			return $_ if lc($_) eq lc($n);
		}
	}
	return undef;
}

=item C<foreach(\&CODE, \@ARGS)>

The code reference CODE is called for each page with as
arguments ARGS and the page object.

=cut

sub foreach {
	my ($self, $code, $args) = @_;
	for (@{$self->{list}}) {
		if (/:$/) { $self->_recurse($_, $code, $args) }
		else {
			my $page = $self->{rep}->get_page($_);
			next unless $page;
			$code->(($args ? (@$args) : ()), $page);
		}
	}
}

sub _recurse { # dispatch a foreach call to a namespace
	my ($self, $ns, $code, $args) = @_;
	warn "# Recursing for namespace: $ns\n";
	for my $name ($self->{rep}->list_pages($ns)) {
		my $r = ($name =~ s/:+$//);
		my $page = $self->{rep}->get_page($ns.$name);
		$code->(($args ? (@$args) : ()), $page) if $page;
		$self->_recurse($ns.$name.':', $code, $args) if $r;
	}
}

=item C<parse_query(STRING)>

Returns a data structure for a search query.
See user manual for syntax description.

=cut

sub parse_query {
	shift; # object or class
	my $string = shift;
	my @words = _tokenize_query($string);
	#warn "TOKENS: ".join(', ', @words)."\n";
	my @refs = ({});
	while (@words) {
		if ($words[0] eq 'OR') {
			shift @words;
			push @refs, {};
			next;
		}

		my $k = 'any';
		my $v = shift @words;
		if (@words and $v =~ /^(\w+)\:$/) {
			$k = lc $1;
			$v = shift @words;
			die "Unknown field: $k\n"
				unless grep {$k eq $_}
					qw/content name links linksto/;
		}
		if ($v eq 'NOT') {
			$k = 'not-'.$k;
			$v = shift @words;
		}
		$v =~ s/^"(.*)"$/$1/;
		#$v =~ s/\\(.)/$1/g;
		next unless length $v;
		my $r = $refs[-1];
		$$r{$k} = [ $$r{$k} ]
			if defined $$r{$k} and ! ref $$r{$k} ;
		if   (ref $$r{$k}) { push @{$$r{$k}}, $v }
		else               { $$r{$k} = $v        }
	}
	@refs = grep scalar(%$_), @refs;
	return @refs == 1 ? $refs[0] : \@refs ;
}

my %_opp_alias = (
	'||'  => 'OR',
	'or'  => 'OR',
	'&&'  => 'AND',
	'+'   => 'AND',
	'and' => 'AND',
	'-'   => 'NOT',
	'not' => 'NOT',
);

sub _tokenize_query {
	my $string = shift;
	$string =~ s/^\s*//;
	my @words;
	while ($string =~ /\S/) {
		push @words, $1 if $string =~ s/^([+-])\s*//;
		if ($string =~ /^"/) {
			$string =~ s/^("[^"]*")//s;
			#$string =~ s/^("(\\.|[^"])*")//s;
			push @words, $1 if defined $1;
		}
		#$string =~ s/^((\\.|\S)*)\s*//;
		$string =~ s/^([^"\s]*)\s*//;
		push @words, $1 if defined $1;
	}
	@words =
		grep {$_ ne 'AND'} # AND is default opp.
		map  { exists( $_opp_alias{$_} ) ? $_opp_alias{$_} : $_ }
		grep length($_), @words;
	return @words;
}


=item C<export($TARGET)>

=item C<export(\%OPT)>

Export the pages to TARGET, which should be a repository.

When called with a hash of options, these options are used to
open the target repository. At least provide the options
'dir' and 'format'. You can also give 'template', which can
be a template name or a file name. When no template is given
we try to use template 'Default' but fail silently.

=cut

sub export {
	my ($self, $opt) = @_;
	my $target;
	eval 'require Zim::Template';
	die $@ if $@;
	if (ref($opt) eq 'HASH') {
		die "For exporting you need to provide at least".
		    "arguments 'dir' and 'format'.\n"
		    if grep {! length $_} @$opt{qw/dir format/} ;

		dir($$opt{dir})->touch;
		eval "use Zim::Store::Files"; die $@ if $@;
		$target = Zim::Store::Files->new(
				dir => $$opt{dir},
				format => $$opt{format},
				document_root =>
					$$opt{doc_root} ? uri($$opt{doc_root})
					               : undef
				) ;

		my $template = $$opt{template};
		if ($template) {
			$template = Zim::Formats->lookup_template(
				$$opt{format}, $template)
				unless $template =~ /[\/\\]/;
			die "Could not locate template \"$$opt{template}\"\n"
				unless length $template;
		}
		else {
			$template = Zim::Formats->lookup_template(
				$$opt{format}, 'Default');
		}
		warn "# Export template: $template\n";
		$target->{_template} = Zim::Template->new($template)
			if $template;
			# FIXME temporary hack to set template
			# do not confuse with the template for new pages
	}
	else {
		warn "# Exporting to pre-set repository\n";
		$target = $opt;
	}

	$target->{user_name} = $self->{rep}{user_name};
	if ($$opt{index}) {
		$target->{_index} = $target->resolve_name($$opt{index});
		die "Could not resolve index page"
			if ! $target->{_index};
	}

	my $index = '';
	my @items = (undef, undef, undef);
	my $code = sub {
		my $page = shift;
		return if defined $page and ! $page->exists;

		# convert to linked list
		push @items, $page;
		shift @items;
		$page = $items[1]; # in fact previous page
		return unless $page;
		$target->{_prev} = $items[0];
		$target->{_next} = $items[2];
		
		my $name = $page->name;
		warn "# Exporting: $name\n";
		$$opt{callback}->($page) || die "Export Cancelled at page $name\n"
			if $$opt{callback};
		my $target_page = $target->get_page($name);
		$target_page->clone($page, %$opt);
		$index .= $name."\n";
	} ;
	warn "# Start Exporting\n";
	$self->foreach($code);
	$code->(undef) if $items[2]; # flush last page

	$self->_write_index($target, $index) if $$opt{index} ;
	warn "# Done Exporting\n";
}

sub _write_index { # write a index page for export
	my ($self, $target, $index) = @_;

	my $page = $target->get_page($target->{_index});
	$page->delete if $page->exists; # prevent mtime check etc.

	# convert index to wiki list
	# TODO use parse tree list items
	my (@list, @ns);
	for my $page (split /\n/, $index) {
		my @parts = split /:+/, $page;
		shift @parts; # /^:/ => (undef, ..)
		my $match = 1;
		for my $depth (0 .. $#parts-1) {
			next if $match and defined $ns[$depth]
				and $ns[$depth] eq $parts[$depth];
			$match = 0;
			my $name = $parts[$depth];
			$name =~ s/_/ /g;
			push @list,
				("\t"x$depth)."\x{2022} ",
				['bold', {}, $name], "\n" ;
		}
		@ns = @parts;
		
		my $depth = $#ns;
		my $name = $parts[-1];
		$name =~ s/_/ /g;
		push @list,
			("\t"x$depth)."\x{2022} ",
			['link', {to => $page}, $name], "\n" ;
	}

	warn "# Writing index\n";
	$page->{_is_index}=1; # FIXME hack
	$page->set_parse_tree( ['Page', {}, ['Para', {}, @list] ] ) ;
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

