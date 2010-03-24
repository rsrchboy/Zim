package Zim::GUI;

use strict;
use vars qw/$AUTOLOAD %Config/;
use Carp;
use POSIX qw(strftime);
use File::BaseDir qw/config_home data_files/;
use File::MimeInfo::Magic;
use Gtk2;
use Gtk2::Gdk::Keysyms;
use Gtk2::SimpleList;
use Zim;
use Zim::Utils;
use Zim::GUI::Component;
use Zim::GUI::PathBar;
use Zim::GUI::PageView;

eval "use File::DesktopEntry; use File::MimeInfo::Applications";
my $has_mimeapplications = $@ ? 0 : 1;
warn "WARNING: Could not use 'File::MimeInfo::Applications', disabling application bindings\n"
	unless $has_mimeapplications;

our $VERSION = '0.29';
our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI - The application object for zim

=head1 SYNOPSIS

	use Zim::GUI;

	my $zim = Zim::GUI->new(\%SETTINGS);
	$zim->gui_init;
	$zim->gui_show;

	Gtk2->main;

	exit;

=head1 DESCRIPTION

This is developer documentation, for the user manual try
executing C<zim --doc>. For commandline options see L<zim>(1).

This module provides the application object for the Gtk2 application B<zim>.
The application has been split into several components for which the
modules can be found in the Zim::GUI:: namespace. This object brings
together these components and manages the settings and data objects.

This object inherits from L<Zim::GUI::Component> and L<Zim::Events>.

=head1 SIGNALS

This following signals are emitted by this object:

=over 4

=item C<gui_show>

Can be used for actions that can not be done during init but need to be
delayed till we actually show the interface.

=item C<page_loaded(NAME)>

Emitted after a new page is loaded.

=item C<t_read_only(BOOLEAN)>

Toggle the display for the current page read-only. Do not assume the whole
notebook to be read-only after this signal. If that is the case read_only
was already set on initialization, so it can be checked during init.

=back

TODO: The following signals should move to the notebook object

=over 4

=item C<page_renamed(FROM => TO)>

Emitted after a page is renamed.

=item C<page_deleted(NAME)>

Emitted after a page is deleted.

=back

=head1 ATTRIBUTES

=over 4

=item C<name>: The name of this instance / notebook

=item C<profile>: Profile name


=item C<notebook>: L<Zim> object

=item C<history>: L<Zim::History> object

=item C<settings>: Hash with preferences

=item C<state>: Hash with GUI state

=item C<read_only>: Current read_only state (per page)

=back

=head1 AUTOLOAD

You can access component object by autoloaded accesors. The component objects
are autoloaded from the C<Zim::GUI::> namespace. Component names need to be
capitalized for this to work.

Non-capitalized methods that do not exist are called on the main window object.
See L<Gtk2::Window> for the documentation.

=head1 METHODS

=over 4

=cut

our $STATE = # Initial window state
q{
pane_pos	200
pane_vis	0
width		600
height		450
x
y
};
# Note that while pane_vis is a state, similar settings like
# toolbar_vis and toolbar_vis are settings. This is a matter of
# taste. The assumption is that pane_vis is toggled often while
# the other only when customizing the app.

our $CONFIG = # Default config values
q{
statusbar_vis	1
toolbar_vis	1
pathbar_type	recent
default_home	:Home
default_type	Files
browser
file_browser
email_client
text_editor
diff_editor
undo_max	50
follow_new_link	0
backsp_unindent	1
plugins		Calendar,TODOList,PrintToBrowser
use_camelcase	1
use_ucfirst_title	1
use_utf8_ent	1
use_linkfiles	1
use_autolink	0
use_autoincr	1
textfont
tearoff_menus	0
use_autoselect	1
follow_on_enter	1
use_ctrl_space	0
ro_cursor	0
expand_tree	0
save_interval	5000
autosave_version 0
};

our %DEFAULTS;
$DEFAULTS{$$_[0]} ||= $$_[1] for
	[file_browser => q/thunar '%d'/],
	[browser      => q/firefox '%u'/],
	[email_client => q/thunderbird '%u'/],
	[text_editor  => q/mousepad '%f'/] ;

my $ui_menus = __actions(
# name		stock id 	label
q{
FileMenu	.		_File
EditMenu	.		_Edit
ViewMenu	.		_View
InsertMenu	.		_Insert
SearchMenu	.		_Search
FormatMenu	.		For_mat
ToolsMenu	.		_Tools
GoMenu		.		_Go
HelpMenu	.		_Help
PathBarMenu	.		P_athbar type
ToolBarMenu	.		Toolbar style
} );

my $ui_actions = __actions(
# name,		stock id,	label,		accelerator,	tooltip
q{
NewPage		gtk-new		_New Page	<ctrl>N		New page
popup_NewPage	gtk-new		_New Page	.		New page
OpenNotebook	gtk-open	_Open Another Notebook...	<ctrl>O	Open notebook
Save		gtk-save	_Save		<ctrl>S		Save page
SaveVersion	gtk-save-as	S_ave Version...	<ctrl><shift>S	Save Version
Versions	.		_Versions...	.		Versions
Export		.		E_xport...	.		Export
EmailPage	.		_Send To...	.		Mail page
CopyPage	.		_Copy Page...	.		Copy page
popup_CopyPage	.		_Copy Page...	.		Copy page
RenamePage	.		_Rename Page...	F2		Rename page
popup_RenamePage	.	_Rename Page...	.		Rename page
DeletePage	.		_Delete Page	.		Delete page
popup_DeletePage	.	_Delete Page	.		Delete page
Props		gtk-properties	Proper_ties	.		Properties dialog
Close		gtk-close	_Close		<ctrl>W		Close window
Quit		gtk-quit	_Quit		<ctrl>Q		Quit
Search		gtk-find	_Search...	<shift><ctrl>F	Search
SearchBL	.		Search _Backlinks...	.	Search Back links
CopyLocation	.		Copy Location	<shift><ctrl>L	Copy location
Prefs		gtk-preferences	Pr_eferences	.		Preferences dialog
Reload		gtk-refresh	_Reload		<ctrl>R		Reload page
OpenFolder	gtk-open	Open Document _Folder	.	Open document folder
OpenRootFolder	gtk-open	Open Document _Root	.	Open document root
AttachFile	mail-attachment	Attach _File	.	Attach external file
EditSource	gtk-edit	Edit _Source	.		Open source
RBIndex		.		Re-build Index	.		Rebuild index
GoBack		gtk-go-back	_Back		<alt>Left	Go page back
GoForward	gtk-go-forward	_Forward	<alt>Right	Go page forward
GoParent	gtk-go-up	_Parent		<alt>Up		Go to parent page
GoChild		gtk-go-down	_Child		<alt>Down	Go to child page
GoPrev		.		_Previous in index	<alt>Page_Up	Go to previous page
GoNext		.		_Next in index	<alt>Page_Down	Go to next page
GoHome		gtk-home	_Home		<alt>Home	Go home
JumpTo		gtk-jump-to	_Jump To...	<ctrl>J		Jump to page
ShowHelp	gtk-help	_Contents	F1		Help contents
ShowHelpFAQ	.		_FAQ		.		FAQ
ShowHelpKeys	.		_Keybindings	.		Key bindings
ShowHelpBugs	.		_Bugs		.		Bugs
About		gtk-about	_About		.		About
} );

my $ui_toggle_actions = __actions(
# name,		stock id,	label,		accelerator,	tooltip
q{
TToolBar	.		_Toolbar	.		Show toolbar
TStatusBar	.		_Statusbar	.		Show statusbar
TPane		gtk-index	_Index		F9		Show index
} );

my $ui_radio_PBactions = __actions(
# name,		stock id,	label,		accelerator,	tooltip
q{
PBRecent	.		_Recent pages	.		.
PBHistory	.		_History	.		.
PBNamespace	.		_Namespace	.		.
PBHidden	.		H_idden		.		.
} );
my $ui_radio_TBaction_iconsize = __actions(
# name,		stock id,	label,		accelerator,	tooltip
q{
TBmenu		.		Tiny		.		.
TBsmall-toolbar	.		Small		.		.
TBbutton	.		Medium		.		.
TBlarge-toolbar	.		Large		.		.
TBdnd		.		Big		.		.
TBdialog	.		Fat		.		.
} );

my $ui_radio_TBaction_style = __actions(
q{
TBtext		.		_Text	.		.
TBicons		.		_Icons 	.		.
TBboth		.		_Both	.		.
} );

my $ui_layout = q{<ui>
	<menubar name='MenuBar'>
		<menu action='FileMenu'>
			<menuitem action='NewPage'/>
			<menuitem action='OpenNotebook'/>
			<separator/>
			<menuitem action='Save'/>
			<menuitem action='SaveVersion'/>
			<menuitem action='Versions'/>
			<separator/>
			<menuitem action='Export'/>
			<placeholder name='PrintActions'/>
			<menuitem action='EmailPage'/>
			<separator/>
			<placeholder name='PageMods'/>
			<separator/>
			<menuitem action='Props'/>
			<separator/>
			<menuitem action='Close'/>
			<menuitem action='Quit'/>
		</menu>
		<menu action='EditMenu'>
			<placeholder name='EditPage'/>
			<separator/>
			<menuitem action='CopyLocation'/>
			<separator/>
			<menuitem action='Prefs'/>
		</menu>
		<menu action='ViewMenu'>
			<menuitem action='TToolBar'/>
			<menuitem action='TStatusBar'/>
			<menuitem action='TPane'/>
			<menu action='PathBarMenu'>
				<menuitem action='PBRecent'/>
				<menuitem action='PBHistory'/>
				<menuitem action='PBNamespace'/>
				<menuitem action='PBHidden'/>
			</menu>
			<menu action='ToolBarMenu'>
				<menuitem action='TBmenu'/>
				<menuitem action='TBsmall-toolbar'/>
				<menuitem action='TBbutton'/>
				<menuitem action='TBlarge-toolbar'/>
				<menuitem action='TBdnd'/>
				<menuitem action='TBdialog'/>
				<separator/>
				<menuitem action='TBtext'/>
				<menuitem action='TBicons'/>
				<menuitem action='TBboth'/>
			</menu>
			<separator/>
			<placeholder name='PluginItems'/>
			<separator/>
			<menuitem action='Reload'/>
		</menu>
		<menu action='InsertMenu'>
		</menu>
		<menu action='FormatMenu'></menu>
		<menu action='SearchMenu'>
			<placeholder name='FindItems'/>
			<separator/>
			<menuitem action='Search'/>
			<menuitem action='SearchBL'/>
		</menu>
		<menu action='ToolsMenu'>
			<placeholder name='PageTools'/>
			<separator/>
			<menuitem action='EditSource'/>
			<menuitem action='AttachFile'/>
			<menuitem action='OpenFolder'/>
			<menuitem action='OpenRootFolder'/>
			<separator/>
			<menuitem action='RBIndex'/>
		</menu>
		<placeholder name='PluginMenus'/>
		<menu action='GoMenu'>
			<menuitem action='GoBack'/>
			<menuitem action='GoForward'/>
			<separator/>
			<menuitem action='GoParent'/>
			<menuitem action='GoChild'/>
			<menuitem action='GoNext'/>
			<menuitem action='GoPrev'/>
			<separator/>
			<placeholder name='PluginItems'/>
			<separator/>
			<menuitem action='GoHome'/>
			<menuitem action='JumpTo'/>
		</menu>
		<menu action='HelpMenu'>
			<menuitem action='ShowHelp'/>
			<menuitem action='ShowHelpFAQ'/>
			<menuitem action='ShowHelpKeys'/>
			<menuitem action='ShowHelpBugs'/>
			<separator/>
			<menuitem action='About'/>
		</menu>
	</menubar>
	<toolbar name='ToolBar'>
		<placeholder name='File'/>
		<separator/>
		<placeholder name='Edit'/>
		<separator/>
		<placeholder name='View'>
			<toolitem action='TPane'/>
		</placeholder>
		<separator/>
		<placeholder name='Go'>
			<toolitem action='GoHome'/>
			<toolitem action='GoBack'/>
			<toolitem action='GoForward'/>
		</placeholder>
		<separator/>
		<placeholder name='Search'/>
		<separator/>
		<placeholder name='Format'/>
		<separator/>
		<placeholder name='Tools'>
			<toolitem action='AttachFile'/>
		</placeholder>
	</toolbar>
	<popup name='PagePopup'>
		<menuitem action='popup_NewPage'/>
		<menuitem action='popup_CopyPage'/>
		<menuitem action='popup_RenamePage'/>
		<menuitem action='popup_DeletePage'/>
	</popup>
	<popup name='ToolBarPopup'>
		<menuitem action='TBmenu'/>
		<menuitem action='TBsmall-toolbar'/>
		<menuitem action='TBbutton'/>
		<menuitem action='TBlarge-toolbar'/>
		<menuitem action='TBdnd'/>
		<menuitem action='TBdialog'/>
		<separator/>
		<menuitem action='TBtext'/>
		<menuitem action='TBicons'/>
		<menuitem action='TBboth'/>
	</popup>
	<accelerator action='GoChild'/>
</ui>};

my $ui_layout_rw = q{<ui>
<menubar name='MenuBar'>
		<menu action='FileMenu'>
			<placeholder name='PageMods'>
				<menuitem action='CopyPage'/>
				<menuitem action='RenamePage'/>
				<menuitem action='DeletePage'/>
			</placeholder>
		</menu>
</menubar>
</ui>};

our $CURRENT;

=item C<new(profile => NAME, ...)>

Simple constructor.

=cut

sub init {
	my $self = shift;

	# Initialize attributes
	$self->{app} = $self; # fool base class
	$self->{_message_timeout} = -1;
	$self->{_save_timeout}    = -1;

	# check notebook
	my $notebook = $self->{notebook} or die "BUG: no notebook defined";
	$self->{history} = $notebook->init_history;
	$self->{profile} ||= $$notebook{config}{profile} || 'default';

	# load state parameters
	my %state;
	for (split /\n/, $STATE) { # defaults
		next unless /\S/;
		my ($key, $val) = split /\s+/, $_, 2;
		$state{$key} = $val
	}
	my $cache_dir = $notebook->get_notebook_cache;
	if (defined $cache_dir) {
		$$self{state_file} =
			Zim::FS::File::Config->new($cache_dir, 'state.conf');
		$$self{state} = $$self{state_file}->read(\%state, 'GUI State');
	}

	# Load config
	warn "# Profile: $$self{profile}\n";
	$self->_load_settings;
	$self->LoadAccelmap;

	$self->{read_only} ||=
		$self->{settings}{read_only} ||
		$notebook->{config}{read_only};
		# Global read_only  is set here during init, plugins can
		# check for this and if set hide any menu items for
		# editing. Per page read_only determined by signal.
	$self->{read_only_lock} = $self->{read_only} || 0;
		# prevent anyone from switching us to read-write mode

	# Bootstrap between notebook and config
	$self->_init_properties;
	$notebook->signal_connect(
		'config_changed' => \&_init_properties, $self );

	return $self;
}

sub _load_settings {
	my $self = shift;

	# load defaults
	for (split /\n/, $CONFIG) {
		next unless /\S/;
		my ($key, $val) = split /\s+/, $_, 2;
		$$self{settings}{$key} = $val
	}
	$$self{settings}{user_name} ||= $ENV{USER};

	# load file
	my $file = _config_data_files('zim', "$$self{profile}.conf");
	$file ||= _config_data_files('zim', 'default.conf');
	return warn "WARNING: Could find default configuration\n" unless $file;
	warn "# Reading config from: $file\n";
	Zim::FS::File::Config->new($file)->read($$self{settings}, 'Config');

	$$self{notebook}{user_name} = $$self{settings}{user_name};
}

# This method sets all settings / properties that need to
# be synced between GUI object and the notebook object.

sub _init_properties {
	my $self = pop; # pop because we are called from signal
	my $nb = $$self{notebook};

	# name
	$self->call_daemon('register', $$nb{name});
	warn "# Notebook: $$nb{name}\n";

	# icon
	if (my $icon = $$nb{config}{icon}) {
		my $file = Zim::FS->abs_path($icon, $$nb{dir});
		$file = data_files('pixmaps', $icon) unless -f $file;
		$$self{icon_file} =
			(defined $file and -f $file) ? $file : undef;
	}
	else { delete $$self{icon_file} }

	if (my $window = $$self{window}) {
		my $icon = $$self{icon_file} || $Zim::ICON;
		$window->set_icon_from_file($icon);
	}

	# home
	my $home = $$nb{config}{home}
	        || $$self{settings}{default_home}
		|| ':Home' ;
	$home = $nb->resolve_name($home);
	$$nb{config}{home} = $home;
	$$self{home} = $home;
	warn "# Home: $home\n";

	# update UI if initializes
	$self->actions_set_sensitive(
		OpenRootFolder => $$nb{config}{document_root} ? 1 : 0,
	) if $$self{actions};

	# Check version control
	if ($$nb{config}{autosave_version} and ! $$nb{vcs}) {
		eval { $self->SaveVersion };
			# prompt for init version control
			# eval in case we are not intialized yet etc.
		$$nb{config}{autosave_version} = 0 if ! $$nb{vcs};
	}
}

sub _config_data_files {
	# We mix up XDG basedir spec by saving in XDG_CONFIG_HOME
	# but loading for XDG_DATA_DIRS
	my @path = @_;
	my $file = config_home(@path);
	return $file if -e $file;
	$file = data_files(@path);
	return $file; # can be undef
}

=item C<gui_init()>

This method initializes all GUI objects that make up the application.

=cut

sub gui_init {
	my $self = shift;

	## Setup the window
	my $window = Gtk2::Window->new('toplevel');
	$window->set_default_size(@{$$self{state}}{'width', 'height'});
	$window->signal_connect_swapped(delete_event => \&on_delete_event, $self);
	$window->signal_connect(destroy => sub { Gtk2->main_quit });
	if (defined $$self{icon_file}) {
		$window->set_icon_from_file($$self{icon_file});
	}
	#elsif (Gtk2->CHECK_VERSION(2, 6, 0)) {
	#	FIXME: Seemd this function is broken - no icon rendered
	#	$window->set_icon_name('zim'); # since 2.6.0
	#}
	else {
		$window->set_icon_from_file($Zim::ICON);
	}
	$window->set_title($$self{notebook}{name}.' - Zim');
	$self->{window} = $window;

	$SIG{USR1} = sub { $window->present };
		# put window to foreground on `kill -USR1`

	#$window->signal_connect(hide => sub { # FIXME does not work - patched in TrayIcon
	#		@{$self->{state}}{'x', 'y'} = $window->get_position;
	#		warn "hiding window: @{$self->{state}}{'x', 'y'}\n";
	#	} );
	$window->signal_connect(show => sub {
			my ($x, $y) = @{$self->{state}}{'x','y'};
			#warn "showing window: $x, $y\n";
			$window->move($x,$y) if defined($x) and defined ($y);
		} );


	my $vbox = Gtk2::VBox->new(0, 0);
	$window->add($vbox);
	$self->{vbox} = $vbox;

	## Setup actions and ui for menubar and toolbar
	my $ui = Gtk2::UIManager->new;
	$window->add_accel_group($ui->get_accel_group);
	$ui->set_add_tearoffs($self->{settings}{tearoff_menus});
	$self->{ui} = $ui;

	$self->add_actions($ui_menus, 'MENU');
	$self->add_actions($ui_actions);
	$self->add_actions($ui_toggle_actions, 'TOGGLE');
	$self->add_actions($ui_radio_PBactions, 'RADIO', 'TPathBar');
	$self->add_actions($ui_radio_TBaction_iconsize, 'RADIO', 'TBar_iconsize');
	$self->add_actions($ui_radio_TBaction_style, 'RADIO', 'TBar_style');

	$self->actions_set_sensitive(
		Save      => $$self{read_only} ? 0 : 1,
		NewPage   => $$self{read_only} ? 0 : 1,
		GoBack    => 0,
		GoForward => 0,
		GoParent  => 0,
		OpenRootFolder  => $$self{notebook}{document_root} ? 1 : 0,
		Versions        => $$self{notebook}{vcs} ? 1 : 0,
	);

	$self->add_ui($ui_layout);
	$self->add_ui($ui_layout_rw) unless $self->{read_only};
		# we do not load menu items for edit whith global read_only

	$self->{menubar} = $ui->get_widget("/MenuBar");
	$vbox->pack_start($self->{menubar}, 0,1,0);
	$self->{toolbar} = $ui->get_widget("/ToolBar");
	$vbox->pack_start($self->{toolbar}, 0,1,0);
	$self->{toolbar}->hide;
	$self->{toolbar}->set_no_show_all(1);
	$self->{toolbar}->signal_connect('popup_context_menu' => sub {
		my $self = shift; # Gtk2::Toolbar
		my ($x, $y, $b, $pop) = @_;
		$pop->popup(undef, undef, undef, undef, 0, 0);
	    },
	    $ui->get_widget("/ToolBarPopup"),
	);

	## General window layout
	my $hpaned = Gtk2::HPaned->new();
	$hpaned->set_position($self->{state}{pane_pos});
	$vbox->pack_start($hpaned, 1,1,0);
	$self->{hpaned} = $hpaned;

	my $l_vbox = Gtk2::VBox->new(0, 0);
	$hpaned->add1($l_vbox);
	$l_vbox->set_no_show_all(1);
	$self->{l_vbox} = $l_vbox;

	my $r_vbox = Gtk2::VBox->new(0, 0);
	$hpaned->add2($r_vbox);
	$self->{r_vbox} = $r_vbox;

	my $shbox = Gtk2::HBox->new(0, 2);
	$shbox->set_no_show_all(1);
	$vbox->pack_start($shbox, 0,1,0);
	$self->{statusbar} = $shbox;

	## Status bar
	# Page name part
	my $s1 = Gtk2::Statusbar->new;
	$s1->set_has_resize_grip(0);
	$shbox->pack_start($s1, 1,1,0);
	$self->{status1} = $s1;

	# Style part
	my $frame = Gtk2::Frame->new();
	$frame->set_shadow_type('in');
	$s1->pack_end($frame, 0,1,0);
	my $l2 = Gtk2::Label->new();
	$l2->set_size_request(100,10);
	$l2->set_alignment(0.1, 0.5);
	$frame->add($l2);
	$self->{statuss} = $l2;

	# Backlinks part
	$frame = Gtk2::Frame->new();
	$frame->set_shadow_type('in');
	$s1->pack_end($frame, 0,1,0);
	my $ebox = Gtk2::EventBox->new();
	$frame->add($ebox);
	my $l1 = Gtk2::Label->new();
	$l1->set_size_request(120,10);
	$l1->set_alignment(0.1, 0.5);
	$l1->set_mnemonic_widget( ($self->get_action('SearchBL')->get_proxies)[0] );
	$ebox->add($l1);
	$self->{statusl} = $l1;

	# Resizer and insert mode part
	my $s2  = Gtk2::Statusbar->new;
	$s2->set_size_request(80,10);
	$shbox->pack_end($s2, 0,1,0);
	$self->{status2} = $s2;

	$ebox->signal_connect_swapped(button_press_event => \&on_click_backlinks, $self);

	## Build content of the main area
	my $path_bar = Zim::GUI::PathBar->new(app => $self);
	$r_vbox->pack_start($path_bar->widget, 0,1,5);
	$self->{objects}{PathBar} = $path_bar;

	my $page_view = Zim::GUI::PageView->new(app => $self);
	$r_vbox->pack_end($page_view->widget, 1,1,0);
	$self->{objects}{PageView} = $page_view;

	$vbox->set_focus_chain($l_vbox, $page_view->widget);
		# get pathbar and toolbar out of the loop

	my $hist = $self->{history};
	$hist->set_GUI($page_view) if $hist;

	## Some wiring
	my $accels = $ui->get_accel_group;
	# Ctrl-Space / Alt-Space
	my @combo = ([ord(' '), ['mod1-mask']]);
	push @combo, [ord(' '), ['control-mask']] if $self->{settings}{use_ctrl_space};
	$accels->connect(
		@$_, ['visible'],
		sub {
			if ($self->{state}{pane_vis}) {
				my $tree_view = $self->TreeView;
				my $page_view = $self->PageView;
				if ($tree_view->has_focus) { $page_view->grab_focus }
				else                       { $tree_view->grab_focus }
			}
			else {
				my $vis = $self->{_pane_visible} ? 0 : -1;
				$self->TPane($vis);
			}
		} ) for @combo;
	$accels->connect( Gtk2::Accelerator->parse('F5'), ['visible'],
		sub { $self->Reload } );

	$self->signal_connect('page_loaded', sub {
		my $self = shift;
		my $state = $hist->get_state;
		$self->actions_set_sensitive(
			GoBack     => ($$state{back}     ? 1 : 0),
			GoForward  => ($$state{forw}     ? 1 : 0),
			GoParent   => ($self->{page}->namespace =~ /[^:]/),
		)
	} ) if $hist;

	## Load plugins
	$self->plug($_) for grep length($_),
	                    split /,/, $self->{settings}{plugins};

	## Try saving the program on system signals
	for my $sig (qw/TERM HUP PIPE/) {
		$SIG{$sig} = sub {
			$self->Quit();
			$self->exit_error(undef,"Signal $sig caught\n");
		};
	}

	# Try saving on desktop exit
#	$window->get_display->signal_connect( closed => sub {
#			print "Display closed\n";
#		} );

	# Attach signal to accelmap - get() fails for certain verison Gtk2
	eval {
	Gtk2::AccelMap->get->signal_connect(changed => sub {
		my $accelmap = config_home('zim', 'accelmap');
		Gtk2::AccelMap->save($accelmap);
	} );
	};

	# Attach signal to STDIN for IPC if STDIN is a pipe
	Glib::IO->add_watch ( fileno(STDIN), ['in', 'hup'], sub {
		# Method to handle calls on STDIN.
		# We enforce that this interface can only call actions by
		# checking the case of the method name.
		# THe object name can be given as well using: "Object.Action"
		my ($fileno, $condition) = @_;
		return 0 if $condition eq 'hup'; # uninstall
		my $line = <STDIN>;
		return 1 unless $line =~ /\S/;
		my @args;
		while ($line =~ s/((\\.|\S)+)//) {
			push @args, $1;
		}
		@args = map {s/\\(.)/$1/; $_} @args;
		my $cmd = shift @args;
		if ($cmd =~ /^[A-Z]\w+(\.[A-Z]\w+)?$/) {
			my $obj = $self;
			eval {
				$obj = $self->$1 if $cmd =~ s/^([A-Z]\w+)\.//;
				$obj->$cmd(@args);
			};
			warn $@ if $@;
		}
		else {
			warn "ERROR: Invalid command: $cmd\n";
		}
		return 1;
	}) if -p STDIN;
}

=item C<gui_show()>

This method actually shows the main window. This is separated from
C<gui_init()> so we can first load a page before showing the GUI.

=cut

sub gui_show {
	my ($self, %opt) = @_;

	## Show all widgets .. well most of them
	$self->{ui}->ensure_update; # make sure the menu is complete
	$self->{vbox}->show_all;
	$self->{statusbar}->set_no_show_all(0);
	$self->{l_vbox}->set_no_show_all(0);
	$self->{toolbar}->set_no_show_all(0);
	$self->ShowWindow(%opt); # run before "load_page" to prevent lag

	## Find a page to load
	my $hist = $self->{history};
	unless ($self->{page}) {
		my $page;
		$page = $$self{history}->get_current if $$self{history} ;
		$page ||= $$self{notebook}->resolve_page($$self{home})
			if $$self{home};
		unless ($page) {
			# last ditch effort
			($page) = $$self{notebook}->list_pages(':');
			$page = $$self{notebook}->resolve_name($page);
		}
		$self->load_page($page);
	}

	## Toggle some widgets
	$self->{message_lock} = 1;
	$self->TReadOnly($$self{page}{properties}{read_only}||0, 'FORCE');
		# force emission after first page load
	my $set = $self->{settings};
	my $pbtype = lc $$set{pathbar_type};
	$pbtype = 'recent' unless grep {$_ eq $pbtype}
		qw/recent history namespace hidden/;
	$$set{pathbar_type} = $pbtype;
	$self->actions_set_active(
		TToolBar   => $$set{toolbar_vis},
		TStatusBar => $$set{statusbar_vis},
		TPane      => $$self{state}{pane_vis},
	);
	$self->TPathBar($pbtype);
	$self->{message_lock} = 0;

	## set toolbar styles
	$self->TBar_style($$set{toolbar_style} || $self->{toolbar}->get_style);
	$self->TBar_iconsize($$set{toolbar_iconsize} || $self->{toolbar}->get_icon_size);

	## set autosave interval - default is every 5 seconds
	my $t = $$set{save_interval} || 5000;
	$self->{_save_timeout} =
		Glib::Timeout->add($t, sub {$self->SaveIfModified('SOFT'); 1})
		unless $self->{read_only};
		# global read-only - so we never need to save

	$self->signal_emit('gui_show');
	$self->PageView->grab_focus;
}

=item C<ShowWindow(%OPT)>

Used to present the window and possibly to change window state.

=item C<HideWindow()>

Iconify or hide the window.

=item C<ToggleWindow()>

Calls either C<ShowWindow()> or C<HideWindow>.

=cut

sub ShowWindow {
	my ($self, %opt) = @_;
	my $state = $$self{state};

	if ($opt{geometry}) {
		my @geometry = split ',', $opt{geometry};
		warn "# Set geometry @geometry\n";
		@{$state}{'width', 'height'} = @geometry[0,1];
		@{$state}{'x', 'y'} = @geometry[2,3];
	}

	return $self->HideWindow if $opt{iconify};
		# FIXME - put here to allow --iconify and --geometry
		# at the same time during init

	if ($self->visible) {
		$self->present;
	}
	else {
		$self->present;
		$self->resize(@{$state}{'width', 'height'});
		$self->move(@{$state}{'x', 'y'});
	}
}

sub HideWindow {
	my $self = shift;
	return unless $self->visible;

	my $state = $$self{state};
	@{$state}{'width', 'height'} = $self->get_size;
	@{$state}{'x', 'y'} = $self->get_position;

	$self->{hide_on_delete}
		? $self->hide : $self->iconify ;
}

sub ToggleWindow {
	$_[0]->is_active ? $_[0]->HideWindow : $_[0]->ShowWindow;
		# is_active checks whether we have input focus
		# == whether we are in the foreground
}

sub DESTROY {
	my $self = shift;
	for (qw/_save_timeout _message_timeout/) {
		my $timeout = $self->{$_};
		Glib::Source->remove($timeout)
			if defined $timeout and $timeout >= 0;
	}
}

sub AUTOLOAD {
	my $self = shift;
	my $class = ref $self;
	$AUTOLOAD =~ s/^.*:://;

	return if $AUTOLOAD eq 'DESTROY';
	croak "No such method: $class::$AUTOLOAD" unless ref $self;
	#warn join ' ', "Zim::AUTOLOAD called for $AUTOLOAD by: ", caller, "\n";

	if (exists $self->{objects}{$AUTOLOAD}) {
		return $self->{objects}{$AUTOLOAD};
	}
	elsif ($AUTOLOAD =~ /^on_(\w+)$/) { # could be an action handler
		no strict 'refs';
		unshift @_, $self;
		goto &{"Zim::GUI::Component::$AUTOLOAD"}; # call parent
	}
	elsif ($AUTOLOAD =~ /^[A-Z]/) {
		my $class = $$self{autoload}{$AUTOLOAD};
		$class ||= "Zim::GUI::$AUTOLOAD";
		warn "## AUTOLOAD $class\n";
		eval "require $class";
		$self->exit_error($@) if $@;
		$self->{objects}{$AUTOLOAD} = $class->new(app => $self);
		return $self->{objects}{$AUTOLOAD};
	}


	# Call method on default widget
	croak "No such method: $class::$AUTOLOAD"
		unless $$self{window} and $$self{window}->can($AUTOLOAD);
	return $self->{window}->$AUTOLOAD(@_);
}

=item C<current()>

Returns a reference to the current Zim::GUI object. Class method used in plugin
scripts to get a reference to the application object.

=cut

sub current { return $CURRENT }

=item C<plug(PLUGIN)>

Load plugin by name.

=item C<unplug(PLUGIN)>

Remove plugin from the config.

=cut

sub plug { # TODO add plugin to config
	my ($self, $name) = @_;
	return $self->error_dialog(
		__("Plugin already loaded: {name}", name => $name) )
		if $self->{plugins}{$name};

	my ($script) = data_files('zim', 'plugins', $name.'.pl');
	unless (length $script) {
		$self->unplug($name);
		return $self->error_dialog(
			__("No such plugin: {name}", name => $name) );
	}

	warn "# Loading plugin $name\n";
	warn "## from $script\n";
	local $CURRENT = $self;
	my $return = do $script;
	if ($@ or ! defined $return) {
		$self->unplug($name);
		return $self->error_dialog(
			__("Failed to load plugin: {name}", name => $name), #. error
			$@ || $! );
	}

	$self->{plugins}{$name} = 1;
	return 1;
}

sub unplug {
	my ($self, $name) = @_;
	$self->{settings}{plugins} =~ s/\Q$name\E,*//;
	delete $self->{plugins}{$name};
	$self->SaveSettings;
}

sub on_click_backlinks {
	my ($self, $event) = @_;
	return if $event->type ne 'button-press';

	if ($event->button == 1) {
		$self->SearchDialog->{dialog}
			? $self->SearchDialog->hide
			: $self->SearchBL  ;
	}
	return unless $event->button == 3;

	my @blinks = $self->{page}->list_backlinks;
	return unless @blinks;

	my $menu = Gtk2::Menu->new();
	for my $l (@blinks) {
		my $item = Gtk2::ImageMenuItem->new_with_label($l);
		$item->signal_connect(activate =>
			sub { $self->load_page($l) }  );
		$menu->add($item);
	}

	$menu->show_all;

	my ($button, $time) = $event
		? ($event->button, $event->time)
		: (0, 0) ;
	$menu->popup(undef, undef, undef, undef, $button, $time);
}

=item C<widget()>

Returns the root window widget.
Use this widget for things like show_all() and hide_all().

=cut

sub widget { return $_[0]->{window} }

=item C<SaveSettings(NOTIFY)>

Save config file with settings. If NOTIFY is true and we are running with
a daemon process we will notify other processes to run C<LoadSettings()>.

=item C<SaveState()>

Save state parameters to file. Typically this will save ".zim/state.conf"
in the notebook directory.

=cut

sub SaveSettings {
	my ($self, $notify) = @_;
	my %conf = %{$$self{settings}};
	my $file = config_home('zim', $$self{profile}.'.conf');
	warn "# Writing config to: $file\n";
	Zim::FS::File::Config->new($file)->write(\%conf, 'Config');
	$self->signal_emit('settings-changed');
	$self->call_daemon('broadcast', 'LoadSettings') if $notify;
}

sub SaveState {
	my $self = shift;
	$$self{state}{pane_pos} = $$self{hpaned}->get_position;
	$$self{state_file}->write($$self{state}, 'GUI State')
		if $$self{state_file};
}

=item C<LoadSettings()>

This will (re-)load the settings from the config file. Called by the daemon
after another process changed the setting. E.g. after running the
PreferencesDialog.

=cut

sub LoadSettings {
	my $self = shift;

	$self->_load_settings;
	my $settings = $$self{settings};

	$$self{ui}->set_add_tearoffs( $$settings{tearoff_menus} );

	# FIXME stuff below should be handle by signal
	$self->PageView->on_show_cursor();
	$self->PageView->{htext}{follow_on_enter} = $$settings{follow_on_enter};

	$self->_init_properties;
}

=item C<LoadAccelmap()>

Loads the list of custom key bindings. Called during initialization and after
an other process updated the file.

=cut

sub LoadAccelmap {
	# load accelerators
	my $accelmap = _config_data_files('zim', 'accelmap');
	Gtk2::AccelMap->load($accelmap) if $accelmap;
}

=item C<link_clicked(LINK)>

Loads a page in zim or opens an external url in a browser.

LINK is considered to be either an page name, an url or a file name.
Page names are resolved as relative links first.
Dispatches to C<open_file()> or C<open_url()> when
LINK is a file or an url.

=cut

sub link_clicked {
	my ($self, $link) = @_;
	$link =~ s/^\s+|\s+$//g; # no whitespace pre- or post-fix
	return warn "WARNING: You tried to folow an empty link.\n"
		unless length $link;

	my ($type, $l) = $self->{page}->parse_link($link);
	warn "## Link clicked: $link ($type: $l)\n";
	return $self->error_dialog("Link undefined: $link")
	       unless defined $type;

	if    ($type eq 'page') { $self->load_page($l) }
	elsif ($type eq 'file') { $self->open_file($l) }
	elsif ($type eq 'zim') {
		$l =~ s/^zim:\/\///;
		$l =~ s/\?(.*)$//;
		my $page = $1;
		$self->OpenNotebook($l, $page) if length $l;
	}
	elsif ($type eq 'man')  { $self->ShowHelp('_man_', $l) }
	else                    { $self->open_url($l, $type)   }
}

=item C<open_file(FILE)>

Opens FILE with the apropriate program.
Calls C<open_directory()> when FILE is a directory.

=cut

sub open_file {
	my ($self, $file) = @_;
	return $self->open_directory($file) if $file =~ /\/$/ or -d $file;
		# Just to make sure we are dealing with files here

	my $app;
	if ($has_mimeapplications) {
		my $mt = mimetype("$file");
		($app) = grep $_, mime_applications($mt) if defined $mt;
			# If no default application is set,
			# we use the first in the list
	}

	return $self->open_directory($file, 'OPEN_FILE') unless defined $app;
		# Open directory in case we do not have a mimetype,
		# or we do not have an application, or we do not have
		# the libs to determine that.

	unless (fork) {
		# child process that executes the application
		# $app is a File::DesktopEntry object and knows about win32
		warn '# Executing '.$app->get_value('Name')." on $file\n";
		eval { $app->exec($file) };
		exit 1;
	}

	return 1; # assume fork worked OK
}

=item C<open_directory(DIR)>

Opens DIR in the file browser.

If it is unknown if we are dealing with a file or a dir, use C<open_file()>.

=cut

sub open_directory {
	my ($self, $dir, $open_file) = @_;
		# open_file is a private arg used by open_file() to
		# flag that we try to open a file instead of a dir

	my $browser = $self->_ask_app('file_browser', __('File browser')) #. application type
		or return 0;

	$dir = Zim::FS->localize($dir);
	my $file = $dir;
	if ($open_file or -f $dir) {
		# Get rid of the file part of the path
		my ($vol, $dirs, undef) = File::Spec->splitpath($dir);
		$dir = File::Spec->catpath($vol, $dirs);
	}

	unless (-d $dir) {
		# Check existense of the directory part
		my $answer = $self->prompt_question( 'question',
			__("<b>Folder does not exist.</b>\n\nThe folder: {path}\ndoes not exist, do you want to create it now?", path => $dir), #. Dialog question, answers are 'yes' or 'no'
			['no', 'gtk-no'], ['yes', 'gtk-yes'] );
		return 0 unless $answer eq 'yes';
		$dir->touch;
	}

	if ($open_file) {
		$browser =~ s/\%([fds])/($1 eq 'f') ? $file : $dir/eg
			or $browser .= " \"$dir\"";
		# %f means the filebrowser can open files directly
		#    this can be used if we don't have mime libraries
		#    but the filebrowser knows how to do it.
		# %d means we only try to open directories
		# %s is same as %d and is included for backwards compatibility
	}
	else {
		$browser =~ s/\%([fds])/$dir/eg
			or $browser .= " \"$dir\"";
	}

	Zim::Utils->run($browser);
	return 1;
}

sub _ask_app {
	my ($self, $key, $string) = @_;

	return $self->{settings}{$key} if $self->{settings}{$key};

	my $val = $self->run_prompt(
		__("Choose {app_type}", app_type => $string), #. dialog title
		['cmd'], {cmd => [__('Command'), 'string', $DEFAULTS{$key}]}, #. dialog input label
		undef, undef,
		__("Please enter a {app_type}", app_type => $string) ); #. dialog text
	my ($app) = @$val;
	$app = undef unless $app =~ /\S/;
	return $self->error_dialog(
		__("You have no {app_type} configured", app_type => $string) ) #. error
		unless defined $app;

	$self->{settings}{$key} = $app;
	$self->SaveSettings;
	return $app;
}

=item C<open_url(URL)>

Opens URL in the web browser.

=cut

sub open_url {
	my ($self, $url, $type) = @_;
	# type is a private argument used for error handling for interwiki

	$url =~ /^(\w[\w\+\-\.]+):/
		or return $type
			? $self->error_dialog(
				__("Can't find {url}", url => "$type?$url"))
			: $self->error_dialog(
				__("Not an url: {url}", url => $url)) ;
	my $proto = $1;

	my ($app, $string) = ($proto eq 'mailto')
		? ('email_client', __('Email client'))   #. application type
		: ('browser',      __('Web browser' )) ; #. application type
	$app = $self->_ask_app($app, $string) or return;

	$app =~ s/\%[us]/$url/ or $app .= " \"$url\"";
	Zim::Utils->run($app);
}

=item C<load_page(PAGE)>

Loads a new page, updates history etc. when necessary.
PAGE should be either an absolute page name, a history record or a page object.

use C<link_clicked()> for relative page names, urls etc.

=cut

sub load_page {
	my ($self, $page) = @_;

	$self->SaveIfModified or return
		if $self->{page};

	goto &_load_page;
}

sub _load_page { # load _without_ saving first
	my ($self, $page) = @_;
	my $prevpage = $self->{page};

	# See if we got a name, a page or a history record
	my ($rec, $name);
	($name, $page, $rec) =
		(ref($page) eq 'HASH') ? ($page->{name}, undef, $page) :
		 ref($page)            ? ($page->name,   $page, undef) :
		                         ($page,         undef, undef) ;
	warn "## GUI load_page: $name (obj: $page rec: $rec)\n";

	# Get page if we didn't get it as argument
	unless ($page) {
		return warn "WARNING: You tried to load an empty name.\n"
			unless length $name;

		eval { $page = $self->{notebook}->get_page($name) };
		return $self->error_dialog(
			__("Could not load page: {name}", name => $name)."\n\n$@", $@) if $@;
	}
	if (! defined $page or
		($self->{read_only} and ! $page->exists)
	) {
		my $tree = ['Page', {}, "\n", ['head1', {},
			__("This page does not exist\n404") ] ]; #. error: 404 - page not found
		$page ||= Zim::Page->new($self->{notebook}, $name);
		$page->set_source(undef); # orphane page
		$page->{properties}{read_only} = 0;
		$page->set_parse_tree($tree);
		$page->{properties}{read_only} = 1;
		$page->{properties}{is_error} = 404;
	}

	# Update history if we didn't get a record as argument
	# if we did get a record it is from GoBack() or GoForw()
	# and the history is updated already
	unless ($rec) { # get history record
		$rec = $self->{history}->set_current($name)
			if $self->{history};
	}
	$self->{page} = $page;

	# Actually load the page in the GUI
	eval { $self->PageView->load_page($page) };
	if ($@) {
		$self->exit_error(__("Could not load page: {name}", name => $name)."\n\n$@", $@);
		# TODO handle more gratiously .. use read_only ?
	}

	# Update various objects
	$self->{objects}{PageView}->set_state($rec->{state})
		if $rec and $rec->{state};
	$self->{history}->delete_recent($prevpage->name)
		if   $self->{history}
		and (defined $prevpage and ! $prevpage->exists);
	$self->TReadOnly($$page{properties}{read_only}||0);
	$self->signal_emit('page_loaded', $name);

	$self->update_status();
	my $links = scalar $page->list_backlinks;
	$self->{statusl}->set_text_with_mnemonic(
		__n("{number} _Back link", "{number} _Back links", number => $links).'...' );

	$self->{history}->write if $self->{history}; # Save history
}

=item C<TReadOnly(BOOLEAN)>

Toggle the read-only state of the application; BOOLEAN is optional.
This emits the C<t_read_only> signal.

=cut

sub TReadOnly {
	my ($self, $read_only, $force) = @_; # force is a private arg
	$read_only = $$self{read_only} ? 0 : 1 unless defined $read_only;
	#my @c = caller; warn "TR get $read_only ($$self{read_only}, $$self{read_only_lock}) from @c\n";
	unless ($force) {
		return if $$self{read_only_lock};
		return if $read_only == $$self{read_only};
	}
	$$self{read_only} = $read_only;
	$self->actions_set_sensitive(
		Save => !$read_only,
	);
	#warn "Emit t_read_only => $read_only\n";
	$self->signal_emit(t_read_only => $read_only);
	$self->update_status;
		# We want to show "[read-only]" in the statusbar
}

=back

=head2 Actions

The following methods map directly to the ui actions in the menu-
and toolbars.

=over 4

=item C<NewPage(PAGE)>

Open a dialog which allows you to enter a name for a new page.
PAGE is used to fill in the namespace in the dialog.

=cut

sub NewPage {
	my ($self, $ns) = @_;

	$ns ||= $self->{page};
	$ns =~ s/:?$/:/;
	$ns = '' if $ns eq ':';

	my $values = $self->run_prompt(
		__('New page'), #. dialog title
		['page'], {page => [__('Page name'), 'page', $ns]}, #. input
		'gtk-new', undef,
		__("Note that linking to a non-existing page\nalso automatically creates a new page.")
	);
	return unless $values;
	my ($page) = @$values;
	return unless $page =~ /\S/;

	$page = $self->check_page_input($page);
	return unless defined $page;

	$self->load_page(
		$self->{notebook}->resolve_name($page, $self->{page}) );

	$self->Save unless $$self{page}->exists; # touch new page
}

=item C<OpenNotebook(NOTEBOOK, PAGE)>

Open another notebook. NOTEBOOK can either be a directory path or a notebook
name. Without NOTEBOOK the "open notebook" dialog is prompted to the user.
When NOTEBOOK is given PAGE can be used to open the notebook at a certain page.

=cut

sub OpenNotebook {
	my ($self, $notebook, $page) = @_;
	$notebook = '_new_' unless defined $notebook;
	$page = $page->name if ref $page;

	# first try the daemon
	$self->call_daemon('open', $notebook, $page) and return;

	# We are not using daemon or daemon failed
	return $self->NotebookDialog->show() if $notebook eq '_new_';
		# Don't wait for return - NotebookDialog is not modal

	$notebook = Zim::FS->localize($notebook)
		if $notebook =~ m#/#; # path
	return $self->exec_new_window($notebook, $page);
}

=item C<Save()>

Force saving the current page and state.
Returns boolean for success.

=item C<SaveIfModified(SOFT)>

Save the page if it was modified.
Returns boolean for success or if page was not changed.

SOFT is an optional argument. If this argument is true the page may not be
saved if there is an issue. This is used to skip auto-saving in some cases.
Also "soft" changes may not be committed for version management etc.

=cut

sub Save {
	my $self = shift;
	warn "## GUI Save\n";
	$self->_save_page(1, 1) or return 0;
	$self->SaveState;
	return 1;
}

sub SaveIfModified {
	my ($self, $soft) = @_;
	return 1 if $self->{read_only};
		# even if modified due to bug no save for read_only
	return 0 if $self->{save_lock} and $soft;

	my $modified = $self->{objects}{PageView}->modified;

	warn "## GUI SaveIfModified\n" if $modified;
	return $self->_save_page($modified, !$soft);
}

# TODO part of this logic belongs in the PageView component

sub _save_page {
	my ($self, $save, $commit) = @_;
	$self->{save_lock} = 1; # Used to block autosave while "could not save" dialog

	my $page = $self->{page};
	eval {
		$self->PageView->save_page($page) if $save;
		$page->commit_change() if $commit;
	};
	if ($@) {
		my $error = $@;
		warn 'ERROR: '.$error;
		my $answer = $self->prompt_question( 'error',
			'<b>'.__("Could not save page")."</b>\n\n$error", # dialog message
			['cancel', 'gtk-cancel', undef ],
			['discard', 'gtk-delete', __('_Discard changes')], #. dialog button
			['copy', 'gtk-save-as', __('_Save a copy...')], #. dialog button
			3 );
		if ($answer eq 'discard') {
			$self->{page}->discard_change;
			$self->_load_page($self->{page}); # load page wihtout saving
		}
		elsif ($answer eq 'copy') {
			return $self->CopyPage; # recurs indirectly
		}
		else { return 0 } # return _without_ removing save_lock
	}

	$self->update_status();
	$self->{save_lock} = 0;
	return 1;
}

=item C<SaveVersion(COMMENT)>

Prompt for a comment and commit a version. COMMENT is an optional argument
and will be used as the suggested comment in the dialog.

If no version control is enabled prompt for initializing version control.

=item C<Versions()>

Show the versions dialog, see L<Zim::GUI::VersionsDialog>.

=item C<init_vcs_dialog()>

Prompt user to initialize version control, called by C<SaveVersion()>.

=cut

sub SaveVersion {
	my ($self, $comment) = @_;
	$self->SaveIfModified or return;

	return $self->init_vcs_dialog unless $$self{notebook}{vcs};

	# saved log
	my $cache_dir = $$self{notebook}->get_notebook_cache;
	my $log = defined($cache_dir)
		? $cache_dir->file('version-comment.txt')
		: undef ;
	if (defined $log and $log->exists) {
		$comment =~ s/\n?$/\n\n/ if $comment =~ /\S/;
		$comment .= $log->read;
	}
	else { $comment ||= "Saved version from zim" }

	# prompt for comment
	my $dialog = Gtk2::Dialog->new(
		__('Save version').' - Zim', $$self{window}, #. dialog title
		[qw/modal destroy-with-parent no-separator/],
		'gtk-help' => 'help',
		'gtk-cancel' => 'cancel',
		'gtk-save' => 'ok'
	);
	#$dialog->vbox->set_spacing(5);
	$dialog->set_default_size(300, 150);

	my $vpane = Gtk2::VPaned->new;
	$dialog->vbox->add($vpane);
	my $vbox1 = Gtk2::VBox->new;
	$vpane->add1($vbox1);
	my $vbox2 = Gtk2::VBox->new;
	$vpane->add2($vbox2);

	# label and input text field
	$vbox1->pack_start(
		Gtk2::Label->new(__('Please enter a comment for this version')), #. dialog text
		0,1,0 );
	my ($scroll, $view) = $self->new_textview;
	$view->get_buffer->set_text( $comment ) if $comment =~ /\S/;
	$view->set_editable(1);
	$vbox1->add($scroll);

	# status
	my $label = Gtk2::Label->new('<b>'.__('Details').'</b>'); #. label
	$label->set_use_markup(1);
	$label->set_alignment(0,0.5);
	$vbox2->pack_start($label, 0,1,0);

	my ($stscroll, $stview) = $self->new_textview(
		$$self{notebook}{vcs}->status );
	$vbox2->add($stscroll);
	my $hbox = Gtk2::HBox->new;
	$vbox2->pack_start($hbox, 0,1,0);
	my $cbutton = Gtk2::Button->new(__('_Notebook Changes...')); #. button
	$cbutton->signal_connect(clicked =>
		sub { $self->VersionsDialog->Diff } );
	$hbox->pack_end($cbutton, 0,1,0);

	# and run
	$dialog->show_all;
	while (my $re = $dialog->run) {
		if ($re eq 'help') {
			$self->ShowHelp(':Usage:VersionControl');
			next;
		}

		my ($start, $end) = $view->get_buffer->get_bounds;
		$comment = $view->get_buffer->get_text($start, $end, 0);
		$log->write($comment) if defined $log and $comment =~ /\S/;
			# write log for next instance of this dialog
		$dialog->destroy;
		if ($re eq 'ok') {
			return $self->error_dialog(
				__('Can not save a version without comment') ) #. error
				unless $comment =~ /\S/;
			eval { $$self{notebook}{vcs}->commit($comment) };
			return $self->error_dialog(
				__('Could not save version')."\n\n$@") if $@; #. error
			$log->remove if defined $log;
				# if commit succesfull log can be deleted
		}
		last;
	}
}

sub Versions { pop->VersionsDialog->show() }

sub init_vcs_dialog {
	my $self = shift;

	my $text = __("<b>Enable Version Control</b>\n\nVersion control is currently not enabled for this notebook.\nDo you want to enable it ?") #. question dialog, options are 'help', 'cancel' and 'ok'
	         . "\n\n"
		 . __("You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.\nPlease click 'help' to read about the system requirements.") ; #. detailed notice in prompt to enable version control
	my $answer = $self->prompt_question(
		'question', $text,
		[help   => 'gtk-help'],
		[cancel => 'gtk-cancel'],
		[svn    => undef, 'Subversion' ],
		[bzr    => undef, 'Bazaar'],
	);

	my $vcs = undef;
	my $args = {};
	if ($answer eq 'bzr') { $vcs = 'Bazaar' }
	elsif ($answer eq 'svn') {
		my $val = $self->run_prompt(
			'Enter SVN repository',
			['url','username','password'],
			{
				url => ['SVN repository URL', 'string', 'http://'],
				username => ['Username', 'string', ''],
				password => ['Password', 'password', ''],
			}
		);
		return unless $val;
		$args = {
			'url' => $$val[0],
			'username' => $$val[1],
			'password' => $$val[2],
		};
		$vcs = 'Subversion';
	}
	elsif ($answer eq 'help') {
		$self->ShowHelp(':Usage:VersionControl');
		return;
	}
	else { return }

	if (defined $vcs) {
		eval { $$self{notebook}->init_vcs($vcs, $args) };
		return $self->error_dialog( __('Could not initialize version control')."\n\n$@" ) if $@ or ! $$self{notebook}{vcs}; #. error dialog
		$self->Reload; # purge page object
		$self->actions_set_sensitive(Versions => 1);
		$self->SaveVersion( __("Initial version") ) # indirect recurs #. default comment for first version after initializing version control
	}
}

=item C<Export()>

Show the export dialog, see L<Zim::GUI::ExportDialog>.

=cut

sub Export { pop->ExportDialog->show() }

=item C<EmailPage()>

Open the current page in the email client.

=cut

sub EmailPage {
	my $self = shift;
	$self->SaveIfModified or return;
	my $subject = $self->{page}->name;
	my $src = $self->{page}->get_text;
	$src =~ s/^Content-Type:.*?\n\n//s; # get rid of headers
	$src =~ s/(\W)/sprintf '%%%02x', ord $1/eg; # url encoding
	$self->open_url("mailto:?subject=$subject&body=".$src);
}

=item C<CopyPage()>

Prompt the user to save a copy of the current page.

=cut

sub CopyPage {
	my ($self, $page) = @_;
	$page ||= $$self{page};

	my $copy_current = $$self{page}->equals($page);
	my $save = $self->SaveIfModified(!$copy_current);
	return 0 if $copy_current and !$save;

	# prompt page
	my $new = __('{name}_(Copy)', name => $page); #. default name for new page in save copy action
	my $val = $self->run_prompt(
		__('Save Copy'), #. dialog title
		['page'], {page => [__('Page'), 'page', $new]}, #. enrty label
		'gtk-save-as', __('_Save Copy'), #. save button
		__('Please enter a name to save a copy of page: {page}', page => $page) ); #. dialog text
	return unless defined $val;
	($new) = @$val;
	return unless length $new;

	my $l = $self->check_page_input($new);
	$new = $self->{notebook}->resolve_page($l);
	return $self->error_dialog(
		__("Can not save to page: {name}", name => $l) )
		unless $new;

	# check if page exists
	if ($new->exists()) {
		my $answer = $self->prompt_question( 'warning',
			__("<b>Page already exists</b>\n\nThe page '{name}'\nalready exists.\nDo you want to overwrite it?", name => $new), #. warning dialog, answers are 'cancel' or 'ovewrite'
			['cancel', 'gtk-cancel', undef],
			['overwrite', undef, __('_Overwrite')] ); #. save button
		return unless $answer eq 'overwrite';
	}

	# finally copy page
	$$self{notebook}->copy_page($page => $new);
	$self->signal_emit(page_created => $new);

	return 1;
}

=item C<RenamePage(FROM, TO, UPDATE_SELF, UPDATE_OTHER)>

Wrapper for C<< Zim->move_page() >>.

Move page from FROM to TO. If TO is undefined a dialog is shown to ask for a
page name.

UPDATE_SELF is a boolean telling to update all links in this page.
UPDATE_OTHER is a boolean telling to update all links to this page.

Without arguments prompts the user for input.

Returns boolean for success.

=cut

sub RenamePage {
	my ($self, $from, $to, @update) = @_;

	$from = $self->{page}->name unless defined $from;

	my $move_current = $self->{page}->equals($from);
	my $save = $self->SaveIfModified(!$move_current);
	return 0 if $move_current and !$save;

	unless (defined $to) {
		($to, @update) = $self->prompt_rename_page_dialog($from);
		$self->check_page_input($to);
		return 0 unless defined $to;
		my $t = $self->{notebook}->resolve_page($to);
		if ($t eq $from) { # Case sensitive move
			# FIXME call to resolve case sensitive
			# this one only works for absolute names
			$to = $self->{notebook}->get_page($to);
		}
		else { $to = $t }
	}

	# Get backlinks
	my $rfrom = $move_current ? $self->{page} : $self->{notebook}->get_page($from); # FIXME ugly lookup
	my @backlinks = $rfrom->list_backlinks();

	# Move page
	#warn "Move '$from' to '$to'\n";
	eval { $self->{notebook}->move_page($from, $to) };
	return $self->error_dialog(
		__("Could not rename {from} to {to}", from => $from, to => $to)."\n\n$@") #. error message
		if $@;

	if (grep $_, @update) { # Update backlinks
		my ($dialog, $bar, $label) = $self->new_progress_bar(
			__("Updating links"), #. dialog title
			__('Updating..') );   #. progress bar label
		my $continue = 1;
		$dialog->signal_connect(response => sub {$continue = 0});
		my $i = 1;
		my $callback = sub {
			my $page = shift;
			$bar->pulse;
			$label->set_text(
				__('Updating links in {name}', name => $page)); #. progress bar label
			while (Gtk2->events_pending) { Gtk2->main_iteration_do(0) }
			return $continue;
		};
		eval {
			if ($update[0]) { # UPDATE_SELF
				$callback->($to);
				$self->{notebook}->get_page($to)
					->update_links_self($from);
			}
			if ($update[1]) { # UPDATE_OTHER
				for (@backlinks) {
					$callback->($_) or last;
					$self->{notebook}->get_page($_)
						->update_links(	$from => $to );
				}
			}
		};
		$self->error_dialog($@) if $@;
		$dialog->destroy;
	}

	warn "# moved $from => $to\n";
	$self->{history}->delete_recent("$from") if $self->{history};
	$self->signal_emit('page_renamed', $from => $to);
	$self->load_page($to) if $move_current;

	$self->update_status;
	return 1;
}

=item C<DeletePage(PAGE, RECURS, NO_CONFIRM)>

Wrapper for C<< Zim->delete_page >>.
Asks the user for confirmation.

If PAGE is undefined the current page is deleted.

TODO: make recusive delete work

=cut

sub DeletePage {
	# FIXME option to delete a complete sub-tree
	# FIXME integrate with the save_page() logic, now we have
	# redundant code here
	my ($self, $page, undef, $noconf) = @_;
	$page = $self->{page}->name unless defined $page;

	my $name = ref($page) ? $page->name : $page;
	my $delete_current = ($name eq $self->{page}->name);
	$self->SaveIfModified(!$delete_current);

	unless ($noconf) {
		my $r = $self->prompt_question( 'warning',
		__("<b>Delete page</b>\n\nAre you sure you want to delete\npage '{name}' ?", name => $name), #. warning dialog, answers are 'cancel' or 'delete'
			['no',  'gtk-cancel', undef],
			['yes', 'gtk-delete', undef]  );
		return unless $r eq 'yes';
	}

	$page = $self->{page} if $delete_current; # make sure we have the right object
	eval { $self->{notebook}->delete_page($page) };
	return $self->error_dialog(
		__("Could not delete page: {name}", name => $name)."\n\n$@") if $@; #. error message

	# TODO trigger this with signals
	$self->{history}->delete_recent($name) if $self->{history};
	$self->signal_emit('page_deleted', $name);

	$self->load_page($page) if $delete_current;

	$self->update_status;
}

=item C<Props()>

Show the properties dialog, see L<Zim::GUI::PropertiesDialog>.

=cut

sub Props { $_[0]->PropertiesDialog->show }

=item C<Close()>

Close the application. When using the TrayIcon plugin this only hides
the window. Does not effect other instances.

=item C<Quit()>

Quit the application. Also closes all other instances of zim.

=cut

sub Close {
	$_[0]->on_delete_event($_[1]) || Gtk2->main_quit;
}

sub Quit {
	$_[0]->call_daemon('broadcast', 'Close', 'FORCE');
	$_[0]->Close('FORCE');
}

sub on_delete_event {
	# Called when the window is deleted or by the Close action
	# return true to avoid destruction in both cases
	my $self = shift;
	my $force = uc(shift) eq 'FORCE';

	# try to get window state, eval because window may be destroyed already
	eval {
		my ($state, $window) = @{$self}{'state', 'window'};
		@{$state}{'width', 'height'} = $window->get_size;
		@{$state}{'x', 'y'} = $window->get_position if $window->visible;
			# position is 0,0 when window is hidden
	};

	# save state etc. no matter if we really destruct or not
	$self->SaveIfModified() || return 1;
	$self->SaveState;
	$$self{history}->write if $$self{history}; # Save history

	# Hide window already to make it look snappy
	$$self{window}->hide;
	while (Gtk2->events_pending) { Gtk2->main_iteration_do(0) }

	# clean up tmp files - match name Zim::FS->tmp_file
	my $dir = dir( Zim::FS->tmpdir );
	my @files = grep /^zim-$ENV{USER}-$$-/, $dir->list;
	for (@files) {
		eval { $dir->file($_)->remove };
		warn $@ if $@;
	}

	# check if we really destruct or not
	return 1 if $$self{hide_on_delete} and !$force;

	# autosave version
	eval { $$self{notebook}{vcs}->commit("Autosave version from zim") }
		if  $$self{notebook}{vcs}
		and $$self{notebook}{config}{autosave_version} ;

	# check umounting
	my $mount = $$self{notebook}{automount};
	eval {
		my $path = $$self{notebook}{file} || $$self{notebook}{dir} ;
		Zim::GUI::Automount->umount($path, $mount);
	} if $mount ;

	return 0 
}

=item C<CopyLocation(PAGE, ...)>

Copies a list of page names to the clipboard.
Without argument uses the current page.

=cut

sub CopyLocation {
	my ($self, @pages) = @_;
	@pages = map {ref($_) ? $_->name : $_} @pages;
	unless (@pages) {
		@pages = $self->PageView->has_focus ? $self->{page}->name :
		         $self->TreeView->has_focus ? $self->TreeView->get_selected : undef ;
	}
	my $clipboard = Gtk2::Clipboard->get(
		Gtk2::Gdk::Atom->new('CLIPBOARD') );
	$clipboard->set_with_data(
		\&_clipboard_get, \&_clipboard_clear, \@pages,
		['text/x-zim-page-list', [], 0],
		$self->list_text_targets(1) );
}

sub _clipboard_get {
	my ($clipboard, $selection, $id, $list) = @_;
	#print STDERR '_clipboard_get type: '.$selection->target->name."\n";

	if ($selection->target->name eq 'text/x-zim-page-list') {
		my $data = Zim::GUI::Component->encode_uri_list(@$list);
		my $type = Gtk2::Gdk::Atom->new('text/x-zim-page-list');
		$selection->set($type, 8, $data);
	}
	else { # text
		my $text = join '', map "$_\n", @$list;
		$selection->set_text($text);
	}
}

sub _clipboard_clear { } # do nothing

=item C<Prefs()>

Show the preferences dialog, see L<Zim::GUI::PreferencesDialog>.

=cut

sub Prefs { shift->PreferencesDialog->show }

#=item C<EditToolBar()>
#
#=cut
#
#sub EditToolBar { shift->ToolBarEditor->show }

=item C<TToolBar(BOOL)>

Toggel toolbar visibility.
If BOOL is undefined it will just toggle the current state.

=cut

sub TToolBar {
	my ($self, $show) = @_;
	my $toolbar = $$self{toolbar};
	$show = $toolbar->visible ? 0 : 1 unless defined $show;
	$show ? $toolbar->show_all : $toolbar->hide_all ;
	$self->actions_show_active(TToolBar => $show);
	unless ($show == $$self{settings}{toolbar_vis}) {
		$$self{settings}{toolbar_vis} = $show;
		$self->SaveSettings; # not important enough for NOTIFY
	}
}

=item C<TStatusBar(BOOL)>

Toggle statusbar visibility.
If BOOL is undefined it will just toggle the current state.

=cut

sub TStatusBar {
	my ($self, $show) = @_;
	my $statusbar = $$self{statusbar};
	$show = $statusbar->visible ? 0 : 1 unless defined $show;
	$show ? $statusbar->show_all : $statusbar->hide_all ;
	$self->actions_show_active(TStatusBar => $show);
	unless ($show == $$self{settings}{statusbar_vis}) {
		$$self{settings}{statusbar_vis} = $show;
		$self->SaveSettings; # not important enough for NOTIFY
	}
}

=item C<TPane(BOOL)>

Toggle visibility of the side pane.
If BOOL is undefined it will just toggle the current state.
If BOOL is "-1" the pane will be shown, but hidden again as soon
as a page is selected.

=cut

sub TPane {
	my ($self, $show) = @_;
	$show = $self->{l_vbox}->visible ? 0 : 1 unless defined $show;

	$self->{_pane_visible} = $show;
	my $widget = $self->{l_vbox};
	my $hpaned = $self->{hpaned};
	if ($show) {
		$hpaned->set_position($self->{state}{pane_pos});
		my $tree_view = $self->TreeView;
		unless ($tree_view->widget->get_parent) {
			# treeview just autoloaded - add to side pane
			$tree_view->load_index();
			$tree_view->signal_connect(row_activated =>
				sub { $self->TPane(0) if $self->{_pane_visible} == -1 } );
			$widget->add($tree_view->widget);
		}
		$widget->show_all;
		$tree_view->grab_focus;
	}
	else {
		$self->{state}{pane_pos} = $hpaned->get_position();
		$widget->hide_all;
		$self->PageView->grab_focus;
	}

	$self->{state}{pane_vis} = $show unless $show == -1;
	$self->actions_show_active(TPane => $show);
}

=item C<TPathBar(TYPE)>

Set the pathbar type to TYPE.

=cut


sub on_TPathBar {
	# get the type from the action name
	my $self = pop;
	return if $self->{_block_actions};
	my $type = lc pop->get_name;
	$type =~ s/^pb//;
	$self->TPathBar($type);
}

sub TPathBar {
	my ($self, $type) = @_;
	return warn "BUG: No pathbar type given" unless defined $type;

	my $path_bar = $self->{objects}{PathBar};
	if (grep {$type eq $_} qw/recent history namespace/) {
		$path_bar->widget->show_all;
		$path_bar->set_type($type);
	}
	elsif ($type eq 'hidden') {
		$path_bar->widget->hide_all;
		$path_bar->clear_items;
	}
	else { warn "BUG: unknown pathbar_type: $type" }

	$self->actions_show_active('PB'.ucfirst($type) => 1);
	unless ($$self{settings}{pathbar_type} eq $type) {
		$$self{settings}{pathbar_type} = $type;
		$self->SaveSettings; # not important enough for NOTIFY
	}
}

=item C<TBar_iconsize(SIZE)>

Set the toolbar type to Gtk2::IconSize SIZE.

=cut

sub on_TBar_iconsize { # Gtk2::RadioAction, Gtk2::RadioAction, ZIM::GUI
	my $self = pop;
	return if $self->{_block_actions};
	my $action = pop;
	$action = lc substr($action->get_name, 2);
	$self->TBar_iconsize($action);
}

sub TBar_iconsize {
	my ($self, $type) = @_;
	return warn "BUG: No toolbar type given" unless defined $type;
	my $tool_bar = $self->{toolbar};
	$tool_bar->set_icon_size($type);

	$self->actions_show_active("TB$type" => 1);
	unless ($$self{settings}{toolbar_iconsize} eq $type) {
		$$self{settings}{toolbar_iconsize} = $type;
		$self->SaveSettings; # not important enough for NOTIFY
	}
}

=item C<TBar_style(VAL)>

Set the toolbar type to Gtk2::ToolbarStyle

=cut

sub on_TBar_style { # Gtk2::RadioAction, Gtk2::RadioAction, ZIM::GUI
	my $self = pop;
	return if $self->{_block_actions};
	my $action = pop;
	$action = lc substr($action->get_name, 2);
	$self->TBar_style($action);
}

sub TBar_style {
	my ($self, $type) = @_;
	return warn "BUG: No toolbar type given" unless defined $type;
	my $tool_bar = $self->{toolbar};
	$tool_bar->set_style($type);

	$self->actions_show_active("TB$type" => 1);
	unless ($$self{settings}{toolbar_style} eq $type) {
		$$self{settings}{toolbar_style} = $type;
		$self->SaveSettings; # not important enough for NOTIFY
	}
}

=item C<Reload()>

Save and reload the current page.

=cut

sub Reload { $_[0]->load_page( "$_[0]->{page}" ) if $_[0]->{page} }


=item C<Search($QUERY)>

Open QUERY in the search dialog.

=cut

sub Search { $_[0]->SearchDialog->search($_[1]) }

=item C<SearchBL()>

Open backlinks for current page in search dialog.

=cut

sub SearchBL {
	my $self = shift;
	#$self->SearchDialog->search('LinksTo: "'.$$self{page}->name.'"');
	$self->SearchDialog->search($$self{page}->name);
}

=item C<OpenFolder()>

Open the document dir for the current page. See<Zim::Store/document_dir>.

=item C<OpenRootFolder()>

Open the document root folder. See L<Zim::Store/document_root>.

=cut

sub OpenFolder {
	my $self = shift;
	my $dir = $$self{page}->document_dir;
	return $self->error_dialog(
		__("This page does not have a document folder") ) #. error
		unless $dir;

	# open_directory asks to create directory if it doesn't exist
	my $ok = $self->open_directory($dir);
	if (! $ok) {
		# dir did not exist and user didn't create it
		# try top level document dir as backup
		$dir = $$self{notebook}->document_dir;
		$self->open_directory($dir) if $dir->exists;
	}
}

sub OpenRootFolder {
	my $self = shift;
	my $dir = $$self{notebook}->document_root;
	return $self->error_dialog(
		__("This notebook does not have a document root") ) #. error
		unless $dir;
	# No need here for a dialog asking to create the dir,
	# this is a global dir - assume it exists.
	$self->open_directory($dir);
}

=item C<EditSource(PAGE)>

Open PAGE or the current page in an external editor.

=cut

sub EditSource {
	my ($self, $page, $file) = @_; # file is a private argument
	# If file is given it could be e.g. a config file, in this 
	# case we do not do anything with pages.
	unless ($file) {
		$self->SaveIfModified;
		$page ||= $self->{page};

		# Write source to tmp file
		return $self->error_dialog(__("This page does not have a source"))
			unless $page->has_source;
		my $fh = $page->open_source('r');
		$file = Zim::FS->tmp_file('EditSource.txt');
		$file->write(<$fh>);
		$fh->close;
	}

	# Find editor
	my $editor = $self->_ask_app('text_editor', __('Text Editor')) #. application type
		or return;
	$editor =~ s/\%[sf]/$file/ or $editor .= " \"$file\"";

	# Execute - GUI will hang while waiting for system to return,
	#           so we can be sure buffer is not modified in between.
	warn "# Executing: $editor\n";
	if (system($editor) == 0 and defined $page) {
		# Save source
		my $fh = $page->open_source('w');
		print $fh $file->read;
		$fh->close;
		$self->Reload;
	}
}

=item C<AttachFile(FILE, NO_ASK)>

Wrapper for C<< $page->store_file >>. Opens a filechooser dialog and copies
the selected file to the document directory for the current page and inserts
a link in the page.

Doesn't show the dialog if both FILE and NO_ASK are defined.

=cut

sub AttachFile {
	# TODO add checkbox for copy/move behavior - forward bool to store_file
	my ($self, $file, $no_ask) = @_;
	unless (defined $file and $no_ask) {
		$file = $self->filechooser_dialog($file, 0, 'Attach File');
		return unless defined $file;
	}
	return unless $file =~ /\S/;
	my $link = $$self{page}->store_file( file($file) );
		# file is always expected to be absolute and outside notebook
		# maybe check this ?
	$self->PageView->InsertLink($link, $link, 'NO_ASK');
}


=item C<RBIndex()>

Rebuild the index cache.

=cut

sub RBIndex {
	my $self = shift;
	$self->{notebook}->_flush_cache;
	my $tree = $self->TreeView;
	$tree->{_loaded} = 0;
	$tree->load_index;
}


=item C<GoBack($INT)>

Go back one or more steps in the history stack.

=item C<GoForward($INT)>

Go forward one or more steps in the history stack.

=cut

sub GoBack {
	my $self = shift;
	my $i = shift || 1;
	return unless $self->{history};
	my $rec = $self->{history}->back($i) || return;
	$self->load_page($rec);
}

sub GoForward {
	my $self = shift;
	my $i = shift || 1;
	return unless $self->{history};
	my $rec = $self->{history}->forw($i) || return;
	$self->load_page($rec);
}

=item C<GoParent()>

Go to page up in namespace.

=item C<GoChild()>

Go to page down in namespace.

=cut

sub GoParent {
	my $self = shift;
	my $namespace = $self->{page}->namespace;
	return if $namespace eq ':';
	$namespace =~ s/:+$//;
	$self->load_page($namespace);
}

sub GoChild {
	my $self = shift;
	return unless $self->{history};
	my $namespace = $self->{history}->get_namespace;
	my $name = $self->{page}->name;
	return unless $namespace =~ /^(:*\Q$name\E:+[^:]+)/;
	$self->load_page($1);
}

=item C<GoNext()>

Go to the next page in the index.

=item C<GoPrev()>

Go to the previous page in the index.

=cut

sub GoNext {
	my $self = shift;
	my $page = $self->{page}->get_next;
	$self->load_page($page) if $page;
}

sub GoPrev {
	my $self = shift;
	my $page = $self->{page}->get_prev;
	$self->load_page($page) if $page;
}

=item C<GoHome()>

Go to the home page.

=cut

sub GoHome { $_[0]->load_page($_[0]->{home}) }

=item C<JumpTo(PAGE)>

Go to PAGE. Shows a dialog when no page is given.

=cut

sub JumpTo {
	my ($self, $page) = @_;

	unless (defined $page) {
		my $ns = $self->{page}->namespace;
		$ns = '' if $ns eq ':';
		my $values = $self->run_prompt(
			__('Jump to'), #. dialog title
			['page'], {page =>
				[__('Jump to Page'), 'page', $ns] #. dialog label
			},
			'gtk-jump-to', undef, undef );
		return unless $values;
		($page) = @$values;
		return unless $page =~ /\S/;
	}
	elsif (ref $page) {
		return $self->load_page($page);
	}

	$page = $self->check_page_input($page);
	return unless defined $page;

	$self->load_page(
		$self->{notebook}->resolve_name($page, $self->{page}) );
}

=item C<ShowHelpFAQ()>

=item C<ShowHelpKeys()>

=item C<ShowHelpBugs()>

Shows help on FAQ, keybindings and bugs. Defined for corresponding menu items.
Trying to seduce people to actually read the manual...

=cut

sub ShowHelpFAQ  { $_[0]->ShowHelp(':FAQ') }

sub ShowHelpKeys { $_[0]->ShowHelp(':usage:keybindings') }

sub ShowHelpBugs { $_[0]->ShowHelp(':bugs') }

=item C<About()>

This dialog tells you about the version of zim you are using.

=cut

sub About {
	my $self = shift;
	my %info = (
		program_name => 'Zim',
		version => $Zim::VERSION,
		copyright => $Zim::COPYRIGHT,
		license => $Zim::LONG_VERSION,
		authors => $Zim::AUTHORS,
		translator_credits => $Zim::TRANSLATORS,
		logo => Gtk2::Gdk::Pixbuf->new_from_file($Zim::ICON),
		# logo-icon-name => 'zim',
		comments => 'A desktop wiki',
		website => $Zim::WEBSITE,
	);
	$info{translator_credits} =~ s/^\n+//;

	if (Gtk2->CHECK_VERSION(2, 6, 0)) {
		my $hook = sub {$self->link_clicked($_[1])};
		Gtk2::AboutDialog->set_url_hook($hook);
		Gtk2::AboutDialog->set_email_hook($hook);
		Gtk2->show_about_dialog($self->{window}, %info);
	}
	else { # Gtk 2.4
		my $dialog = Gtk2::Dialog->new(
			'About Zim', $self->{window},
	       		[qw/modal destroy-with-parent no-separator/],
			'gtk-close' => 'close',
		);
		$dialog->set_resizable(0);
		$dialog->set_border_width(5);
		$dialog->set_icon($self->{window}->get_icon);
		my $button = $self->new_button('gtk-help', '_More');
		$dialog->add_action_widget($button, 'help');
		$dialog->set_default_response('close');

		$dialog->vbox->add(
			Gtk2::Image->new_from_file($Zim::ICON) );
		my $text = $Zim::LONG_VERSION;
		$text =~ s/^(.*)$/\n<b>$1<\/b>/m; # Make first line bold
		my $label = Gtk2::Label->new();
		$label->set_markup($text);
		$label->set_justify('center');
		$dialog->vbox->add($label);

		$dialog->show_all;
		my $response = $dialog->run;
		$dialog->destroy;

		$self->ShowHelp(':about') if $response eq 'help';
	}
}

=back

=head2 Other functions

Functions below are used by other methods.
They are not considered part of the api.

=over 4

=item C<update_status()>

Sets the statusbar to display the current page name and some other
information.

=cut

sub update_status {
	my $self = shift;
	my $stat = ' '.$self->{page}->name;
	$stat .= '*' if $self->PageView->modified;
	if (my $s = $self->{page}->status()) { $stat .= '  -  '.uc($s) }
	$stat .= ' [readonly]'
		if $self->{read_only}
		or $self->{page}{properties}{read_only} ;
	$self->push_status($stat, 'page');
}

=item C<push_status(STRING, CONTEXT)>

Put STRING in the status bar.

=cut

sub push_status {
	my ($self, $str, $id) = @_;
	my $statusbar = $self->{status1};
	$id = $statusbar->get_context_id($id);
	$statusbar->pop($id);
	$statusbar->push($id, $str);
}

=item pop_status(CONTEXT)

Removes a string from the status bar.

=cut

sub pop_status {
	my ($self, $id) = @_;
	my $statusbar = $self->{status1};
	$id = $statusbar->get_context_id($id);
	$statusbar->pop($id);
}

=item C<prompt_rename_page_dialog(PAGE)>

Runs a dialog that gathers info for moving a page.
Returns new page name and update boolean.

=cut

sub prompt_rename_page_dialog {
	my ($self, $page) = @_;

	my ($dialog, $entries) = $self->new_prompt(
		__('Rename page'), #. dialog title
		['page'], {page =>
			[__('Rename to'), 'page', $page] #. dialog label
		},
		'gtk-save', __('_Rename')  ); #. save button

	my ($entry) = @$entries;
	$entry->select_region(length($1), -1) if $page =~ /^(.+:)/;

	my $rpage = ($page eq $self->{page}->name) ? $self->{page} : $self->{notebook}->get_page($page); # FIXME ugly lookup
	my $nlinks = scalar $rpage->list_backlinks;
	my $check1 = Gtk2::CheckButton->new(
		__("_Update links in this page")); # check box
	my $check2 = Gtk2::CheckButton->new(
		__n("_Update {number} page linking here", "_Update {number} pages linking here", number => $nlinks)); # check box
	$check1->set_active(1);
	if ($nlinks > 0) { $check2->set_active(1)    }
	else             { $check2->set_sensitive(0) }
	$check1->show;
	$check2->show;
	$dialog->vbox->add($check1);
	$dialog->vbox->add($check2);

	if ($dialog->run eq 'ok') { $page = $entry->get_text }
	else                      { $page = undef            }
	my $up1 = $check1->get_active;
	my $up2 = $check2->get_active;
	$dialog->destroy;

	$page = undef unless $page =~ /\S/;
	return defined($page) ? ($page, $up1, $up2) : ();
}

1;

__END__

=back

=head1 BUGS

Please mail the author if you find any bugs.

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<zim>(1),
L<Zim>,
L<Zim::GUI::Component>

=cut

