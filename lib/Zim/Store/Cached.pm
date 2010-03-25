package Zim::Store::Cached;

use Moose;
use namespace::autoclean;

extends 'Zim::Store';

use vars qw/$CODESET/;
use POSIX qw(strftime);
use Encode;

use Zim::Utils;

our $VERSION = '0.24';

*CODESET = \$Zim::CODESET;
$CODESET ||= 'utf8';

=head1 NAME

Zim::Store::Cached - A base class for cached storage

=head1 DESCRIPTION

This module implements a base clase for stores which caches
namespace listings, page linking structure and page meta data.

TODO: when scaling issues arise with the current implementation,
the cache should be ported to DBI, using a database to store the cache.
SQLite seems a good candidate as default DBD for this.
The current implementation would then move to a subclass that
serves as fallback when DBI is not available.

=head1 METHODS

=over 4

=item C<new(PARENT, NAMESPACE, DIR)>

Simple constructor. DIR is the root directory of the store.
NAMESPACE is the namespace that maps to that directory.

=cut

# FIXME was init() -- needs refactoring
sub BUILD {
	my $self = shift;
	$self->check_dir;

	my $cache_dir = Zim->get_notebook_cache($$self{dir});
	$self->{cache} = $cache_dir->file('index.cache');
	
	# Check version of cache
	my $line = '';
	if ($self->{cache}->exists) {
		my $fh = $self->{cache}->open();
		$line = <$fh>;
		$fh->close;
	}
	$self->{cache}->write("zim: version $VERSION\n")
		unless $line =~ m/zim: version $VERSION/;
	
	return $self;
}

=item C<list_pages(NAMESPACE)>

=cut

# Directory structure:
#
# a.txt
# a/b.txt
# a/c.txt
# a/c/d.txt
#
# Page structure:
#
# a
# |__ b
# |__ c
#     |_d
#
# Cache:
#
# a: mtime /
# a:b mtime > links
# a:c: mtime /
# a:c: mtime > links
# a:c:d mtime > links

sub list_pages {
	my ($self, $namespace) = @_;
	
	my $dir = $self->page2dir($namespace);
	return () unless -d $dir;

	my $mtime = (stat $dir)[9];
	my ($cache_mtime, @pages);
	my $re = qr/^\Q$namespace\E(?:([^:\s]+:?) \d+ >| (\d+) \/)/;
	for ($self->{cache}->grep($re, 'lines')) {
		$_ =~ $re or next;
		if (defined $1 and length $1) { push @pages, $1 }
		else { # namespace itself - check index time
			$cache_mtime = $2;
			#warn "Found cache mtime $cache_mtime for $namespace (mtime is $mtime)\n";
			return $self->_cache_dir($namespace, $dir)
				unless $cache_mtime == $mtime ;
		}
	}
	#warn "Did not find cache mtime for $namespace\n" unless $cache_mtime;
	return $self->_cache_dir($namespace, $dir) unless $cache_mtime;
	return @pages;
}

sub _flush_cache {
	my $self = shift;
	$self->{cache}->remove if $self->{cache}->exists;
}

sub _cache_dir { # FIXME Can this be optimized ??
	my ($self, $namespace, $dir) = @_;
	warn "# Indexing $namespace\n";
	
	my @pages =
		grep defined($_),
		map {
			my $item = "$dir/$_";
			s/([^[:alnum:]_\.\-\(\)])/sprintf("%%%02X",ord($1))/eg;
			(-d $item)		? [$_.':' => $item] :
			(s/\.$$self{ext}$//)	? [$_ => $item]     : undef ;
		} 
		grep /^[[:alnum:]]/, dir($dir)->list;
	#use Data::Dumper; warn Dumper \@pages;
	
	@pages = sort {lc($$a[0]) cmp lc($$b[0])} @pages;
	for (0 .. $#pages-1) { # cut doubles due to directories
		$pages[$_] = undef if $pages[$_+1][0] eq $pages[$_][0].':' ;
	}
	@pages = grep defined($_), @pages;
	#use Data::Dumper; warn Dumper \@pages;

	my %items = ();
	my $index = '';
	for ($self->{cache}->read) {
		if (/^\Q$namespace\E(?:([^:\s]+:?) \d+ >| (\d+) \/)/) {
			$items{$1} = $_ if defined $1 and length $1;
			#warn "Item: $_\n";
		}
		else { $index .= $_ }
	}
	#use Data::Dumper; warn Dumper \%items;

	$index .= $namespace.' '.(stat $dir)[9]." /\n"; # cache mtime
	for my $p (@pages) {
		my ($name, $file) = @$p;
		#warn "Page: >>$$p[1]<< >>$$p[0]<<\n";
		if (exists $items{$name}) {
			$items{$name} =~ / (\d+) /;
			if ($1 == (stat $file)[9]) {
				$index .= $items{$name};
				next;
			}
		}
		#warn "Indexing page: $namespace$name\n";
		$index .= $self->_cache_string($namespace.$name);
	}
	$self->{cache}->write( $index );
	
	return map {$$_[0]} @pages;
}

sub _cache_page {
	my ($self, $page) = @_;
	my $name = $page->name;
	my ($index, $is_dir);
	for ($self->{cache}->read) {
		if (/^\Q$name\E(:?) \d+ >/) { $is_dir = $1 }
		else { $index .= $_ }
	}
	if ($page->{status} eq 'deleted') {
		$self->{cache}->write($index);
	}
	else {
		$self->{cache}->write($index,
			$self->_cache_string($page, $is_dir));
	}
}

sub _cache_string {
	my ($self, $page, $is_dir) = @_;
	unless (ref $page) {
		$is_dir ||= ($page =~ /:$/);
		$page = $self->get_page($page);
	}
	my $mtime = (stat $page->{source}->path)[9] || '0';
	my @links = eval{ $page->list_links };
	my $key = $page->name;
	$key .= ':' if $is_dir;
	return $key . ' ' . $mtime . ' > ' . join(' ', @links) . "\n" ;
}


=item C<list_backlinks(PAGE)>

Returns a list with names of pages that link to this page.

=cut

sub list_backlinks {
	my ($self, $page) = @_;
	my $name = ref($page) ? $page : $page->name;
	my @links;
	# Used the regex: qr/^:\S+ \d+ >.*?\s\Q$name\E\s/
	# here before, but this can become very slow when utf8 is involved
	# so using two stage grep to make it more scalable
	for ($self->{cache}->grep(qr/\s\Q$name\E(\s|$)/, 'lines')) {
		$_ =~ /^(:\S+) \d+ >/ or next;
		my $l = $1;
		$l =~ s/:$//;
		push @links, $l unless $l eq $name;
	}
	return @links;
}

=item C<resolve_case(\@LINK, \@PAGE)>

=cut

sub resolve_case {
}

sub _match_word {
	my ($self, $page, $word) = @_;
	my $namespace = $page->namespace;
	$word =~ s/[^\w\.\:\-]/_/g;
	my $seen = 0;
	#warn "looking up \"$word\" in $namespace\n";
	my $re = qr/^\Q$namespace\E(?i)\Q$word\E(_|:?\s)/;
	for ($self->{cache}->grep($re)) {
		$_ =~ $re or next;
		if ($1 eq '_') { return 2 }
		elsif ($seen) { return 2 }
		else { $seen = 1 }
	}
	return $seen;
}

1;

__END__

=back

=head1 BUGS

Please mail the author if you find any bugs.

=head1 AUTHOR

Jaap Karssenberg || Pardus [Larus] E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>, L<Zim::Page>

=cut
