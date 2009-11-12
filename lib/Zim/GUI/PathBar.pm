package Zim::GUI::PathBar;

use strict;
use vars '$AUTOLOAD';
use Gtk2;
use Gtk2::Ex::PathBar; # custom widget
use Zim::Utils;

our $VERSION = '0.27';

=head1 NAME

Zim::GUI::PathBar - Path bar widgets

=head1 DESCRIPTION

This module contains the widgets to display a path bar.
This bar can either show the browsing history or the namespace of
the current page.

=head1 METHODS

Undefined methods are AUTOLOADED to the Gtk2::Ex::PathBar object.

=over 4

=item C<new(app => PARENT)>

Simple constructor.

=item C<init()>

Method called by the constructor.

=cut

sub new {
	my $class = shift;
	my $self = bless {@_}, $class;
	$self->init();
	return $self;
}

sub init { # called by new()
	my $self = shift;
	$self->{path_bar} = Gtk2::Ex::PathBar->new(spacing => 3);
	$self->{path_bar}->hide_sliders(1); # FIXME make this configable
	$self->{path_bar}->signal_connect_swapped(
		path_clicked => \&on_path_clicked, $self);
	$self->{app}->signal_connect('page_loaded' => \&update, $self);
	$self->{app}->signal_connect('page_deleted' => \&update, $self);
}

sub AUTOLOAD {
	my $self = shift;
	$AUTOLOAD =~ s/^.*:://;
	return if $AUTOLOAD eq 'DESTROY';
	return $self->{path_bar}->$AUTOLOAD(@_);
}

=item C<widget()>

Returns the root widget. This should be used to add the object to a container widget.
Also use this widget for things like show_all() and hide_all().

=cut

sub widget { return $_[0]->{path_bar} }

=item C<set_type(TYPE)>

Set the type of the pathbar.
Type can be 'history', 'recent' or 'namespace'.

=cut

sub set_type {
	$_[0]->{type} = $_[1];
	$_[0]->{path_loaded} = '';
	$_[0]->update;
}

=item C<update()>

Update the path displayed. Should be called when the current page changes.

=cut

sub update {
	my $self = pop;
	return unless $self->{app}{page}; # just to be sure
	if ($self->{type} eq 'namespace') {
		$self->_load_namespace;
	}
	elsif ($self->{type} eq 'recent') {
		$self->_load_recent;
	}
	elsif ($self->{type} eq 'history') {
		$self->_load_history;
	}
	# else hidden, ignoring
}

sub _load_namespace {
	my $self = shift;
	my $namespace = $self->{app}{history}
		? $self->{app}{history}->get_namespace()
		: $self->{app}{page}->namespace ;
	$namespace =~ s/^:+|:+$//g;
	my @namespace = split /:+/, $namespace;
	my $current = $self->{app}->{page}->name;
	$current =~ s/^:+|:+$//g;
	my @current = split /:+/, $current;
	
	if ($self->{path_loaded} =~ /^\Q$namespace\E/i) {
		$self->{path_bar}->select_item($#current);
		return;
	}
	
	s/_/ /g for @namespace;
	$self->{path_loaded} = $namespace;
	$self->{path_bar}->set_path(@namespace);
	$self->{path_bar}->select_item($#current);
	
	my $tooltips = Gtk2::Tooltips->new();
	for ($self->{path_bar}->get_items()) {
		my $name = ':'.join(':', @{$_->{path_data}}) ;
		$tooltips->set_tip($_, $name);
	}

}

sub _load_history {
	my $self = shift;
	return unless $self->{app}{history};

	my ($i, @hist) = $self->{app}{history}->get_history;
	my (@path, @names);
	for (@hist) {
		my $basename = $_->{basename};
		$basename =~ s/_/ /g;
		push @path, [$basename];
		push @names, $_->{name};
	}

	my $string = join '/', @names;
	if ($self->{path_loaded} eq $string) {
		$self->{path_bar}->select_item($i);
		return;
	}
	$self->{path_loaded} = $string;
	
	$self->{path_bar}->set_path(@path);
	$self->{path_bar}->select_item($i);

	my $tooltips = Gtk2::Tooltips->new();
	for ($self->{path_bar}->get_items) {
		my $name = shift @names;
		$tooltips->set_tip($_, $name);
	}
}

sub _load_recent {
	my $self = shift;
	return unless $self->{app}{history};
	
	my ($i, @recent) = $self->{app}{history}->get_recent;
	
	my $string = join '/', map $_->{name}, @recent;
	if ($self->{path_loaded} eq $string) {
		$self->{path_bar}->select_item($i);
		return;
	}
	$self->{path_loaded} = $string;

	my @path = map {
		my $basename = $_->{basename};
		$basename =~ s/_/ /g;
		[$basename, $_->{name}]
	} @recent;

	$self->{path_bar}->set_path(@path);
	$self->{path_bar}->select_item($i);

	my $tooltips = Gtk2::Tooltips->new();
	for ($self->{path_bar}->get_items) {
		my (undef, $name) = @{shift @path};
		$tooltips->set_tip($_, $name);
	}
}

sub on_path_clicked {
	my ($self, $path, $idx, $path_bar) = @_;
	if ($self->{type} eq 'namespace') {
		my $name = join ':', '', @$path;
		$name =~ s/ /_/g;
		$self->{app}->load_page($name);
	}
	elsif ($self->{type} eq 'history') {
		my $back = $self->{app}{history}->get_state->{back};
		$idx -= $back;
		if    ($idx < 0) { $self->{app}->GoBack(-$idx)   }
		elsif ($idx > 0) { $self->{app}->GoForward($idx) }
		else             { $self->{app}->Reload()        }
	}
	elsif ($self->{type} eq 'recent') {
		my ($name) = @$path;
		my $rec = $self->{app}{history}->jump($name);
		$self->{app}->load_page($rec);
	}
	# else bug
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

