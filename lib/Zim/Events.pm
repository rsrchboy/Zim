package Zim::Events;

use Moose::Role;
use namespace::autoclean;

our $VERSION = '0.26';

=head1 NAME

Zim::Events - Simple event dispatching

=head1 DESCRIPTION

This is a L<Moose::Role> that adds a few routines to mimic Gtk style event
dispatching for objects that do not inherit from a GObject.

Since we use Perl there is no need to define events types etc. Calling
C<signal_connect()> will create a new event if the event did not yet exist.
Calling C<signal_emit()> or C<signal_dispatch()> for a non-existing event
will be ignored silently.

Although not enforced it is good practise to always emit or dispatch events
with the same number of arguments. That way any code connecting with extra
DATA arguments can function properly without to much hassle. Handlers are
called like object methods with a reference to the object as first argument.

=head1 METHODS

=over 4

=item C<signal_connect(NAME, CODE, @DATA)>

Connect a handler for a signal. CODE will be called when either
C<signal_emit()> or C<signal_dispatch()> is called. DATA are arguments that
will be passed to the handler after the default arguments for this signal.

=cut

sub signal_connect {
	my ($self, $signal, $code, @data) = @_;
	$self->{_signals}{$signal} ||= [];
	push @{$self->{_signals}{$signal}}, [$code, @data];
}

=item C<signal_emit(NAME, @ARGS)>

Call all handlers that are conneccted to this signal. Returns a list
with return values. ARGS are passed to the handler routines.

=cut

sub signal_emit {
	my ($self, $signal, @args) = @_;
	warn "## emit $signal: @args (".ref($self).")\n";
	return undef unless exists $self->{_signals}{$signal};
	my @r;
	for my $handler (grep defined($_), @{$self->{_signals}{$signal}}) {
		my ($code, @data) = @$handler;
		push @r, eval { $code->($self, @args, @data) };
		warn if $@;
	}
	return @r;
}

=item C<signal_dispatch(NAME, @ARGS)>

Like C<signal_emit()>, but stops after the first handler that does not
return FALSE and returns that value. Used for example for GUI actions that 
can be overloaded from a plugin by connecting a like named signal.

This method does not have a Gtk equivalent; in Gtk the event accumulator type 
is used to get this behavior for certain events. Reason to have this method 
instead of an event property is that we do not want to predefine all GUI 
actions as events. And neither do we want plugins to do this for each signal 
they overload. By determining this behavior at call time for signals that 
may or may not exist we keep things simple and Perlish.

=cut

sub signal_dispatch {
	my ($self, $signal, @args) = @_;
	warn "## dispatch $signal: @args (".ref($self).")\n";
	return undef unless exists $self->{_signals}{$signal};
	for my $handler (grep defined($_), @{$self->{_signals}{$signal}}) {
		my ($code, @data) = @$handler;
		my $r = eval { $code->($self, @args, @data) };
		warn if $@;
		return $r if $r;
	}
	return undef;
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006, 2008 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Zim>

=cut

