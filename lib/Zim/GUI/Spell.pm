package Zim::GUI::Spell;

use strict;
use Gtk2;
use Gtk2::Spell;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.24';

our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI::Spell - Wrapper for Gtk2::Spell

=head1 DESCRIPTION

This module is a wrapper for the L<Gtk2::Spell> object when this is used
by zim. It takes care of showing the proper menu items etc.

=head1 METHODS

=over 4

=cut

my $ui_toggle_actions = __actions(
# name	stock id	label			accelerator	tooltip
q{
TSpell	gtk-spell-check	Check _spelling		F7		Spell check
} );

my $ui_layout = q{<ui>
	<menubar name='MenuBar'>
		<menu action='ToolsMenu'>
			<placeholder name='PageTools'>
				<menuitem action='TSpell'/>
			</placeholder>
		</menu>
	</menubar>
	<toolbar name='ToolBar'>
		<placeholder name='Tools'>
			<toolitem action='TSpell'/>
		</placeholder>
	</toolbar>
</ui>};

=item C<new(app => PARENT)>

Simple constructor

=item C<init()>

Method called by the constructor.

=cut

sub init {
	my $self = shift;
	$self->{show} = 0;
	$self->{object} = undef;
	$self->add_actions($ui_toggle_actions, 'TOGGLE');
	$self->add_ui($ui_layout);
	$self->actions_set_active(
		TSpell => $self->{app}{state}{show_spell} );
	$self->init_settings('Spell Plugin', {Language => ''});
}

=item C<TSpell()>

Toggle spell checking on/off.

=cut

sub TSpell {
	my $self = shift;
	$self->{show} = $self->{show} ? 0 : 1;
	$self->{show} ? $self->attach : $self->detach;
	$self->{app}{state}{show_spell} = $self->{show};
	#$self->actions_show_active(TSpell => $self->{show});
}

=item C<attach(TEXTVIEW)>

This method attaches the spell checker to a L<Gtk2::TextView> object.
Since it can only be attached to one object at a time it detaches from
any previously attached view.

=cut

sub attach {
	my ($self, $textview) = @_;
	$self->{object}->detach if $self->{object};
	
	if ($textview) { $self->{textview} = $textview }
	else           { $textview = $self->{textview} }
	
	#warn "Attaching Gtk2::Spell to $textview if $self->{show}\n";
	return unless $textview and $self->{show};

	eval {
		my $lang = $self->{settings}{Language};
		$self->{object} = Gtk2::Spell->new_attach($textview);
		$self->{object}->set_language($lang) if length $lang;
		$self->{object}->recheck_all;
	};
	if ($@) { # Catch errors with dictionaries etc.
		my $str = $@;
		$str =~ s/\s+at\s+.*$//;
		$self->{app}->error_dialog($str, $@);
		$self->{app}->unplug('Spell');
	}
}

=item C<detach(TEXTVIEW)>

Detaches C<Gtk2::Spell> object from the TextView object. It is recommended to do this
before changing the TextBuffer underneath the TextView.

=cut

sub detach {
	my ($self, $textview) = @_;
	
	return if $textview and $textview ne $self->{textview};
	
	$self->{object}->detach if $self->{object};
	$self->{object} = undef;
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

