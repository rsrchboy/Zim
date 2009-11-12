package Zim::Formats::Wiki;

use strict;
no warnings;
use Zim::Formats;

our $VERSION = '0.28';
our @ISA = qw/Zim::Formats/;

# TODO: some tags can be nested: email links for example

=head1 NAME

Zim::Formats::Wiki - Wiki text parser

=head1 DESCRIPTION

This is the default parser for Zim.
It uses a wiki-style syntax to format plain text.

FIXME more verbose description

All format types are signified by double characters,
this is done to prevent accidental formatting when the same
characters are used normally in a text. For the same reason
the strike character is '~' instead of '-' because '--' can
occur in normal ascii text. In the regexes we try to always
match the inner pair if more than two of these characters
are encountered. (Thus if we see C<***bold***> we should match
C<*(**bold**)*>.)


=head1 METHODS

=over 4

=item C<load_tree(IO, PAGE)>

Reads plain text from a filehandle and returns a parse tree.

=cut

sub load_tree { # TODO whitelines between verbatim blocks should be preserved
	my ($class, $io, $page) = @_;

	my @tree;
	my $para = ''; # paragraph buffer
	my $first = 1; # used to detect the first paragraph
	my $verbatim = 0; # true when inside a verbatim block
	while (<$io>) {
		s/\r?\n$/\n/; # DOS to Unix conversion
		unless (/\S/) { # empty line
			if ($verbatim and $para !~ /^\s*'''\s*\Z/m) {
				$para .= $_;
				next;
			}
			else { $verbatim = 0 }

			if ($first and $para =~ 
				/^Content-Type:\s+text\/x-zim-wiki/i
			) {
				# First paragraph looking like meta header
				$class->parse_page_properties($page, $para);
			}
			elsif (length $para) {
				# All other para, verbatim and headers
				push @tree, $class->parse_para($para, $page);
			}
			$tree[-1][1]{empty_lines}++ if scalar @tree;
				# count empty lines
			$para = '';
			$first = 0;
		}
		else { # non-empty line
			# next four lines by SIMON
			if (/^\s*'''\s*$/ and $para ne '' and $verbatim == 0) {
				push @tree, $class->parse_para($para, $page);
				$para = '';
			}
			$verbatim = 1 if /^\s*'''\s*$/ and $para eq '';
				# toggle verbatim at start of para
			$para .= $_;
		}
	}
	push @tree, $class->parse_para($para, $page) if length $para;
	
	#use Data::Dumper; print STDERR Dumper \@tree;
	return ['Page', $$page{properties}, @tree];
}

sub parse_para {
	my ($class, $text, $page) = @_;

	# check Verbatim paragraphs
	my $version = $$page{properties}{'Wiki-Format'};
	$version =~ s/zim\s+//;
	if ( (!$version or $version < 0.26) and $text !~ /^(?!\t|\s\s+)/m) {
		# verbatim blocks before 0.26 need to start
		# with all whitespace, either tab or multiple spaces
		my ($indent) = ($text =~ /^(\s+)/);
		$text =~ s/^$indent//mg;
		return ['Verbatim', {}, $text];
	}
	if ($text =~ m/\A\s*'''\s*$/m and $text =~ m/^\s*'''\s*\Z/m) {
		# parsing Verbatim paragraphs for version >= 0.26
		# just remove surrounding "'''" quotes
		$text =~ s/\A\s*'''\s*$|^\s*'''\s*\Z//mg;
		$text =~ s/^\n//;
		return ['Verbatim', {}, $text];
	}

	# Separate headers and paragraphs
	return grep defined($_), map {
		if (!/\S/) { undef }
		elsif (/^==+\s+\S+/ and ! /\n/) { # header
			$class->parse_head($_);
		}
		else { # paragraph
			s/^\n//;
			s/^(\s*)\*(\s+)/$1\x{2022}$2/mg; # bullet lists
			['Para', {}, $class->parse_block($_, $page)];
		}
	} split /^(==+[^\n\S]+\S+.*)$/m, $text;
}

sub parse_head { # parse a header
	my ($class, $head) = @_;
	chomp $head;
	$head =~ s/^(==+)\s+(.*?)(\s+==+\s*|\s*)$/$2/;
	my $level = 7 - length($1); # =X6 => head1, =X5 => head2 etc.
	$level = 1 if $level < 1;
	$level = 5 if $level > 5; # just to be sure
	return ['head'.$level, {}, $head];
}

our @parser_subs = qw/
	parse_checkbox
	parse_verbatim
	parse_links
	parse_images
	parse_styles
	parse_urls
/;

sub parse_block { # parse a block of text
	my ($class, $text, $page) = @_;
	my @text = ($text);
	for my $sub (@parser_subs) {
		@text = map {ref($_) ? $_ : ($class->$sub($_, $page))} @text;
	}
	return @text;
}

sub parse_checkbox {
	my ($class, $text) = @_;
	my $i = 0;
	return	map {
		unless ($i++ % 2) { $_ }
		else {
			/^(\s*)/;
			my $space = $1;
			my $state = /\[\*\]/ ? 1 : /\[x\]/i ? 2 : 0 ;
			my $check = ['checkbox',  {state => $state}];
			length($space) ? ($space, $check) : $check;
		}
	} split /^(\s*\[[\s\*x]?\])/mi, $text;
}

sub parse_verbatim { # like parse_style() but needs to be done earlier
	my ($class, $text) = @_;
	my $i = 0;
	return	map {
		unless ($i++ % 2) { $_ }
		elsif (/^\'\'(.+)\'\'$/) { ['verbatim',  {}, $1] }
	} split /(\'\'(?!\').+?\'\')/, $text;
}

sub parse_links {
	my ($class, $text) = @_;
	my $i = 0;
	return
		map   { ($i++ % 2) ? _parse_link($_) : $_ }
		split m#(\[\[(?!\[).+?\]\])#, $text;
}

sub _parse_link {
	my $l = shift;
	my $text;
	if ($l =~ /^\[\[([^|]*)\|?(.*)\]\]$/) { # [[link]] or [[link|text]]
		($l, $text) = ($1, $2);
		$l = $text unless length $l; # [[|link]] bug
	}
	if ($l =~ /^mailto:|^\S+\@\S+\.\w+$/) {
		$text = $l unless length $text;
		$l =~ s/^(mailto:)?/mailto:/;
	}
	return ['link', {to => $l}, length($text) ? $text : $l ];
}

sub parse_urls {
	my ($class, $text) = @_;
	my $i = 0;
	my $C = q/[^\s\"\<\>\']/; # limit the character class a bit
	return
		map   { ($i++ % 2) ? _parse_link($_) : $_ }
		split m#(
			\b\w[\w\+\-\.]+://  $C*\[$C+\](?:$C+[\w\/])? |
			\b\w[\w\+\-\.]+://  $C+[\w\/]                |
			\bmailto:$C+\@      $C*\[$C+\](?:$C+[\w/])?  |
			\bmailto:$C+\@      $C+[\w/]                 |
			\b$C+\@$C+\.\w+\b
		)#x, $text;
		# The host name in an uri can be "[hex:hex:..]" for ipv6
		# but we do not want to match "[http://foo.org]"
		# See rfc/3986 for the official -but unpractical- regex
}

sub parse_styles { # parse blocks of bold, italic and underline
	my ($class, $text) = @_;
	my $i = 0;
	return	map {
		unless ($i++ % 2) { $_ }
		elsif (/^\*\*(.+)\*\*$/) { ['bold',      {}, $1] }
		elsif (/^\/\/(.+)\/\/$/) { ['italic',    {}, $1] }
		elsif (/^\~\~(.+)\~\~$/) { ['strike',    {}, $1] }
		elsif (/^\_\_(.+)\_\_$/) { ['underline', {}, $1] }
	} split /(
		\*\*(?!\*).+?\*\* |
		(?<!\:)\/\/(?!\/).+?\/\/ |
		\~\~(?!\~).+?\~\~ |
		__(?!_).+?__
	)/x, $text;
}

sub parse_images {
	my ($class, $text, $page) = @_;
	my $i = 0;
	my @parts =
		map   { ($i++ % 2) ? ['image', {src => $_}] : $_ }
		split /\{\{(?!\{)(.+?)\}\}/, $text;
	for my $p (@parts) {
		next unless ref $p and $$p[0] eq 'image';
		if ($$p[1]{src} =~ s/\?(\w+=\w+(?:&\w+=\w+)*)$//) {
			my %arg = split /[=&]/, $1;
			$$p[1]{$_} = $arg{$_} for keys %arg;
		}
		$$p[1]{file} = $page->resolve_file($$p[1]{src});
		#use Data::Dumper; warn "IMAGE: ", Dumper $p;
	}
	return @parts;
}

=item C<save_tree(IO, TREE, PAGE)>

Serializes the parse tree into a piece of plain text and writes this
to a filehandle.

=cut

sub save_tree {
	# TODO add support for recursive tags
	my ($class, $io, $tree, $page) = @_;

	my $p = $$page{properties};
	$$p{'Content-Type'} = 'text/x-zim-wiki';
	$$p{'Wiki-Format'} = 'zim 0.26';
	print $io $class->dump_page_properties($page), "\n";

	my $old_fh = select $io;
	eval { $class->_save_tree($tree) };
	select $old_fh;
	die $@ if $@;
}

sub _save_tree {
	my ($class, $tree) = @_;
	
	my ($name, $opt) = splice @$tree, 0, 2;
	die "Invalid parse tree"
		unless length $name and ref($opt) eq 'HASH';

	while (@$tree) {
		my $node = shift @$tree;
		unless (ref $node) {
			$node =~ s/^(\s*)\x{2022}(\s+)/$1*$2/mg;
			print $node;
			next;
		}
	
		my ($tag, $meta) = @$node[0, 1];
		
		# Blocks
		if ($tag eq 'Para') {
			$class->_save_tree($node); # recurs
			# except for the last, a para always needs a newline
			$$meta{empty_lines} ||= (@$tree ? 1 : 0);
			print "\n"x$$meta{empty_lines};
			next;
		}
		elsif ($tag eq 'Verbatim') {
			my $text = _dump($node);
			# make sure there are no empty lines between the
			# paragraph and the block quotes
			$text =~ s/(\n?)$/\n/;
			$$meta{empty_lines}-- if defined $1;
			$text =~ s/^(\n*)/$1'''\n/;
			$text =~ s/(\n*)$/\n'''$1/;
			print $text;
			# except for the last, a para always needs a newline
			$$meta{empty_lines} ||= (@$tree ? 1 : 0);
			print "\n"x$$meta{empty_lines};
			next;
		}

		# inline tags
		my $text = _dump($node);
		if ($tag =~ /^head(\d)$/) {
			my $n = 7 - $1;
			print ( ('='x$n)." $text ".('='x$n)."\n" );
		}
		elsif ($tag eq 'image') {
			my $file = $$meta{src};
			my @k = sort grep {$_ !~ /^(src|file)$/} keys %$meta;
			$file .= '?' . join '&', map "$_=$$meta{$_}", @k if @k;
			print '{{'.$file.'}}';
		}
		elsif ($tag eq 'link') {
			my $to = $$meta{to};
			$to =~ s/^mailto:// unless $text =~ /^mailto:/;
			print (
				($to ne $text) ? "[[$to|$text]]" :
				($to !~ /\s/ and $to =~ m#^\w[\w\+\-\.]+://|^(?:mailto:)?\S+\@\S+\.\w+#)
					? $to : "[[$to]]" );
		}
		elsif ($tag eq 'checkbox') {
			my $box = ($$meta{state} == 1) ? '[*]' :
			          ($$meta{state} == 2) ? '[x]' : '[ ]' ;
			print $box;
		}
		# per line markup for remaining tags ...
		elsif ($tag eq 'bold') {
			print map { /\S/ ? "**$_**" : $_} split /(\n)/, $text
		}
		elsif ($tag eq 'italic') {
			print map { /\S/ ? "//$_//" : $_} split /(\n)/, $text
		}
		elsif ($tag eq 'strike') {
			print map { /\S/ ? "~~$_~~" : $_} split /(\n)/, $text
		}
		elsif ($tag eq 'underline') {
			print map { /\S/ ? "__$_\__" : $_} split /(\n)/, $text
		}
		elsif ($tag eq 'verbatim') {
			print map { /\S/ ? "''$_''" : $_} split /(\n)/, $text
		}
		else { die "Unkown tag in wiki parse tree: $tag\n" }
		
		print "\n"x$$meta{empty_lines} if $$meta{empty_lines};
	}
}

sub _dump {
	my $node = shift;
	splice @$node, 0, 2;
	for (@$node) { $_ = _dump($_) if ref $_ }
	return join '', @$node;
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>,
L<Zim::Page>

=cut

