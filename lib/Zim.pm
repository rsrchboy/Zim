package Zim;

use strict;
use utf8; # for translator credits

use Carp;
use File::BaseDir 0.03 qw/
	config_home config_files
	data_files data_dirs
	xdg_cache_home
/;
use Zim::Utils;
use Zim::Events;
use Zim::Store;
use Zim::History;
use Zim::Page;

our $VERSION = '0.29';

our @ISA = qw/Zim::Events/;

our $COPYRIGHT = 'Copyright (c) 2005, 2008 Jaap G Karssenberg.';
our $LONG_VERSION = << "EOT";
zim $VERSION - A desktop wiki and outliner

$COPYRIGHT All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Please report bugs to pardus\@cpan.org
EOT
our $AUTHORS = 'Jaap Karssenberg <pardus@cpan.org>';
our $TRANSLATORS = q{
Akihiro Nishimura (ja)
Andrew Kuzminov (ru)
Andrés Rassol (es)
Aron Xu (zh_CN)
BBO (de)
Balaam's Miracle (nl)
Bart (nl)
Bjørn Olav Samdal (nb)
BobMauchin (fr)
Cheese Lee (zh_CN)
Daniel Ribeiro (pt_BR)
Daniel Stoyanov (fr)
Davide Truffa (it)
Etienne Le Belléguy (fr)
Eugene Schava (ru)
Fabian Affolter (de)
Federico Vera (es)
Frederico Gonçalves Guimarães (pt_BR)
Frederik 'Freso' S. Olesen (da)
Frits Salomons (nl)
Gofer (ru)
Gökdeniz Karadağ (tr)
Henry Lee (zh_TW)
Hokey (de)
István Papp (hu)
Jaap Karssenberg (nl)
Jacopo Moronato (it)
Javier Rovegno Campos (es)
Jean DEMARTINI (fr)
Jean Demartini (fr)
Jeppe Toustrup (da)
João Santos (pt)
Juhana Uuttu (fi)
Junnan Wu (zh_CN)
Jérôme Guelfucci (fr)
Katz Kawai (ja)
Klaus Vormweg (de)
Krzysztof Tataradziński (pl)
Lucif (pl)
M. Emin Akşehirli (tr)
Mathijs (nl)
Matteo Ferrabone (it)
Matthew Gadd (en_GB)
Matthias Mailänder (de)
Maxim Kochetkov aka fido_max (ru)
Miguel Anxo Bouzada (gl)
Mikael Mildén (sv)
Nikolaus Klumpp (de)
Nikolay A. Fetisov (ru)
Nucleos (fr)
Oleg Maximov (ru)
Paco Molinero (es)
René 'Necoro' Neumann (de)
Roberto Suarez (gl)
Rui Nibau (fr)
Servilio Afre Puentes (es)
ThiagoSerra (pt_BR)
Tverd (ru)
Vinzenz Vietzke (de)
Vladimir Sharshov (ru)
Vlastimil Ott (cs)
Vyacheslav Kurenyshev (ru)
Wanderson Santiago dos Reis (pt_BR)
X-Ander (ru)
Yaron (he)
ZZYZX (pl)
atany (uk)
cumulus007 (nl)
cyberik (zh_TW)
dotancohen (he)
forget (zh_CN)
kingu (nb)
marisma (gl)
nairobie (sv)
nanker (da)
orz.inc (ja)
paxatouridis (el)
sanya (ru)
warlock24 (pl)
冯超 (zh_CN)
太和 (zh_CN)
};
our $WEBSITE = 'http://zim-wiki.org/';

=head1 NAME

Zim - Application object for the zim desktop wiki

=head1 SYNOPSIS

	use Zim;

	my $repo = Zim->new( dir => $dir );
	my $page = $repo->get_page('Home');

=head1 DESCRIPTION

This class defines the public interface to the document repository
as used by L<zim>(1). It acts as a dispatcher that manages one or
more store objects to handle page requests. It also adds some tests
and thus tries to isolate the stores from errors in the GUI.
These repositories are called "notebooks" in the UI

The interface which child objects should support is defined in
L<Zim::Store>.

=head1 SIGNALS

This following signals are emitted by this object:

=over 4

=item C<config_changed>

Any othe object changing our config should call C<signal_emit> for this
signal in order to notify all other objects.

=back

=head1 METHODS

=head2 Public Methods

The following methods can be used by the GUI.

=over 4

=item new(%PARAM)

Constructor. Parameters can be:

	dir - top leve ldirectory for the notebook
	type - type of the (default) top level store object
	parent - parent object in case we are nested
	namespace - namespace in case we are nested

=cut

sub new {
	my $class = shift;

	my $self = bless {@_}, $class;
	$$self{namespace} ||= ':';
	$$self{namespace} =~ s/:?$/:/;

	# Check notebook source
	if ($$self{file}) {
		my $file = file( delete $$self{file} );
		die "No such file: $file\n" unless $file->exists;
		$$self{dir} ||= $file->dir;
		if ($file =~ /\.gjots$/) {
			$self->add_child(':', 'Gjots', file => $file);
			$$self{config}{no_vcs} = 1;
			$$self{config}{profile} ||= 'reader';
		}
		else { die "File is not part of a notebook: $file\n" }
	}
	elsif ($$self{dir} ) {
		$$self{dir} = dir( $$self{dir} );
		die "No such directory: $$self{dir}\n"
			unless $$self{dir}->exists;
	}
	# else we may have a type of store without dir or file, e.g. ::Man

	# Read config
	$$self{config} ||= {};
	$$self{config_file} = $self->get_notebook_config;
	$$self{config_file}->read($$self{config}, 'Notebook')
		if $$self{config_file};
	print STDERR "WARNING: FS timestamp checks are disabled\n",
	             "concurent editing will overwrite files without warning\n"
		if $$self{config}{no_fs_check} ;

	# Initialize version control
	$$self{vcs} ||= $class->check_version_control($$self{dir})
		if $$self{dir} and not $$self{config}{no_vcs};
		# we use predefined object in test, hence the "||="
	if ($$self{vcs}) {
		my $vcs = ref($$self{vcs});
		$vcs =~ s/.*:://;
		warn "# Version Control System: $vcs\n";
		$$self{dir} = $$self{vcs}->subdir($$self{dir});
		warn "## Dir type: ".ref($$self{dir})."\n";
	}
	else { warn "# Store does not use version control\n" }

	# Setup remaining properties
	$self->signal_connect(config_changed => \&_init_properties, $self);
	$self->_init_properties;

	# Set default store if not defined in config
	my $type = $self->{config}{type} || 'Files';
	$self->add_child(':', $type)
		unless exists  $$self{':'} or
		       defined $$self{config}{Namespaces}{':'};

	# Initialize stores defined in config
	# sort should make sure we start with ":"
	for my $ns (sort keys %{$self->{config}{Namespaces}}) {
		# remove namespace defnitions from config
		# allows lines like ":namespace=Class,key=val,key=val"
		my $val = $self->{config}{Namespaces}{$ns};
		my ($class, $arg) = split ',', $val, 2;
		my %arg = map split('=',$_,2),
		          map split(',',$_), $arg;
		$self->add_child($ns => $class, %arg);
	}

	return $self;
}

sub _init_properties {
	my $self = pop; # pop because are also called from signal
	my $config = $$self{config};
	#use Data::Dumper; warn Dumper $config;

	# we always want a name
	$$self{name} = $$config{name};
	$$self{name} ||= $$self{dir} ? $$self{dir}->path : $$config{type} ;

	# slow fs
	$$self{dir}{slow_fs} = $$config{slow_fs} if $$self{dir};

	# doc root
	my $doc_root = $$config{document_root};
	if (defined $doc_root and $doc_root =~ /\S/) {
		# proper nesting of doc_root for version control etc.
		$doc_root = dir( Zim::FS->abs_path($doc_root, $$self{dir}) );
		my ($parent) = grep { Zim::FS->rel_path($doc_root, $_) }
		               grep defined($_), $$self{dir}, $$self{vcs} ;
		$doc_root = $parent->subdir($doc_root) if defined $parent;
	}
	$$self{document_root} = $doc_root;
}

=item C<add_child(NAMESPACE, CHILD, ...)>

This will connect a new child object to this repository under a certain
namespace. CHILD is a class name implementing the store interface.
The class will be looked for in C<Zim::Store::>.
All remaining arguments will be passed on to the constructor of the object.

=cut

sub add_child {
	my ($self, $namespace, $child, %args) = @_;
	$namespace = Zim::Store->clean_name($namespace); # allow human input
	$namespace .= ':';
	warn "# Adding store of type '$child' at '$namespace'\n";
	_check_namespace($namespace);
	$args{namespace} = $namespace;

	my $class = "Zim::Store::" .
		join('::', map quotemeta($_), split '::', $child);
	eval "use $class ();";
	die "While loading store '$child':\n".$@ if $@;
	my $obj = $class->new(parent => $self, %args);

	$namespace =~ s/:*$//;
		# strip last ":" because we also want the page
		# of the same name as the namespace to resolve to this
		# child, this page is known as the "indexpage"
	$namespace ||= ':';
	$self->{lc($namespace)} = $obj;

	my $ns = $self->{namespace};
	$ns =~ s/:*$//;
	my $regex = join '|', map quotemeta($_),
		sort {length($b) <=> length($a)} grep /^:./, keys %$self;
	$regex = length($regex) ? "(?:$regex)(?![^:])|:" : ':';
	$self->{regex} = qr#^(?i)\Q$ns\E($regex)#;
	#warn "regex: $self->{regex}\n";
}

=item C<init_history()>

Open or initialize the history for this notebook. Returns an object of
class L<Zim::History>.

=cut

sub init_history {
	my $self = shift;
	return $$self{history} if $$self{history};

	my $cache = $self->get_notebook_cache;
	my $hist_file = $cache->file('history.cache');
	my $hist_max = $$self{config}{hist_max} || 15;
	warn "# History file: $hist_file (max $hist_max)\n";

	$$self{history} = Zim::History->new($hist_file, $hist_max, undef);
	return $$self{history};
}

=item C<init_vcs(VCS, \%ARGS)>

Initializes a Version Control System for the top level notebook dir.
VCS is the system you want to use, e.g. 'Bazaar'. Only needs to be called
for notebooks that are not yet under version control.

=cut

sub init_vcs {
	my ($self, $vcs, $args) = @_;
	die "BUG: can not initialize VCS without directoy" unless $$self{dir};

	# Expect this eval to die e.g. when the correct VCS is
	# not installed and can not be used; or e.g. when installed
	# version has version mis-match etc.
	my $class = "Zim::FS::$vcs";
	eval "require $class";
	die $@ if $@;

	my $dir = $$self{dir};
	$vcs = $$self{dir} = $$self{vcs} = $class->init($$self{dir}, $args);
	$self->_init_properties; # will properly nest doc_root

	for my $child (map $$self{$_}, grep /^:/, keys %$self) {
		# make sure all childs use vcs as parent, hope childs
		# do not store derived sub objects elsewhere
		# $dir is the old object, $vcs is the new dir object
		$$child{dir} = $vcs->subdir( $$child{dir}->rel_path )
			if $$child{dir} and $$child{dir}->parent eq $dir;
		$$child{file} = $vcs->subdir( $$child{file}->rel_path )
			if $$child{file} and $$child{file}->parent eq $dir;
	}
}

=item C<save()>

Save config, history, etc. to disk.

=cut

sub save {
	my $self = shift;
	return 0 if $$self{config}{read_only};
	$$self{config_file}->write($$self{config}, 'Notebook')
		if $$self{config_file};
	$self->{history}->write if $self->{history};
	return 1;
}

=item C<root()>

Returns self.

=cut

sub root { return $_[0] }

## 3 methods for checking arguments ##

sub _check_page {
	if (ref $_[0]) {
		croak "Object \"$_[0]\" is not a Zim::Page"
	       		unless $_[0]->isa('Zim::Page');
	}
	elsif ($_[1]) { croak "\"$_[0]\" is not a page object" }
	else { goto \&_check_page_name }
}

# Valid page names can contain letters, numbers and ".", "-", "(" and ")"
# The first character of a name can only be a letter or a number
# Absolute names start with a ":"
# Namespaces end in a ":"

sub _check_page_name {
	croak "\"$_[0]\" is not a valid page name"
		unless $_[0] =~ /^(?::+[\w\%]+[\w\.\-\(\)\%]*)+$/;
}

sub _check_namespace {
	croak "\"$_[0]\" is not a valid namespace"
		unless $_[0] =~ /^(?::+|(?::+[\w\%][\w\.\-\(\)\%]*)+:+)$/;
}

=item C<list_pages(NAMESPACE)>

Lists pages in NAMESPACE. Sub-namespaces have a trailing ':'
in the listing.

If a page is not present in this list that does not mean that it
doesn't exists. This list is used for hierarchical views of the
page structure; not all stores need to support a hierarchical order.

=cut

sub list_pages {
	my ($self, $namespace) = @_;
	$namespace =~ s/:?$/:/;
	_check_namespace($namespace);

	# List stores in this namespace
	my @pages =
		grep { m/^:/ and s/^\Q$namespace\E:*([^:]+:*)$/$1:/ } keys %$self;
	@pages = map { s/.*://; $_ } map $self->{$_}{namespace}, @pages;

	# List pages from the store managing this namespace
	$namespace =~ $self->{regex}
		or die "BUG: '$namespace' !~ qr/$self->{regex}/";
	return if $self->{lc($1)}->{no_show_in_sidepane}; # temp HACK
	@pages = sort @pages, $self->{lc($1)}->list_pages($namespace);

	# remove doubles
	for (0 .. $#pages-1) {
		$pages[$_] = undef if $pages[$_+1] eq $pages[$_];
		$pages[$_] = undef if $pages[$_+1] eq $pages[$_].':';
	}

	return sort {lc($a) cmp lc($b)} grep defined($_), @pages;
}

=item get_page(NAME)

Returns an object of a class inheriting from L<Zim::Page>.
When you ask for a page that doesn't exists yet, you should get a new object.
In case it is not possible to create the page in question C<undef> is returned.

=cut

sub get_page {
	my ($self, $name) = @_;
	_check_page_name($name);
	$name =~ $self->{regex} or die "BUG: '$name' !~ qr/$self->{regex}/";
	#warn "'$name' =~ /$self->{regex}/ => \$1 = '$1'\n";
	#warn "Dispatching get_page('$name') to '".lc($1)."'\n";
	return $self->{lc($1)}->get_page($name);
}

=item C<resolve_page(LINK, PAGE, REFERENCE, NO_DEFAULT)>

Convenience function combining C<resolve_name()> and C<get_page()>.

=cut

sub resolve_page {
	my $self = shift;
	my $name = $self->resolve_name(@_);
	return $name ? $self->get_page($name) : undef ;
}

=item C<resolve_name(LINK, PAGE, REFERENCE, NO_DEFAULT)>

Cleans up NAME but does not actually fetch a page object.

=cut

sub resolve_name {
	my ($self, $name, $ref, $no_def) = @_;
	#warn "!! resolve name: @_\n";
	if ($ref) {
		# TODO check for multiple children in path
		# TODO use child path case for path
		$name = Zim::Store->clean_name($name, 1) or return;
		$ref =~ $self->{regex}
			or die "BUG: '$ref' !~ qr/$self->{regex}/";
		#warn "!! dispatch to: $1\n";
		return $self->{lc($1)}->resolve_name($name, $ref, $no_def);
	}
	else {
		$name = Zim::Store->clean_name($name, 0) or return;
		$name =~ $self->{regex}
			or die "BUG: '$name' !~ qr/$self->{regex}/";
		my $child = $1;
		$name =~ s/^$child/$child/i; # set correct caps
		#warn "!! dispatch to: $1\n";
		return $self->{lc($child)}->resolve_name($name, undef, $no_def);
	}
}

=item C<resolve_namespace(NAME)>

Returns a namespace string. Used to sanitize user input.

=cut

sub resolve_namespace {
	my ($self, $name) = @_;
	$name = Zim::Store->clean_name($name);
	$name .= ':'; 	# is a namespace
	$name =~ $self->{regex} or die "BUG: '$name' !~ qr/$self->{regex}/";
	my $child = $1;
	$name =~ s/^$child/$child/i; # set correct caps
	return $name;
}

=item copy_page(SOURCE, TARGET, UPDATE_LINKS)

Copy page SOURCE to TARGET. Both arguments can be either page names
or objects. Returns the (new) TARGET object. The UPDATE_LINKS argument
is a boolean that tells whether links to this page should be updated
to point to this new name.

=item move_page(SOURCE, TARGET, UPDATE_LINKS)

Move page SOURCE to TARGET. Both arguments can be either page names
or objects. Returns the (new) TARGET object.The UPDATE_LINKS argument
is a boolean that tells whether links to this page should be updated
to point to this new name.

=cut

sub copy_page { _clone('copy_page', @_) }

sub move_page { _clone('move_page', @_) }

sub _clone { # Copy and move are almost the same
	my ($method, $self, $source, $target, $update) = @_;
	_check_page($source);
	_check_page($target);

	$source = $self->get_page($source)
		|| die "Could not open page '$source'\n"
		unless ref $source;
	$target = $self->get_page($target)
		|| die "Could not create page '$target'\n"
	       	unless ref $target;

	die "BUG: You tried to move a page marked as read-only\n"
		if $method eq 'move_page' and $source->{properties}{read_only};
	die "Page '$target' exists\n"
		if $target->exists and ! $target->equals($source);
		# if pages are equal the case can still differ

	if ($source->{store} eq $target->{store}
		and $target->{store} ne $self
	) {
		$source->{store}->$method($source, $target, $update);
	}
	else {
		$target->clone($source, media => 'none');
		if ($update) {
			my ($from, $to) = ($source->name, $target->name);
			$self->get_page($_)->update_links($from => $to)
				for $source->list_backlinks ;
		}
		$source->{store}->delete_page($source)
			if $method eq 'move_page';
	}

	return $target;
}

=item delete_page(PAGE)

Delete PAGE. PAGE can be either a page name or a page object.

=cut

sub delete_page {
	my ($self, $page) = @_;
	_check_page($page);
	$page = $self->get_page($page) unless ref $page;
	die "BUG: You tried to delete a page marked as read-only\n"
		if $page->{properties}{read_only};
	if ($page->{store} eq $self) {
		$page->status('deleted');
	}
	else {
		$page->{store}->delete_page($page);
	}
	return $page;
}

=item C<list_backlinks(PAGE)>

Returns a list of links to this page.

=cut

sub list_backlinks {
	my ($self, $page) = @_;
	_check_page($page);
	my @backlinks;
	for (grep /^:/, keys %$self) {
		push @backlinks, $self->{$_}->list_backlinks($page)
			if $self->{$_}->can('list_backlinks');
	}
	return @backlinks;
}

=item C<search(QUERY, CALLBACK)>

TODO stable api for this using Zim::Selection

Results are given as arguments to CALLBACK in the form C<[PAGE, SCORE]>.

=cut

# We could probably use some kind of "query" object that coordinates searches
# on subsets of pages  and combines backlink lists with other keywords

sub search {
	my ($self, $query, $callback) = @_;
	for (grep /^:/, keys %$self) {
		$self->{$_}->_search($query, $callback)
			if $self->{$_}->can('_search');
	}
}

=item C<interwiki_lookup(KEY, PAGE)>

Returns an url for an interwiki link with interwiki name KEY and page PAGE.
Lookup for names is case in-sensitive.

=cut

our %_urls;

sub interwiki_lookup {
	my ($class, $key, $page) = @_;
	$key = lc $key;
	my $url;
	if (exists $_urls{$key}) { $url = $_urls{$key} }
	else { # file lookup
		# TODO repository specific urls here

		if ($class->get_notebook($key)) {
			# Named zim notebook - put key in url, not actual dir !
			$url = "zim://$key?{NAME}";
		}
		else {
			# lookup interwiki config
			for (data_files(qw/zim urls.list/)) {
				for (file($_)->read) {
					next unless /^\Q$key\E\s+(\S+)/;
					$url = $1;
					last;
				}
			}
		}
	}
	return unless defined $url and length $url;
	$_urls{lc($key)} = $url;

	unless ($url =~ s/{NAME}/$page/) {
		$page =~ s/([^A-Za-z0-9\-_.!~*'()])/
				sprintf("%%%02X", ord($1))/gex;
		$url =~ s/{URL}/$page/ or $url .= $page;
	}

	return $url;
}

####

sub _flush_cache { # TODO TODO good API for this
	my $self = shift;
	for (grep /^:/, keys %$self) {
		$self->{$_}->_flush_cache
			if $self->{$_}->can('_flush_cache');
	}
}

=back

=head2 Document Interface

This interface is used to deal with external documents that belong to the
notebook. Think of these documents as attachments.

See detailed docs in L<Zim::Store>.

=over 4

=item C<document_dir(PAGE)>

Returns the document dir for PAGE or undef.
Returns top level dir if PAGE is undefined.

=cut

sub document_dir {
	my ($self, $page) = @_;
	return $$self{dir} unless $page;
	_check_page($page);
	$page = $self->get_page($page) unless ref $page;
	$$page{store}->document_dir($page);
}

=item C<document_root()>

Returns the document root or undef.

=cut

sub document_root { $_[0]{document_root} }

=item C<store_file(FILE, PAGE)>

Stores FILE in the document dir.

=cut

sub store_file {
	my ($self, $file, $page) = @_;
	return Zim::Store::store_file($self, $file) unless defined $page;
	_check_page($page);
	$page = $self->get_page($page) unless ref $page;
	$$page{store}->store_file($file, $page);
}

=item C<resolve_file(PATH, PAGE)>

Resolve a linked file.

=cut

sub resolve_file {
	my ($self, $file, $page) = @_;
	return Zim::Store::resolve_file($self, $file) unless defined $page;
	_check_page($page);
	$page = $self->get_page($page) unless ref $page;
	$$page{store}->resolve_file($file, $page);
}

=item C<relative_path(PATH, PAGE)>

Returns a relative path for creating links.

=cut

sub relative_path {
	my ($self, $file, $page) = @_;
	return Zim::Store::relative_path($self, $file) unless defined $page;
	_check_page($page);
	$page = $self->get_page($page) unless ref $page;
	$$page{store}->relative_path($file, $page);
}

=back

=head2 Class Methods

These methods can be called as C<< Zim->method(...) >>.

=over 4

=item C<get_notebook_config(DIR)>

Return a config file for the notebook at DIR or undef.

Also can be called as object method on the main notebook object.

=item C<get_notebook_cache(DIR)>

Returns a dir to store e.g. history and other state files.
By default this is either ".zim/" in the notebook directory
or a directory under XDG_CACHE.

Also can be called as object method on the main notebook object.

=cut

sub get_notebook_config {
	my ($class, $dir) = @_;
	$dir = $$class{dir} if ref $class and ! defined $dir;
	return undef unless defined $dir;

	my ($file) = grep {-e $_}
	             map  "$dir/$_", qw/notebook.zim .notebook.zim/;
	$file = "$dir/notebook.zim" unless defined $file;
	return Zim::FS::File::Config->new($file);
}

sub get_notebook_cache {
	my ($class, $dir) = @_;
	unless (defined $dir) {
		return undef unless ref $class; # no OO call
		$dir = $$class{dir};
	}

	$dir = dir($dir) if defined $dir;
		# FIXME if dir is an object already it can have a property
		# "slow_fs" should we check notebook.zim for this property
		# if we get a path ?

	if (!defined $dir or $$dir{slow_fs} or ! $dir->writable) {
		# use cache dir instead of notebook dir
		# logic similar to login in cache_file() in FS.pm
		my $key = $dir ? $dir->path : $$class{name} ;
		return undef unless $key =~ /\w/;
		$key =~ s/[\/\\:]+/_/g; # win32 save
		$key =~ s/^_+|_+$//g;
		return dir(xdg_cache_home(), 'zim', $key);
	}

	my $cache = dir( "$dir/.zim" );
		# do not use subdir here - cache should e.g. not be under VCS
	return $cache if $cache->writable;
}

=item C<is_notebook(DIR)>

Returns true if DIR is the root of a notebook.

=cut

sub is_notebook {
	my ($class, $dir) = @_;
	return $class->get_notebook_config($dir)->exists;
}

=item C<get_notebook(NAME)>

Returns a path for notebook NAME. Special names are:

	_default_	default notebook
	_doc_		help manual

=item C<get_notebook_list()>

Returns a list of array references containing name and path for known notebooks.

=item C<set_notebook_list()>

Save a list of array references containing name and path for known notebooks.

=cut

sub get_notebook {
	my ($class, $name) = @_;

	if ($name eq '_doc_') {
		my $path = data_dirs(qw/zim doc/);
		return dir( $path );
	}

	my ($n, $m);
	my @list = reverse $class->get_notebook_list;
	for (@list) {
		# do lookup both exact and case-insensitive
		if    ($$_[0] eq $name        ) { $n = $$_[1] }
		elsif (lc($$_[0]) eq lc($name)) { $m = $$_[1] }
	}
	$n ||= $m;
	return undef unless $n;

	return $class->get_notebook($n)
		if $name eq '_default_' and $n !~ /[\\\/]/;
		# recurs when default is not a path but a name

	return -f $n ? file($n) : dir($n) ;
}

sub get_notebook_list {
	shift; # class
	my $file = config_files('zim', 'notebooks.list');
	$file ||= config_files('zim', 'repositories.list');
		# backwards compatibility to versions < 0.23
	return () unless defined $file;
	my @notebooks = grep defined($_), map {
		/^((?:\\.|\S)+?)[=\s]+(.+?)\r?\n/
			? [$1 => $2] : undef ;
	} file($file)->read;
		# allow "=" as separator instead of whitespace
		# for backwards compatibility to versions < 0.24
	$$_[0] =~ s/\\([\s\\])/$1/g for @notebooks; # unescape whitespace
	return @notebooks
}

sub set_notebook_list {
	shift; # class
	my @lines = map {
		my ($name, $path) = @$_;
		$name =~ s/([\s\\])/\\$1/g; # escape whitespace
		"$name\t$path\n";
	} @_;
	my $file = config_home('zim', 'notebooks.list');
	file($file)->write(@lines);
}

=item C<check_version_control(DIR)>

Checks if DIR is under one of the supported version control systems and
returns an object for the root dir of the version control repository or undef.

=cut

sub check_version_control {
	my (undef, $dir) = @_;
	my $vcs;

	# We scan for VCS by going trough the path looking for meta directories.
	# An alternative would be to call the actual binaries and let them
	# figure it out (most VCS will do such a path scan themselves).
	# However that would require one or more external processes with a
	# potential performance hit at startup.
	my $path;
	my @path = split '/', $dir;
	while (@path) {
		$path = join '/', @path;
		if    (-d "$path/.bzr") { $vcs = 'Bazaar' }
		elsif (-d "$path/.svn") { $vcs = 'Subversion' }
		# Here should go tests for other systems
		last if $vcs;
		pop @path;
	}
	eval {
		# Expect this eval to die e.g. when the correct VCS is
		# not installed and can not be used; or e.g. when installed
		# version has version mis-match etc.
		my $class = "Zim::FS::$vcs";
		eval "require $class";
		die $@ if $@;
		$vcs = $class->new($path);
	} if $vcs;
	warn $@ if $@;
	return ref($vcs) ? $vcs : undef;
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

L<zim(1)>,
L<Zim::Store>

=cut
