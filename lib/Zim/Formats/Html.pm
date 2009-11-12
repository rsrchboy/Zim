package Zim::Formats::Html;

use strict;
use Encode;
use File::BaseDir qw/data_files/;
use Zim::Template;
use Zim::Formats;

# Both these are needed for the find_base_dir funtion...
use Gtk2;
use Gtk2::Pango;

our $VERSION = '0.28';
our @ISA = qw/Zim::Formats/;

=head1 NAME

Zim::Formats::Html - Html dumper for zim

=head1 DESCRIPTION

This is a dumper that can be used to export zim wiki pages to html.

=head1 METHODS

=over 4

=item C<save_tree(IO, TREE, PAGE)>

Converts a parse tree into plain text.

=cut

our %entities = (
	'&' => 'amp',
	'<' => 'lt',
	'>' => 'gt',
);
	
sub save_tree { # HACK: template and temp_data are unsupported args
	my ($class, $io, $tree, $page, $template, $temp_data) = @_;
	#use Data::Dumper; warn Dumper $tree;

	$template ||= $page->{store}{_template}
	          ||  Zim::Template->new(\'[% page.body %]');

	my ($title, $heading) = ($page->basename, '');
	if (ref $$tree[2] and $$tree[2][0] =~ /^head/) {
		# FIXME This logic belongs somewhere central
		$title = $$tree[2];
		$$tree[2] = '';
		$title = join '', @$title[2 .. $#$title];
		$heading = $title;
	}
	# else above defaults

	my @path = $page->namespaces;
	my $root = '../' x scalar @path || './';
	$page->{_root_dir} = $root;

	my $data = {
		page => {
			name => $page->name,
			namespace => $page->namespace,
			title => $title,
			heading => $heading,
			is_index => ($page->{_is_index} ? 1 : 0),
			links => sub { [
				map {
					my ($l, $n) = href($page, $_);
					{name => $n, file => $l};
				} sort $page->list_links
			] },
			backlinks => sub { [
				map {
					my ($l, $n) = href($page, $_);
					{name => $n, file => $l};
				} sort $page->list_backlinks
			] },
		},
		prev  => {},
		index => {},
		next  => {},
		notebook => { root => $root },
		zim => { version => $VERSION },
	};
	$data->{page}{body} = sub {
		my (undef, $fh) = @_;
		return unless $fh;
		my $old_fh = select $fh;
		eval {
			$page->{_mode} = lc $data->{mode};
			print qq#<div class="slide">\n# if $page->{_mode} eq 's5';
			$class->_dump_node($tree, $page);
			print qq#</div>\n# if $page->{_mode} eq 's5';
		};
		select $old_fh;
		die $@ if $@;
		return undef; # no caching here
	};
	for (qw/prev next index/) {
		next unless $page->{store}{'_'.$_};
		my $p = $page->{store}{'_'.$_};
		my ($l, $n) = href($page, "$p");
		$data->{$_} = { name => $n, file => $l };
	}
	$data = {%$data, %$temp_data} if $temp_data;

	$template->process($data => $io);
}

sub _dump_node {
	my $class = shift;
	no warnings;
	
	my ($node, $page) = @_;
	my ($name, $opt) = splice @$node, 0, 2;
	
	my @tags;
	if ($name =~ /^head(\d+)/) {
		@tags = _is_rtl($node)
			? ("<h$1 dir='rtl'>", "</h$1>\n")
			: ("<h$1>", "</h$1>\n") ;
	}
	elsif ($name eq 'Para') {
		@tags = _is_rtl($node)
			? ("<p dir='rtl'>\n", "\n</p>\n")
			: ("<p>\n", "\n</p>\n") ;
		if (grep {!ref($_) and /^\s*\x{2022}\s+/m} @$node) {
			# ugly hack ... should not be necessary
			print $tags[0];
			$class->parse_list($page, @$node);
			print $tags[1];
			return;
		}
		elsif ( $page->{_mode} eq 's5'
				and ! ref $$node[0]
				and $$node[0] =~ s/^----+\s+//
		) {
			print qq#</div>\n\n\n<div class="slide">\n#;
			shift @$node unless $$node[0] =~ /\S/;
		}
	}
	elsif ($name eq 'Verbatim' ) { 
		@tags = _is_rtl($node)
			? ("<pre dir='rtl'>\n", "</pre>\n")
			: ("<pre>\n", "</pre>\n") ;
	}
	elsif ($name eq 'bold'     ) { @tags = ('<b>', '</b>')   }
	elsif ($name eq 'italic'   ) { @tags = ('<i>', '</i>')   }
	elsif ($name eq 'underline') { @tags = ('<u>', '</u>')   }
	elsif ($name eq 'strike'   ) { @tags = ('<strike>', '</strike>') }
	elsif ($name eq 'verbatim' ) { @tags = ('<tt>', '</tt>') }
	elsif ($name eq 'link') {
		my ($type, $href) = $page->parse_link($$opt{to});
		if ($type eq 'page') {
			my ($l, $n) = href($page, $href, $$opt{to});
			$href = $l;
			$$node[0] = $n
				if @$node == 1 and $$node[0] eq $$opt{to};
		}
		elsif ($type eq 'file') {
			$href = href_file($page, $$opt{to}, $href);
		}
		warn "#  link: $$opt{to} => $href\n";
		@tags = ("<a href='$href'>", "</a>");
	}
	elsif ($name eq 'image') {
		my $src = href_file($page, @$opt{'src', 'file'});
		my $alt = $src;
		$alt =~ s#.*[/\\]##g;
		@tags = ("<img src='$src' alt='$name' />", '');
	}
	elsif ($name eq 'checkbox') {
		my $icon = 
			($$opt{state} == 1) ? 'checked-box'  :
			($$opt{state} == 2) ? 'xchecked-box' : 'unchecked-box' ;
		my $file = data_files('pixmaps', 'zim', $icon.'.png');
		my $src = href_file($page, $file, $file);
		@tags = ("<img src='$src' width='12' height='12' />", '');
	}
	# else recurs silently

	print $tags[0];
	for (@$node) {
		if (ref $_) { $class->_dump_node($_, $page) } # recurse
		else {
			s#([<>&])#\&$entities{$1}\;#g; # encode
			s#\n#<br />\n#g unless $tags[0] =~ m#<pre>#;
			print $_;
		}
	}
	print $tags[1];
}

sub _is_rtl {
	# walk tree for first piece of text and figure out whether it is ltr
	# or not using Pango function
	my $node = shift;
	my $base = ($#$node > 1 and ref($$node[1] eq 'HASH')) ? 2 : 0;
	for my $i ($base .. $#$node) {
		if (ref $$node[$i]) {
			my $is_ltr = _is_rtl($$node[$i]); # recurs
			return $is_ltr if defined $is_ltr;
		}
		elsif (length $$node[$i]) {
			my $dir = 'ltr'; # default
			eval { $dir = Gtk2::Pango->find_base_dir($$node[$i]) };
				# since Pango 1.4 - dies on gtk 2.4 install
			return $dir eq 'rtl' ? 1 : 0;
		}
	}
	return undef;
}

=item C<href(PAGE, LINK)>

Function that returns both an url and a name for a link.

=item C<href_file(PAGE, HREF, FILE)>

Function that returns a path or url for a file link.
HREF is the (relative) link, FILE is an optional absolute path.

=cut

sub href_file {
	my ($page, $href, $file) = @_;

	if ($href =~ /^\./) { # relative paths most be relative to this file
		$file ||= $page->resolve_file($href);
		$href = Zim::FS->rel_path($file, $$page{source}->dir, 'UP');
	}
	elsif ($href =~ /^\//) { # maybe we use a document root
		$href = $file if defined $file;
	}
	elsif ($href =~ /^\~/) { # html doesn't know about home dir
		$href = $file || Zim::FS->abs_path($href);
	}

	$href = Encode::encode_utf8($href); # turn utf8 flag off
	$href =~ s{ ([^A-Za-z0-9\-\_\.\!\~\*\'\(\)\/\:]) }
	          { sprintf("%%%02X",ord($1))            }egx;
	# url encoding - char set from man uri(7), see relevant rfc
	# added '/' and ':' to char set for readability of uris
	return $href;
}

sub href { # only links to other pages
	my ($page, $href, $name) = @_;
	return ('', $name) unless length $href;
	$name = $href unless defined $name and length $name;
	$name =~ s/_/ /g;

	my $namespace = $page->namespace;
	#print STDERR "page: $href, relative: $namespace => ";
	$href =~ s#^:*#:#;
	unless ($href =~ s#^(\Q$namespace\E):*##) {
		$href =~ s/^:*//;
		$href = $page->{_root_dir}.$href;
	}
	$href =~ s#:+$##;
	$href =~ s#[/:]+#/#g;
	$href .= '.html';
	#print STDERR $href."\n";
	$href = Encode::encode_utf8($href); # turn utf8 flag off
	$href =~ s{ ([^A-Za-z0-9\-\_\.\!\~\*\'\(\)\/\:]) }
	          { sprintf("%%%02X",ord($1))            }egx;
	# url encoding - char set from man uri(7), see relevant rfc
	# added '/' and ':' to char set for readability of uris
	return ($href, $name);
}

sub parse_list {
	# FIXME wrong level for this kind of parsing :(
	# FIXME this logic assumes 1 whitespace is 1 level of indenting
	# this does not work when indenting with space instead of tab
	my $class = shift;
	no warnings;

	my ($page, @nodes) = @_;
	
	my ($level, $close) = (-1, '');
	for (@nodes) {
		if (ref $_) { $class->_dump_node($_, $page) }
		else {
			s#([<>&])#\&$entities{$1}\;#g; # encode
			my @lines = split /[\n\r]+/, $_;
			for (@lines) {
				if ($_ =~ s/^(\s*)\x{2022}\s+//) {
					print $close;
					my $lvl = length $1;
					if ($lvl > $level) {
						print "<ul>\n" for 1 .. $lvl - $level;
					}
					elsif ($lvl < $level) {
						print "</ul>\n" for 1 .. $level - $lvl;
					}
					$level = $lvl;
					print "<li>".$_;
					$close = "</li>\n";
				}
				else { print $_ }
			}
		}
	}
	print $close;
	print "</ul>\n" for 1 .. $level + 1;
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

=cut

