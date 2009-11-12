package Zim::History;

use strict;
use Zim::Utils;
use Zim::Page;

our $VERSION = '0.20';

=head1 NAME

Zim::History - History object for zim

=head1 SYNOPSIS

	use Zim::History;
	
	my $hist = Zim::History->new($HIST_FILE, $PAGEVIEW, $MAX_HIST);
	my $page_record = $hist->get_current;

=head1 DESCRIPTION

This object manages zim's page history. It keeps tree different stacks: one for
the history, one for recently opened pages and one for the namespace.

The history stack is just the chronological order in which pages were opened.

The recent pages stack is derived from the history stack but avoids
all redundancy.

The namespace stack keeps track of the namespaces you opened.

=head1 METHODS

=over 4

=item C<new(FILE, MAX, GUI)>

Constructor. Takes the name of the cache file as an argument
and reads this cache file. MAX history records are stored in FILE.

The third argument is the GUI object.
When a new record is made for the current page the C<get_state()> method is
called on this object to get state information that needs to be saved.

=cut

# We use two stacks here called "hist" and "recent"
# both contain the same kind of records (hashes with state data for each page)
# To keep everything in sync we want only one record per page
# which is linked by reference one or more times.


sub new {
	my ($class, $file, $max, $gui) = @_;
	$file = file($file) if defined $file;
	my $self = bless {
		file   => $file,
		max    => $max,
		GUI    => $gui,
		point  => 0,
		hist   => [],
		recent => [],
	}, $class;
	$self->read;
	return $self;
}

=item C<set_GUI(GUI)>

Set GUI object.

=cut

sub set_GUI { $_[0]{GUI} = $_[1] }

=item C<read>

Read the cache file.

=cut

sub read {
	# FIXME hard-coded property name
	# FIXME more elegant storage model
	my $self = shift;
	return unless $self->{file} and $self->{file}->exists;
	my $fh = $self->{file}->open('r') or return;
	<$fh> =~ /^zim: version $VERSION$/ or return;
	<$fh> =~ /^point: (\d+)$/ or return;
	$self->{point} = $1;
	<$fh> =~ /^hist: (\d+)$/ or return;
	my $h = $1;
	my %seen;
	my $i = 0;
	while (<$fh>) { # read hist
		/^(\S+)\t(\d+)$/ or last;
		my $rec = $seen{$1} || {name => $1, state => {cursor => $2}};
		@$rec{'namespace', 'basename'}
			= Zim::Page->split_name($$rec{name});
		push @{$self->{hist}}, $rec;
		$seen{$$rec{name}} = $rec;
		last if ++$i >= $h; # h == scalar @hist
	}
	while (<$fh>) { # read recent
		/^(\S+)\t(\d+)$/ or last;
		my $rec = $seen{$1} || {name => $1, state => {cursor => $2}};
		@$rec{'namespace', 'basename'}
			= Zim::Page->split_name($$rec{name});
		push @{$self->{recent}}, $rec;
		$seen{$$rec{name}} = $rec;
	}
	$fh->close;
	$self->{current} = $self->{hist}[ $self->{point} ];
	#use Data::Dumper; warn "Seen: ", Dumper \%seen;
}

=item C<write>

Write the cache file.

=cut

sub write {
	my $self = shift;
	$self->_save_state;
	# FIXME hard-coded property name
	# FIXME more elegant storage model
	return unless $self->{file};
	$$_{state}{cursor} ||= 0 for @{$$self{hist}}, @{$$self{recent}};
	$self->{file}->write(
		"zim: version $VERSION\n",
		"point: $$self{point}\n",
		"hist: ".scalar(@{$$self{hist}})."\n",
		map "$$_{name}\t$$_{state}{cursor}\n",
			@{$$self{hist}}, @{$$self{recent}}
	);
}

sub _save_state {
	$_[0]{current}{state} = $_[0]{GUI}->get_state() if $_[0]{GUI};
}

=item C<set_current(PAGE)>

Give the page object that is going to be displayed in the 
GUI. Set a new current before updating the GUI so the
History object has time to save the state of the GUI.
Returns the history record of the page.

=cut

sub set_current { # from_hist is an private arg
	no warnings;
	my ($self, $name, $from_hist) = @_;
	$name = ref $name ? $name->name : $name;
	$self->_save_state; # even if redundant, sync state
	return $self->{current}
		if $self->{current} and $name eq $self->{current}{name};
		# directly redundant

	# lookup record, or create new record
	my $rec = $self->get_record($name) || { name => $name };
	@$rec{'namespace', 'basename'} = Zim::Page->split_name($name);
	my $prev = $self->{current};
	$self->{current} = $rec;
	
	# update hist stack
	my $point = $self->{point};
	my $hist = $self->{hist};
	if    ($point >= $self->{max}) { shift @$hist }
	elsif (defined $$hist[$point]) { $point++     }
	splice @$hist, $point; # clear forw stack
	$$hist[$point] = $rec;
	$self->{point} = $point;

	$self->_set_recent($from_hist || 0);

	return $rec;
}

sub _set_recent {
	# update recent stack to reflect the current page
	# stuff may have been deleted (fro example because the page was deleted)
	# while the page still is in the history, so check all possibilities
	my ($self, $from_hist) = @_;
	my $recent = $self->{recent};
	my $name = $self->{current}{name};
	if ($from_hist) { # from back / forw / jump
		return if grep {$_->{name} eq $name} @$recent;
		# return if exists
	}
	else {
		@$recent = grep {$_->{name} ne $name} @$recent;
		# remove redundancy
	}
	shift @$recent if $#$recent >= $self->{max};
	push @$recent, $self->{current};
}

=item C<get_current()>

Returns the current history object.

=cut

sub get_current { return $_[0]->{current} }

=item C<delete_recent(PAGE)>

Deletes the entry for PAGE from the recent pages stack.

=cut

sub delete_recent {
	my ($self, $name) = @_;
	#warn "Deleting $name from recent\n";
	@{$self->{recent}} = grep {$_->{name} ne $name} @{$self->{recent}};
}

=item C<back(INT)>

Go back one or more steps in the history stack.
Returns the record for this step or undef on failure.

=cut

sub back {
	my ($self, $i) = @_;
	return if $i < 1 or $i > $self->{point};
	$self->_save_state;
	$self->{point} -= $i;
	$self->{current} = $self->{hist}[ $self->{point} ];
	$self->_set_recent(1);
	return $self->{current};
}

=item C<forw(INT)>

Go forward one or more steps in the history stack.
Returns the record for this step or undef on failure.

=cut

sub forw {
	my ($self, $i) = @_;
	my $forw = $#{$self->{hist}} - $self->{point};
	return if $i < 1 or $i > $forw;
	$self->_save_state;
	$self->{point} += $i;
	$self->{current} = $self->{hist}[ $self->{point} ];
	$self->_set_recent(1);
	return $self->{current};
}

=item C<jump(NAME)>

Go to page NAME in the history stack.

=cut

sub jump {
	my ($self, $name) = @_;
	$name = $name->name if ref $name;
	$self->_save_state;
	return $self->{current}
		if $self->{current} and $self->{current}{name} eq $name;

	my ($i) = grep {$self->{hist}[$_]{name} eq $name} 0 .. $#{$self->{hist}};
	return $self->set_current($name, 1) unless defined $i;
	$self->{point} = $i;
	$self->{current} = $self->{hist}[ $self->{point} ];
	$self->_set_recent(1);
	return $self->{current};
}

=item C<get_history()>

Returns an integer followed by a list of all records in the history stack.
The integer is the index of the current page in this stack.

=cut

sub get_history {
	my $self = shift;
	return $self->{point}, @{$self->{hist}};
}

=item C<get_recent()>

Returns an integer followed by a list of all records in the recent pages stack.
The integer is the index of the current page in this stack.

=cut

sub get_recent {
	my $self = shift;
	my $ref = $self->{current};
	my $i = 0;
	for (@{$self->{recent}}) {
		last if $_ eq $ref;
		$i++;
	}
	return $i, @{$self->{recent}};
}

=item C<get_namespace>

This method matches the namespace of the current page to that of pages in the
history. The result can be used as a namespace stack.

=cut

sub get_namespace {
	my $self = shift;
	my $current = $self->{current};
	return unless $current;

	my $namespace = $current->{name};
	#print STDERR "looking for namespace $namespace";
	my $l = length $namespace;
	for (
		reverse(0 .. $self->{point}-1),
		reverse($self->{point} .. $#{$self->{hist}})
	) {
		my $rec = $self->{hist}[$_];
		my $name = $$rec{_namespace} || $$rec{name};
		if (substr($name,0,$l+1) eq $namespace.':') {
			$namespace = $name;
			$l = length $namespace;
		}
	}
	#print STDERR " => $namespace\n";
	$current->{_namespace} = $namespace;

	return $namespace;
}

=item C<get_state()>

Returns a hash ref which contains numbers that tell how many items there are on
the history and namespace stacks in either direction.

=cut

sub get_state {
	my $self = shift;
	my $state = {
		back => $self->{point},
		forw => ($#{$self->{hist}} - $self->{point}),
		up   => 0, # FIXME
		down => 0, # FIXME
	};
	return $state;
}

=item C<get_record(PAGE)>

Returns the history record for a given page object or undef.

=cut

sub get_record {
	no warnings;
	my ($self, $page) = @_;
	
	my $name = ref($page) ? $page->name : $page;
	$name =~ s/:+$//;
	
	return $self->{current}
		if $self->{current}{name} eq $name;

	#print STDERR "get_record $name\n";
	for (@{$self->{hist}}, @{$self->{recent}}) {
		#print STDERR "\tfound $_->{name}\n";
		return $_ if $_->{name} eq $name;
	}

	return undef;
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

