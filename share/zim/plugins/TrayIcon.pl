my $app = Zim::GUI->current();

$$app{hide_on_delete} = 1; # Turn "Close" into hide

# check if the user wants individual icons or not
my $conf = $app->init_settings(
	'TrayIcon Plugin' => {icon_per_notebook => 0} );

return 1 if  ! $$conf{icon_per_notebook}
         and $app->call_daemon('run', '_trayicon_', 'Zim::GUI::TrayIcon') ;


# We are note running using a daemon or the user want an individual
# icon for each notebook. Initialize icon object.
eval { 
	Gtk2->CHECK_VERSION(2, 10, 0)
		or require Gtk2::TrayIcon;
	require Zim::GUI::TrayIcon;
};
if ($@) {
	$app->error_dialog(
		"Failed to load TrayIcon plugin.\n".
		"You either need gtk+ >= 2.10 or you\n".
		"need to have Gtk2::TrayIcon installed.", $@);
	$app->unplug('TrayIcon');
	return 1;
}


$app->TrayIcon; # load object

1;
