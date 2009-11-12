use strict;
use Zim::Utils;

my $app = Zim::GUI->current;

my $actions = __actions( q{
GoToday		.		To_day		<alt>D		Today
} );

my $toggle_actions = __actions( q{
TCalendar	stock_calendar-view-month	Calen_dar	.	Show calendar
} );

$app->add_actions($actions);
$app->add_actions($toggle_actions, 'TOGGLE');

$app->add_ui( q{
<ui>
<menubar name='MenuBar'>
	<menu action='ViewMenu'>
		<placeholder name='PluginItems'>
			<menuitem action='TCalendar'/>
		</placeholder>
	</menu>
	<menu action='GoMenu'>
		<placeholder name='PluginItems'>
			<menuitem action='GoToday'/>
		</placeholder>
	</menu>
</menubar>
<toolbar name='ToolBar'>
	<placeholder name='Tools'>
		<toolitem action='TCalendar'/>
	</placeholder>
</toolbar>
</ui> } );

# Check if we have a suitable namespace available,
# init default values and resolve possible human input
my $settings = $app->init_settings(
	'Calendar Plugin', {Namespace => ':Date:'} );

my $ns = $$settings{Namespace} || ':Date:';
	# repeating default because empty string is not allowed here
$ns = $$app{notebook}->resolve_page($ns);
	# using resolve_page instead of resolve_name because this is
	# a stronger check for existence with read-only store backends.
if (defined $ns) {
	# We can not be sure that the namespace actually exists
	# or is writable, but at least it has a proper name.
	$$settings{Namespace} = $ns->name.':';
}
else {
	# Most likely the namespace maps to a read-only store
	# that returns undef for non-existing pages.
	warn "Calendar namespace does not exist, disabling calendar.\n";
	$app->actions_set_sensitive(
		TCalendar => 0,
		GoToday => 0,
	);
}

return 1;

sub TCalendar {
	# Toggle the visibility of the calendar dialog
	my ($self, $show) = @_;
	my $cal = $self->Calendar; # autoloads Zim::GUI::Calendar
	$show = $cal->visible ? 0 : 1 unless defined $show;
	$show ? $cal->show : $cal->hide ;
}

sub GoToday {
	# Navigate to the page for today's date
	my $self = shift;
	my ($day, $month, $year) = ( localtime )[3, 4, 5];
	$year += 1900;
	$self->Calendar->load_date($day, $month, $year);
}

