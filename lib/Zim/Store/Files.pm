package Zim::Store::Files;

use Moose;
use namespace::autoclean;

extends 'Zim::Store::Cached';

use File::MimeInfo;
use Zim::Utils;

our $VERSION = '0.29';

=head1 NAME

Zim::Store::Files - A file system based store

=head1 DESCRIPTION

This module implements a file system based store for zim.
See L<Zim::Store> for the interface documentation.

=head1 METHODS

=over 4

=item C<new(PARENT, NAMESPACE, DIR)>

Simple constructor. DIR is the root directory of the store.
NAMESPACE is the namespace that maps to that directory.

=cut

# was init(); needs refactoring
sub BUILD {
	my $self = shift;
	$self->check_dir;

	$self->{read_only} = $self->root->{config}{read_only}
	                  || (-w $self->{dir}) ? 0 : 1;
	$self->{format} ||= 'wiki';
	$self->{ext} = ($self->{format} eq 'html')     ? 'html' :
	               ($self->{format} eq 'pod')      ? 'pm'  :
	               ($self->{format} eq 'txt2tags') ? 't2t'  : 'txt' ;
		# FIXME HACK FIXME - this belongs in a Formats.pm
	
    # all BUILD()'s are called in order
	#$self->SUPER::init();
	
	return $self;
}

sub _search { # query is a hash ref with options etc
	my ($self, $query, $callback, $ns) = @_;
	$ns ||= $self->{namespace};
	warn "Searching $ns\n";
	
	my $reg = $$query{regex};
	unless ($reg) {
		$reg = quotemeta $$query{string};
		$reg = "\\b".$reg."\\b" if $$query{word};
		$reg = "(?i)".$reg unless $$query{case};
		$reg = qr/$reg/;
		#warn $reg;
		$$query{regex} = $reg;
	}
	
	for ($self->list_pages($ns)) {
		my $p = $ns.$_;
		my $is_dir = ($p =~ s/:$//);
		my $match = ($p =~ $reg) ? 1 : 0 ;
		$match += $self->page2file($p)->grep($reg, 'count');
		$callback->($match ? [$p, $match] : ());
		$self->_search($query, $callback, $p.':') if $is_dir; # recurs
	}
}

=item C<get_page(PAGE_NAME)>

Returns an object of the type L<Zim::Page>.

=cut

sub get_page {
	my ($self, $name, $source) = @_; # source is a private argument
	$source ||= $self->page2file($name); # case sensitive lookup

	my $page = Zim::Page->new($self, $name);
	$page->set_source($source);
	$page->set_format($self->{format});

	unless ($source->exists) {
		$page->{parse_tree} = $self->_template($page);
		$page->status('new');
	}
	$page->{properties}{read_only} =
		$$self{read_only} || ! $source->writable ;

	return $page;
}

=item C<resolve_case(\@LINK, \@PAGE)>

See L<Zim::Store>.

=cut

sub resolve_case {
	# TODO use the cache for this lookup !
	my ($self, $link, $page) = @_;
	my $match;
	if ($page and @$page) {
		#warn "resolve_case: @$link @ @$page\n";
		my $anchor = shift @$link;
		for (reverse  -1 .. $#$page) {
			my $t = ':'.join(':', @$page[0..$_], $anchor);
			#warn "\ttrying: $t\n";
			my $file = $self->page2file($t, 1) or next;
			#warn "FOUND FILE: $file\n";
			my $dir = $file;
			$dir =~ s/\Q$$self{ext}\E$//;
			next unless -f $file or -d $dir;
			$match = join ':', $t, @$link;
			last;
		}
	}
	else { $match = ':' . join ':', @$link } # absolute

	return undef unless $match;
	my $file = $self->page2file($match, 1);
	return $self->file2page($file);
}

sub _template {
	# FIXME should use Zim::Formats->bootstrap_template()
	my ($self, $page) = @_;
	my $isDate = ("$page" =~ /^:Date:/);
	my $settings = $self->{parent}{history}{GUI}{app}{settings};

	# Name of the template to use
	my $name = $isDate ? '_Date' : '_New' ;
		# FIXME HACK - should use Namespace setting of Calendar
		#              should not hardcode plugin here !

	# Do the template lookup once and cache the resulting template object
	# we can re-use template objects to generate many pages
	my $key = "_template_$name";
	unless (defined $$self{$key}) {
		my $template = Zim::Formats->lookup_template($$self{format}, $name);
		if ($template) {
			require Zim::Template;
			$$self{$key} = Zim::Template->new($template);
		}
		else { $$self{$key} = 0 } # defined FALSE - no template
	}

	# Set template parameter
	my $title = $page->basename;
	if ($settings->{use_ucfirst_title}){
		$title = ucfirst($title) unless $title =~ /[[:upper:]]/;
	}		
	$title =~ s/_/ /g;

	# Hard coded default when no template is defined
	# we do it like this because needs to be syntax independent here
	return ['Page', {%{$page->{properties}}}, ['head1', {}, $title]]
		unless $$self{$key};

	# Process template
	my $text;
	my $data = { page => { title => $title, name => $page->name } };
		# FIXME FIXME FIXME use real page object
	$$self{$key}->process($data => \$text);
	
	# Parse the generated page contents and return parse tree
	my $fh = buffer(\$text)->open('r');
	my $tree = $page->{format}->load_tree($fh, $page);
	close $fh;

	%{$tree->[1]} = (%{$page->{properties}}, %{$tree->[1]});
	return $tree;
}

=item C<copy_page(SOURCE, TARGET, UPDATE_LINKS)>

=cut

sub copy_page {
	my ($self, $old, $new, $update) = @_;
	my $source = $self->page2file($old);
	my $target = $self->page2file($new);
	$source->copy($target);
	@$new{'status', 'parse_tree'} = ('', undef);
	if ($update) {
		my ($from, $to) = ($source->name, $target->name);
		$self->get_page($_)->update_links($from => $to)
			for $source->list_backlinks ;
	}
}

=item C<move_page(SOURCE, TARGET)>

=cut

sub move_page {
	my ($self, $old, $new) = @_;
	
	# Move file
	my $source = $self->page2file($old);
	my $target = $self->page2file($new);

	die "No such page: $source\n" unless $source->exists;
	#warn "Moving $source to $target\n";
	$source->move($target);
	$source->cleanup unless $source->exists;
		# When renaming a file to a different case on file-system
		# that is not case-sensitive source now points to the same
		# file as target - do not delete it !

	# update objects
	@$old{'status', 'parse_tree'} = ('deleted', undef);
	@$new{'status', 'parse_tree'} = ('', undef);
	$self->_cache_page($old);
	$self->_cache_page($new);
}

=item C<delete_page(PAGE)>

=cut

sub delete_page {
	my ($self, $page) = @_;

	my $file = $self->page2file($page);
	$file = $self->page2dir($page) unless $file->exists;
		# border case where empty dir was left for some reason
		# and user tries to delete new page from index
	$file->cleanup;
	
	@$page{'status', 'parse_tree'} = ('deleted', undef) if ref $page;
	$self->_cache_page($page);
}

=item C<search()>

TODO

=cut

sub search {
	my ($self, $page, $query) = @_;
	
}

=back

=head2 Private methods

=over 4

=item C<page2file(PAGE, NOCASE)>

Returns a File object for a page name.

NOCASE is a boolean that triggers a case in-sensitive lookup when true.

=item C<page2dir(PAGE, NOCASE)>

Returns the dir that maps to the namespace below this page.

NOCASE is a boolean that triggers a case in-sensitive lookup when true.

=cut

sub page2file {
	my ($self, $page, $case_tolerant) = @_;
	#warn "Looking up filename for: $page\n";

	if (ref $page) {
		# Page has a file object already
		return $page->{source} if defined $page->{source};
		$page = $page->name;
	}

	# Special case for top level
	if ($page eq $self->{indexpage}) { $page = '_index' }
	else { $page =~ s/^\Q$$self{namespace}\E//i }

	# Split and decode
	my @parts =
		map {s/\%([A-Fa-z0-9]{2})/chr(hex($1))/eg; $_}
		grep length($_), split /:+/, $page;

	# Search file path
	my $file;
	if ($case_tolerant) {
		$file = $$self{dir}->resolve_file($$self{ext}, @parts);
	}
	else {
		$parts[-1] .= '.' . $$self{ext};
		$file = $$self{dir}->file(@parts);
	}
	#warn "\t=> $file\n";

	# Re-bless file object
	my ($no_check, $slow_fs) = @{$self->root->{config}}{'no_fs_check', 'slow_fs'};
	$file = $no_check ? Zim::FS::File->new($file)               :
	        $slow_fs  ? Zim::FS::File::CacheOnWrite->new($file) :
		            Zim::FS::File::CheckOnWrite->new($file) ;
	return $file;
}

sub page2dir {
	my ($self, $page, $case_tolerant) = @_;
	$page = $page->name if ref $page;

	if ($page eq $self->{indexpage}) { return $$self{dir} }
	else { $page =~ s/^\Q$self->{namespace}\E//i }
	my @parts =
		map {s/\%([A-Fa-z0-9]{2})/chr(hex($1))/eg; $_}
		grep length($_), split /:+/, $page;

	return $$self{dir} unless @parts;

	my $dir = $case_tolerant
		? $$self{dir}->resolve_dir($$self{ext}, @parts)
		: $$self{dir}->subdir(@parts) ;

	return $dir;
}

=item C<file2page(FILE)>

Returns the page name corresponding to FILE. FILE does not actually
need to exist and can be a directory as well as a file.

=cut

sub file2page {
	my ($self, $file) = @_;
	#warn "looking up page name for: $file\n";
	$file = Zim::FS->rel_path($file, $$self{dir});
	$file =~ s/.\///;
	my @parts =
		map {s/([^[:alnum:]_\.\-\(\)])/sprintf("%%%02X",ord($1))/eg; $_}
		grep length($_), split /[\/]+/, $file;
	return undef unless @parts;
	$parts[-1] =~ s/\.\Q$$self{ext}\E$//;
	return $self->{indexpage} if $parts[-1] =~ /^_index$/i;
	return $self->{namespace} . join ':', @parts;
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

L<Zim>, L<Zim::Store::Cached>, L<Zim::Page>

=cut
