use strict;

my $app = Zim::GUI->current;

# Do not do anything for read-only interface
return 1 if $app->{read_only};

# Register that our module can handle images ("objects") with
# the type set to "diagram", e.g. {{foo.png?type=diagram}}
$Zim::GUI::PageView::OBJECTS{diagram} = 'DiagramEditor';

# Add menu and toolbar items
my $actions = __actions( q{
InsertDiagram	.	Dia_gram...	.	Insert diagram
} );

$app->add_actions($actions);

$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='InsertMenu'>
			<placeholder name='PluginItems'>
				<menuitem action='InsertDiagram'/>
			</placeholder>
		</menu>
	</menubar>
</ui> } );

# Make sure to set item insensitive when page is read-only
$app->signal_connect(t_read_only =>
	sub { $_[0]->actions_set_sensitive(InsertDiagram => !$_[1]) } );

return 1;

# AUTOLOAD the module and show dialog
sub InsertDiagram { $app->DiagramEditor->show }

