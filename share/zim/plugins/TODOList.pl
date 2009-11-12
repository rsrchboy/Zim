use strict;
use Zim::Utils;

my $app = Zim::GUI->current;

my $toggle_actions = __actions( q{
TTODOList	stock_todo	_TODO List...	.	Open TODO List
} );

$app->add_actions($toggle_actions, 'TOGGLE');

$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='ViewMenu'>
			<placeholder name='PluginItems'>
				<menuitem action='TTODOList'/>
			</placeholder>
		</menu>
	</menubar>
	<toolbar name='ToolBar'>
		<placeholder name='Tools'>
			<toolitem action='TTODOList'/>
		</placeholder>
	</toolbar>
</ui> } );

return 1;

sub TTODOList {
	my ($self, $show) = @_;
	my $l = $self->TODOListDialog;
		# autoloads Zim::GUI::TODOListDialog
	my $show = $l->visible ? 0 : 1 unless defined $show;
	$show ? $l->show : $l->hide ;
}

