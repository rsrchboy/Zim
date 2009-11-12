package Zim::Formats::Txt2tags;

use strict;
use Encode;
use POSIX qw(strftime);
use Zim::Template;
use Zim::Formats;

our $VERSION = '0.24';
our @ISA = qw/Zim::Formats/;

=head1 NAME

Zim::Formats::Txt2tags - Txt2tags dumper for zim

=head1 DESCRIPTION

This is a dumper that can be used to export zim wiki pages to the
txt2tags format - see L<http://txt2tags.sourceforge.net/>.

=head1 METHODS

=over 4

=item C<save_tree(IO, TREE, PAGE)>

Converts a parse tree into plain text.

=cut

sub save_tree {
	my ($class, $io, $tree, $page) = @_;

	my $template = $page->{store}{_template};
	$template = length($template)
		? Zim::Template->new($template)
		: Zim::Template->new(\"[% page.body %]")
		unless ref $template ;

	my (undef, $heading) = Zim::Formats->get_first_head($tree);
	my $title = length($heading) ? $heading : $page->basename;

	Zim::Formats->update_heads($tree, 1, 3); # max header level 3 in t2t

	my @path = $page->namespaces;
	my $root = '../' x scalar @path || './';
	$page->{_root_dir} = $root;

	my $data = {
		page => {
			name => '',
			namespace => '',
			title => $title,
			heading => $heading,
			links => sub {
				[ map { {name => $_, file => _href($page, $_)} }
					sort $page->list_links ]
			},
			backlinks => sub {
				return [ map { {name => $_, file => _href($page, $_)} }
					sort $page->list_backlinks ] ;
			},
		},
		prev => {},
		next => {},
		notebook => { root => $root },
		zim => { version => $VERSION },
		user => $page->{store}{user_name},
		date => strftime('%Y-%m-%d', localtime),
	};
	$data->{page}{body} = sub {
		my (undef, $fh) = @_;
		return unless $fh;
		my $old_fh = select $fh;
		eval { _dump_node($tree, $page) };
		select $old_fh;
		die $@ if $@;
		return undef; # no caching here
	};
	if ($page->{store}{_prev}) {
		my $prev = $page->{store}{_prev}->name;
		$data->{prev} = {
			name => $prev,
			file => _href($page, $prev),
		};
	}
	if ($page->{store}{_next}) {
		my $next = $page->{store}{_next};
		$data->{next} = {
			name => $next,
			file => _href($page, $next),
		};
	}

	$template->process($data => $io);
}

sub _dump_node {
	no warnings;
	
	my ($node, $page) = @_;
	my ($name, $opt) = splice @$node, 0, 2;
	
	my @tags = ('', '');
	if ($name =~ /^head(\d+)/) { @tags = ( ('='x$1).' ', ' '.('='x$1)."\n") }
	elsif ($name eq 'Para') {
		@tags = ('', "\n\n");
		if (! ref $$node[0] and $$node[0] =~ /^\s*[\*\x{2022}]\s+/m) {
			# ugly hack ... should not be necessary
			parse_list($page, @$node);
			@$node = ();
		}
	}
	elsif ($name eq 'Verbatim' ) {  @tags = ("\n```\n", "```\n\n") }
	elsif ($name eq 'bold'     ) { @tags = ('**', '**')   }
	elsif ($name eq 'italic'   ) { @tags = ('//', '//')   }
	elsif ($name eq 'underline') { @tags = ('__', '__')   }
	elsif ($name eq 'strike'   ) { @tags = ('~~', '~~') }
	elsif ($name eq 'verbatim' ) { @tags = ('``', '``') }
	elsif ($name eq 'link') {
		my ($type, $href) = $page->parse_link($$opt{to});
		if ($type eq 'page') {
			$href = _href($page, $href);
		}
		print STDERR "  link: $$opt{to} => $href\n";
		@tags = ('[', " $href]");
	}
	elsif ($name eq 'image') {
		@tags = ("[$$opt{src}]", '');
	}
	# else recurs silently

	print $tags[0];
	for (@$node) {
		if (ref $_) { _dump_node($_, $page) } # recurse
		else { print $_ }
	}
	print $tags[1];
}

sub _href {
	my ($page, $href) = @_;
	return '' unless length $href;
	my $namespace = $page->namespace;
	#print STDERR "page: $href, relative: $namespace => ";
	$href =~ s#^:*#:#;
	unless ($href =~ s#^(\Q$namespace\E):*##) {
		$href =~ s/^:*//;
		$href = $page->{_root_dir}.$href;
	}
	$href =~ s#:+$##;
	$href =~ s#[/:]+#/#g;
	$href .= '.t2t';
	#print STDERR $href."\n";
#	$href = Encode::encode_utf8($href); # turn utf8 flag off
#	$href =~ s#([^a-zA-Z0-9/\.])#sprintf '%%%02x', ord $1#eg; # url encoding
	return $href;
}

sub parse_list { # FIXME totally wrong level for this kind of parsing :(
	no warnings;

	my ($page, @nodes) = @_;
	
	print "\n";
	my $level;
	for (@nodes) {
		if (ref $_) { _dump_node($_, $page) }
		else {
			my @lines = split /[\n\r]+/, $_;
			for (@lines) {
				$_ =~ s/^(\s*)[\*\x{2022}]\s+/$1- /;
				print $_, "\n";
			}
		}
	}
	print "\n";
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

