use strict;
use Zim::Utils;

# This file gives a template for a simple plugin
# that adds just one function to the Tools menu.

=head1 NAME

[name of this plugin]

=head1 DESCRIPTION

[Description of functionality provided by this plugin]

=head1 ABOUT

[Name of this plugin] - [Version number]

[Name and email of the author]

Copyright (c) [year(s)] [Name author(s)]. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

# get main application object
my $app  = Zim::GUI->current;

# define action attributes (translatable !),
# separate by TAB, use "." for undefined
my $actions = __actions( 
# name		icon name	menu label	key binding	tooltip
q{
MyAction	gtk-open	My Action	.	Execute my action
} );

# add actions to interface
$app->add_actions($actions);

# add actions to the menu layout
# see source of Zim::GUI for complete menu structure
$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='ToolsMenu'>
			<menuitem action='MyAction'/>
		</menu>
	</menubar>
</ui> } );

return 1;

# callbacks for the actions go below, method name should be the same as
# the action name

=head1 ACTIONS

=over 4

=item C<MyAction()>

[Some description of what this method does]

=cut

sub MyAction {
	print "Some action triggered !\n";
}

=back

=cut

