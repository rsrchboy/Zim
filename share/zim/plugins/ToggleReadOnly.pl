# This plugin adds a menu item and a toolbar button to toggle the 
# read_only state of the application. It mainly depends on code 
# already available in GUI.pm and PageView.pm but adds an explicit 
# control in the user interface.
#
# Boolean logic may be a bit counter intuitive because we make a toggle
# that says editable TRUE or FALSE, while we keep track of a property
# for read_only FALSE or TRUE ... and of course editabel = ! read_only

my $app = Zim::GUI->current;

my $toggle_actions = __actions( q{
TEditMode	gtk-edit	Page Editable	.	Page editable
} );

$app->add_actions($toggle_actions, 'TOGGLE');

$app->add_ui( q{
<ui>
<menubar name='MenuBar'>
	<menu action='ViewMenu'>
		<placeholder name='PluginItems'>
			<menuitem action='TEditMode'/>
		</placeholder>
	</menu>
</menubar>
<toolbar name='ToolBar'>
	<placeholder name='Tools'>
		<toolitem action='TEditMode'/>
	</placeholder>
</toolbar>
</ui> } );

if ($$app{read_only}) {
	# interface globally locked to read_only
	$app->actions_show_active(TEditMode => 0);
	$app->actions_set_sensitive(TEditMode => 0);
}
else {
	# Start based on state of previous instance
	# do not do this during init, but wait till gui-show.
	# Setting read_only during init could cause other components
	# to think we are in global read_only mode.
	$app->signal_connect(gui_show => sub {
		my $ro = $$app{state}{read_only_toggle};
		$ro = 0 unless defined $ro;
		if ($$app{read_only}) {
			# E.g. a read-only page was loaded already
			$app->actions_show_active(TEditMode => 0);
			$$app{read_only_lock} = $ro;
				# prevent toggling back if we were RO before
		}
		else {
			$app->actions_show_active(TEditMode => !$ro);
			$app->TEditMode if $ro;
				# toggle read-only if we were RO before
		}
	} );

	# Toggle visible state on signal
	$app->signal_connect(t_read_only => sub {
		my ($app, $ro) = @_;
		$app->actions_show_active(TEditMode => !$ro);
		$app->Reload
			if ($ro and ! $$app{page}->exists)
			or (!$ro and $$app{page}{properties}{is_error} == 404);
			# Reload if the page in question does not exist
			# this will switch from error to new page or back
	} );

	# Do not allow toggle for read_only pages
	$app->signal_connect(page_loaded => sub {
		my $ro = $$app{page}{properties}{read_only};
		$app->actions_set_sensitive(TEditMode => !$ro)
			unless $ro and $$app{page}{properties}{is_error} == 404;
			# make an exception for the 404 error page
		$app->actions_show_active(TEditMode => !$ro)
			unless $$app{read_only_lock};
			# if locked we set explicitly to read-only,
			# else we allow read-write but follow page properties
	} );
}

return 1;

# Send signal on toggle
sub TEditMode {
	$$app{read_only_lock} = 0;
		# If lock was set in init, we should be insensitive
		# so we never should be called. Hence, if lock is set
		# we did it in a previous call.
	$app->SaveIfModified if !$$app{read_only};
		# An auto-save after going to read_only causes an error
	$app->TReadOnly();
		# Call code to actually change application appearance
		# this triggers the t_read_only signal we are listening to
	$$app{read_only_lock} = $$app{read_only};
		# Prevent resetting state on loading a new page when we
		# enabled read-only. For not read-only page can still toggle
		# to read-only on itself.
	$$app{state}{read_only_toggle} = $$app{read_only};
		# Remember state across instances
}

