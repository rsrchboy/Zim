
use strict;
use Zim::Utils;

my $app = Zim::GUI->current;

# Do nothing for read-only interface
return 1 if $app->{read_only};

# Test if we have scrot
my $null = File::Spec->devnull;
unless (system("scrot -v > $null") == 0) {
	my $error = __('Can not find application "{name}"', name => 'scrot'); #. error when external application is not found
	$app->error_dialog($error);
	die $error."\n";
}

# Define menu and toolbar items
my $actions = __actions( q{
InsertScreenshot	.	_Screenshot...	.	Insert screenshot
} );

$app->add_actions($actions);

$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='InsertMenu'>
			<placeholder name='PluginItems'>
				<menuitem action='InsertScreenshot'/>
			</placeholder>
		</menu>
	</menubar>
</ui> } );

# Make sure to set item insensitive when page is read-only
$app->signal_connect(t_read_only =>
	sub { $_[0]->actions_set_sensitive(InsertScreenshot => !$_[1]) } );

return 1;

sub InsertScreenshot {
	## Create dialog
	my $dialog = Gtk2::Dialog->new(
		"Insert Screenshot - Zim", $app->{window},
	       	[qw/modal destroy-with-parent/],
		'gtk-cancel' => 'cancel',
		'gtk-ok'     => 'ok',
	);
	$dialog->vbox->set_border_width(12);
	#my $hbox = Gtk2::HBox->new;
	#$dialog->vbox->add($hbox);
	#$hbox->add( Gtk2::Label->new('Name: ') );
	#my $name_entry = Gtk2::Entry->new;
	#$name_entry->set_text($file);
	#$hbox->add($name_entry);
	my $all = Gtk2::RadioButton->new(undef, 'Capture whole screen');
	my $win = Gtk2::RadioButton->new($all, 'Select window or region');
	$dialog->vbox->add($_) for $all, $win;
	my $hbox = Gtk2::HBox->new;
	$dialog->vbox->add($hbox);
	$hbox->add( Gtk2::Label->new('Delay: ') );
	my $spin = Gtk2::SpinButton->new_with_range(0, 99, 1);
	$hbox->add($spin);
	$hbox->add( Gtk2::Label->new(' seconds') );

	## Run dialog
	$dialog->show_all;
	my $re = $dialog->run;
	$dialog->destroy;
	return unless $re eq 'ok';

	my $delay = $spin->get_value_as_int;
	my $select = $win->get_active;
	#my $f = $name_entry->get_text;
	#$file = $f if $f =~ /\S/;
	#$file .= '.png' unless $file =~ /\.\w+/;

	## Run scrot
	my $tmp = Zim::FS->tmp_file('ScreenShot.png');
	my @app = ('scrot');
	push @app, '-d', $delay if $delay;
	push @app, ($select ? ('-s', '-b') : ('-m'));
	warn "# Running: @app $tmp\n";
	system(@app, $tmp) == 0
		or return $app->error_dialog("Failed to execute scrot: $!");
	my $path = $$app{page}->store_file($tmp, 'screenshot_XX.png', 'MOVE');
	$app->PageView->InsertImage($path, 'NO_ASK');
}

