package Zim::GUI::Component;

use strict;
use vars qw/$AUTOLOAD/;
use Gtk2;
use Carp;
use Encode;
use File::BaseDir 0.03 qw/data_dirs data_files/;
use Zim::Events;
use Zim::Utils;

our $VERSION = '0.27';

our @ISA = qw/Zim::Events/;

$Zim::ICON = data_files('pixmaps', 'zim.png');
warn "WARNING: Could not find 'zim.png', is \$XDG_DATA_DIRS set properly ?\n"
	unless length $Zim::ICON;

{ # load all icons in pixmaps/zim
	my @files = length($Zim::ICON) ? ($Zim::ICON) : ();
	for my $dir (data_dirs('pixmaps', 'zim')) {
		$dir = dir($dir);
		push @files, map $dir->file($_), $dir->list;
	}
	return unless @files;

	my $factory = Gtk2::IconFactory->new;
	$factory->add_default;
	my %icons;
	for my $f (@files) {
		my $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($f);
		my $icon_set = Gtk2::IconSet->new_from_pixbuf($pixbuf);
		my $n = $f;
		$n =~ s/.*[\/\\]//;
		$n =~ s/\..*//;
		next if exists $icons{$n};
		$icons{$n} = $f;
		#warn "Icon: $n => $f\n";
		$factory->add($n => $icon_set);
	}
}

=head1 NAME

Zim::GUI::Component - GUI base class

=head1 SYNOPSIS

FIXME example of a component init using actions etc.

=head1 DESCRIPTION

This class provides a base class for GUI components in zim.
Modules can inherit a number of convenience methods from it.

Most GUI methods expect the C<{app}> attribute to be set.
This aplication object is expected to have attributes
C<{ui}> and C<{window}>.

=head1 METHODS

=over 4

=item C<new(%ATTRIBUTES)>

Simple constructor, calls C<init()>.

=cut

our $_popup_args; # used to pass args to UI popups

sub new {
	my $class = shift;
	my $self = bless {@_}, $class;
	$self->{_block_actions} = 0;
	$self->init();
	return $self;
}

=item C<init()>

Called by the constructor, to be overloaded.

=cut

sub init {};

=item C<init_settings(NAME, \%DEFAULTS)>

Will initialise a hash C<$$self{settings}> which is linked to section NAME
in the config file. Intended for use by plugin modules.

When the whole section is missing it will be initialized with %DEFAULTS.

When called on the main application object it will not change
C<$$app{settings}> but only return the hash for the section requested.

=item C<init_state(NAME, \%DEFAULTS)>

Like C<init_settings()> but initializes C<$$self{state}> and links to
the file with state variables, not the config file.

=cut

sub init_settings { _init_config_hash('settings', @_) }

sub init_state    { _init_config_hash('state', @_)    }

sub _init_config_hash {
	my ($hash, $self, $name, $defaults) = @_;
	unless ($$self{app}{$hash}{$name}) {
		$$self{app}{$hash}{$name} = $defaults || {};
		$$self{app}->SaveSettings if $hash eq 'settings';
	}
	$$self{$hash} = $$self{app}{$hash}{$name}
		unless $self eq $$self{app};
		# Exception in case we are called on top level object
	croak "BUG: not a hash: $name\n" unless ref $$self{$hash} eq 'HASH';
	return $$self{app}{$hash}{$name};
}

=item C<widget()>

Returns the "top_widget" attribute. This should be the toplevel widget
for the GUI managed by this object.

=cut

sub widget { $_[0]->{top_widget} }

=item C<AUTOLOAD()>

Autoloader for object methods.

If you have a C<{widget}> attribute in your object this will be
the target for unknown methods.

=cut

sub AUTOLOAD {
	$AUTOLOAD =~ s/^.*:://;
	return if $AUTOLOAD eq 'DESTROY';
	#warn "AUTOLOAD: $AUTOLOAD(@_)\n";
	#warn "AUTOLOAD caller: ", caller(), "\n";
	if ($AUTOLOAD =~ s/^on_(\w+)$/$1/) { # could be an action handler
		my $self = pop;
		return if $self->{_block_actions};
		if ($AUTOLOAD =~ s/^popup_//) { # popup menu
			return $self->$AUTOLOAD(
				defined($_popup_args) ? (@$_popup_args) : () );
		}
		else {
			# GUI action, first try dispath, then default method
			my $r = $self->signal_dispatch($AUTOLOAD);
			return $r ? $r : $self->$AUTOLOAD();
		}
	}
	elsif (ref $_[0]) {
		my $self = shift;
		my $class = ref $self;
		croak "No such method: $class::$AUTOLOAD"
			unless $self->{widget}
			and    $self->{widget}->can($AUTOLOAD);
		return $self->{widget}->$AUTOLOAD(@_);
	}
	else { croak "No such method: $AUTOLOAD" }
}

=back

=head2 UI Methods

=over 4

=item C<add_actions(ACTIONS, TYPE, FUNCTION)>

Add plain text action descriptions to the interface.

TYPE can be C<undef>, "menu", "toggle" or "radio".

FUNCTION is an optional function name. This is used to set a single
callback for all actions. If NAME is not defined the callback
function for each action will be of the same name as the action.

=cut

sub add_actions {
	my ($self, $actions, $type, $name) = @_;
	$type = lc $type;
	my $class = ref $self;

	unless ($self->{actions}) {
		my $a = Gtk2::ActionGroup->new($class);
		$self->{app}{ui}->insert_action_group($a, 0);
		$self->{actions} = $a;
	}
	return $self->_add_radio_group($actions, $name) if $type eq 'radio';

	my @actions;
	for (grep /\S/, split /\n/, $actions) {
		my @a = map {($_ eq '.') ? undef : $_} split /\t+/, $_;
		my $n = $name || $a[0] ;
		push @a, \&{$class.'::on_'.$n} unless $type eq 'menu';
		push @a, '0' if $type eq 'toggle';
		push @actions, \@a;
	};
	#use Data::Dumper; warn "Actions ($type): ", Dumper \@actions;

	($type eq 'toggle')
		? $self->{actions}->add_toggle_actions(\@actions, $self)
		: $self->{actions}->add_actions(\@actions, $self)  ;
}

sub _add_radio_group {
	my ($self, $actions, $name) = @_;
	my $class = ref $self;

	my @l = grep /\S/, split /\n/, $actions;
	my $val = 0;
	my @actions;
	for (@l) {
		my @a = map {($_ eq '.') ? undef : $_} split /\t+/, $_;
		$a[5] = $val++;
		push @actions, \@a;
	}
	#use Data::Dumper; warn "Actions (radio): ", Dumper \@actions;

	$self->{actions}->add_radio_actions(
		\@actions, -1, \&{$class.'::on_'.$name}, $self );
}

=item C<get_action($NAME)>

=cut

sub get_action { $_[0]->{actions}->get_action($_[1]) }


=item C<< actions_set_sensitive($NAME => $VAL, ...) >>

Set the sensitivity for one or more actions by name.

=cut

sub actions_set_sensitive {
	my ($self, %actions) = @_;
	for my $name (keys %actions) {
		my $action = $self->{actions}->get_action($name);
        unless ($action) {
            carp "BUG: no such action: $name\n";
            next;
        }
		_gtk_action_set_sensitive($action, $actions{$name});
	}
}

sub _gtk_action_set_sensitive { # **sigh**
	my ($action, $bit) = @_;
	if (Gtk2->CHECK_VERSION(2, 6, 0)) { $action->set_sensitive($bit) }
	else { $_->set_sensitive($bit) for $action->get_proxies }
}

=item C<< actions_set_active($NAME => $VAL, ...) >>

Set the one or more actions active by name.

Used to make the state of the actions match the settings.
When it results in a change of state the handler is called,
which in turn makes the state of the application match the settings.

=cut

sub actions_set_active {
	my ($self, %actions) = @_;
	for my $name (keys %actions) {
		my $action = $self->{actions}->get_action($name);
		unless ($action) {
			carp "BUG: no such action: $name\n";
			next;
		}
		$action->set_active($actions{$name} ? 1 : 0);
	}
}

=item C<< actions_show_active($NAME => $VAL, ..) >>

Like C<actions_set_active()> but prevents the action callback
to be called. This method is used to make the appearance of
the action match the state of the application.

The blocking works at the level of our AUTOLOAD function.

=cut

sub actions_show_active {
	my $self = shift;
	$self->{_block_actions} = 1;
	$self->actions_set_active(@_);
	#while (Gtk2->events_pending) { Gtk2->main_iteration_do(0) }
	$self->{_block_actions} = 0;
}

=item C<add_ui($UI)>

Add a xml style ui description to the interface.

=cut

sub add_ui { $_[0]->{app}{ui}->add_ui_from_string($_[1]) }

=item C<popup($NAME, $BUTTON, $TIME, @ARGS)>

Popup the menu called NAME from the ui spec.
BUTTON and TIME are passed to C<< Gtk2::Menu->popup() >>.
Any ARGS are forwarded to the actions.

=cut

sub popup {
	my ($self, $name, $button, $time, @args) = @_;
	my $menu = $self->{app}{ui}->get_widget('/'.$name) or return 0;
	unless ($menu) {
		carp "BUG: no such menu: $name";
		return 0;
	}
	$_popup_args = scalar(@args) ? \@args : undef;
	$menu->popup(undef, undef, undef, undef, $button, $time);
	return 1;
}

=back

=head2 Actions

=over 4

=item C<ShowHelp(PAGE)>

=item C<ShowHelp(NOTEBOOK, PAGE)>

Show a window showing the documentation. Both PAGE and NOTEBOOK are optional.
NOTEBOOK defaults to '_doc_' (same as C<--doc> on the commandline) but can
be specified to be e.g. '_man_' (same as C<--man>).

In the one argument form the page must start with a ':'.

=cut

sub ShowHelp {
	my ($self, $notebook, $page) = @_;
	$notebook = '_doc_' if ! defined $notebook;
	($notebook, $page) = ('_doc_', $notebook)
		if ! defined $page and $notebook =~ /^:/;
	$self->call_daemon('open', $notebook, $page) and return;
	$self->exec_new_window($notebook, $page);
}

=back

=head2 Process Methods

=over 4

=item C<call_daemon(@ARGS)>

Echo arguments to the daemon. See L<Zim::GUI::Daemon>.
Returns FALSE when no daemon listening.

=item C<exec_new_window(@ARGS)>

Executes a new process for $0, this gives a detached window.
Any arguments are passed on to the new process.

=cut

sub call_daemon {
	my ($self, @args) = @_;
	return 0 if $$self{app}{no_daemon};
	warn "## Call daemon: @args\n";
	eval { Zim::GUI::Daemon->do(@args) };
	warn "## No daemon listening\n" if $@;
	return $@ ? 0 : 1 ;
}

sub exec_new_window {
	my ($self, @args) = @_;
	unshift @args, '--no-daemon' if $$self{app}{no_daemon};
	Zim::Utils->run($^X, $0, @args);
}

=back

=head2 Helper Methods

=over 4

=item C<check_page_input()>

Checks whether an user input is indeed a page name and not e.g. an url.
Returns a page name or undef.
Page name didn't go through cleanup, so does not need to be valid.

=cut

sub check_page_input {
	my ($self, $name) = @_;
	return undef unless length $name;
	my ($t, $l) = Zim::Formats->parse_link(
		$name, $self->{app}{page}, 'NO_RESOLVE');
		# default parse_link(), not page dependent
	return $l if $t eq 'page' and length $l;
	$self->error_dialog(
		__("Not a valid page name: {name}", name => $name),
		"Parsing gives type '$t' for page '$name'" );
	return undef;
}

=item C<check_file_input(PATH)>

Resolves user input to an absolute path. When users specify a path it could
be either be relative to document dir or document dir. This method tries to
figure it out and return the right path. File does not need to exit.
Returns a file object.

=cut

sub check_file_input {
	my ($self, $path) = @_;
	return Zim::FS::File->new($path) unless $$self{app}{page};

	# A file that looks absolute can still be relative to the
	# document root. If it exists, it is probably really absolute.
	# Make it an uri to force resolve_file() to take is absolute.
	$path = Zim::FS->path2uri($path)
		if Zim::FS->is_abs_path($path) and -f $path;

	return $$self{app}{page}->resolve_file($path);
}

=item C<decode_uri_list(TEXT)>

Method to decode data in the C<text/uri-list> format.
This format is used with drag-drop operations of files etc.
Returns a list of uris.

=item C<encode_uri_list(URI, ...)>

Method to encode data in the C<text/uri-list> format.
This format is used with drag-drop operations of files etc.
Returns ascii text data.

=cut

sub decode_uri_list {
	my (undef, $text) = @_;
	my @uris = grep defined($_), split /[\r\n]+/, $text; # split in lines
	for (@uris) {
		s/\%([A-Fa-z0-9]{2})/chr(hex($1))/eg; # url encoding
		eval {$_ = Encode::decode('utf8', $_, 1)}; # utf8 decoding
	}
	return @uris;
}

sub encode_uri_list {
	my (undef, @uris) = @_;
	for (@uris) {
		$_ = Encode::encode_utf8($_); # utf8 decoding
		$_ =~ s{ ([^A-Za-z0-9\-\_\.\!\~\*\'\(\)\/\:]) }
		       { sprintf("%%%02X",ord($1))            }egx;
		# url encoding - char set from man uri(7), see relevant rfc
		# added '/' and ':' to char set for readability of uris
	}
	return join '', map "$_\r\n", @uris;
}

=item C<new_button(STOCK, TEXT)>

Creates a button with a stock image but different text.

=item C<new_small_button(STOCK)>

Creates a small button without text.

=cut

sub new_button {
	my ($self, $stock, $text) = @_;
	my $button = Gtk2::Button->new();
	$button->add(Gtk2::Alignment->new(0.5,0.5, 0,0));
	my $hbox = Gtk2::HBox->new;
	$hbox->pack_start(
		Gtk2::Image->new_from_stock($stock, 'button'), 0,0,0);
	$hbox->pack_start(
		Gtk2::Label->new_with_mnemonic($text), 1,1,0);
	$button->child->add($hbox);
	return $button;
}

sub new_small_button {
	my ($self, $stock) = @_;
	my $button = Gtk2::Button->new();
	$button->add(Gtk2::Alignment->new(0.5,0.5, 0,0));
	$button->child->add(
		Gtk2::Image->new_from_stock($stock, 'small-toolbar') );
	return $button;
}

=item C<new_textview(TEXT)>

Returns a L<Gtk2::ScrolledWindow> and a L<Gtk2::Textview>.
Sets scrolling, shadow and margins properly.

=cut

sub new_textview {
	my (undef, $text) = @_;

	my $textview = Gtk2::TextView->new;
	$textview->set_editable(0);
	$textview->set_wrap_mode('word');
	$textview->set_left_margin(5);
	$textview->set_right_margin(5);
	$textview->get_buffer->set_text($text) if defined $text;

	my $scroll = Gtk2::ScrolledWindow->new;
	$scroll->set_policy('automatic', 'automatic');
	$scroll->set_shadow_type('in');
	$scroll->add($textview);

	return ($scroll, $textview);
}

=item C<set_treeview_single_click(TREEVIEW)>

Make TREEVIEW a single click navigation widget.

=cut

sub set_treeview_single_click {
	my $tview = pop;
	$tview->signal_connect(
		button_release_event => \&on_treeview_single_click);
}


sub on_treeview_single_click {
	my ($tview, $event) = @_;
	return 0 if $event->type ne 'button-release';

	my ($x, $y) = $event->get_coords;
	my ($path, $column) = $tview->get_path_at_pos($x, $y);
	return 0 unless $path and $event->button == 1;
	return 0 unless $tview->get_selection->path_is_selected($path);

	$tview->row_activated($path, $column);
	return 0;
}

=item C<list_text_targets(INFO)>

Returns a list of targets used to copy-paste or drag-drop text.

=cut

sub list_text_targets {
	map [$_, [], $_[1]],
		qw{UTF8_STRING TEXT COMPOUND_TEXT text/plain} ;
}

=back

=head2 Common Dialogs

=over 4

=item C<new_prompt(TITLE, FIELDS, DATA, BUTTON_STOCK, BUTTON_TEXT, TEXT)>

Generates a dialog asking for one or more fields of input.
Returns the dialog widget and a list with Gtk2::Entry objects.

TITLE is the dialog title.

FIELDS and DATA are used for the C<new_form()> method.

TEXT, BUTTON_STOCK and BUTTON_TEXT are optional.

=cut

sub new_prompt {
	my ($self, $title, $fields, $data, $stock, $string, $text) = @_;

	## Setup dialog
	$title .= ' - Zim';
	my $window = $self->{app}{window} if ref $self;
	$window = undef unless defined $window and $window->visible;
		# window might not yet be realized
	my $dialog = Gtk2::Dialog->new(
		$title, $window,
		[qw/modal destroy-with-parent no-separator/],
		'gtk-cancel'  => 'cancel',
	);
	#$dialog->set_resizable(0);
	#$dialog->vbox->set_border_width(12); # FIXME
	my $icon = $window
		? $window->get_icon
		: Gtk2::Gdk::Pixbuf->new_from_file($Zim::ICON) ;
	$dialog->set_icon($icon);
	
	$stock ||= 'gtk-ok';
	my $button = $string
		? $self->new_button($stock, $string)
		: Gtk2::Button->new_from_stock($stock);
	$dialog->add_action_widget($button, 'ok');
	# $dialog->set_default_response('ok'); FIXME

	if (defined $text) {
		my $label = Gtk2::Label->new();
		$label->set_markup($text);
		my $align = Gtk2::Alignment->new(0,0.5, 0,0);
		$align->add($label);
		$dialog->vbox->add($align);
	}

	my ($table, $entries) = $self->new_form($fields, $data, $dialog);
	$dialog->vbox->add($table);

	$dialog->show_all;
	return $dialog, $entries;
}

=item C<new_form(FIELDS, DATA, DIALOG)>

FIELDS is an array ref giving the order of the input fields.

DATA is a hash ref containing definitions of the input fields.
The key is the name used in FIELDS, the value an array ref with a label text,
a data type and a value.

At the moment only the "string", "int", "page", "file" and "dir" data types
are treated special, all other will be ignored silently.

The "file" and "dir" types can have a 4th item being the dir to open
when the value is empty and the "Browse" button is clicked.

The "int" type has a range and a step size, so the 4th argument should be
a array ref with 3 numbers: min, max and step.

DIALOG is optional and will be used to connect signals.

=cut

sub new_form {
	my ($self, $fields, $data, $dialog) = @_;

	my $table = Gtk2::Table->new(scalar(@$fields), 2);
	$table->set_border_width(5);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);

	my @entries;
	for my $i (0 .. $#$fields) {
		my @f = @{ $$data{$$fields[$i]} };

		my $label = Gtk2::Label->new($f[0].':');
		my $align = Gtk2::Alignment->new(0,0.5, 0,0);
		$align->add($label);

		$table->attach($align, 0,1, $i,$i+1, ['fill'],[], 0,0);

		my $entry;
		if ($f[1] eq 'file' or $f[1] eq 'dir') {
			# for file and dir input we add a "Browse" button
			$entry = Gtk2::Entry->new();
			$entry->set_text($f[2]) if defined $f[2];

			my $hbox = Gtk2::HBox->new(0,3);
			$hbox->add($entry);

			my $is_dir = ($f[1] eq 'dir');
			my $button = Gtk2::Button->new(__('_Browse...')); #. button
			$button->signal_connect( clicked => sub {
				# open filechooser dialog
				my $val = $entry->get_text();
				$val = $self->check_file_input($val);
				$val = $f[3] if $val !~ /\S/;
				$val = $self->filechooser_dialog($val, $is_dir);
				$entry->set_text($val) if defined $val;
			} );
			$entry->signal_connect('notify::sensitive' => sub {
				# sync sensitive state of button with entry
				my $s = $entry->is_sensitive;
				$button->set_sensitive($s);
			} );
			$hbox->pack_start($button, 0,1,0);

			$table->attach_defaults($hbox, 1,2, $i,$i+1);
		}
		elsif ($f[1] eq 'int') {
			# for integers we use a spin button input
			my @r = @{$f[3]};
			$r[0] ||= 0; # min
			$r[1] = $r[0]+1 unless $r[1] > $r[0];
				# Some Gtk versions do not allow max == min
			$r[2] ||= 1; # step
			$entry = Gtk2::SpinButton->new_with_range(@r);
			$entry->set_value($f[2]);
			$table->attach_defaults($entry, 1,2, $i,$i+1);
		}
		elsif ($f[1] eq 'page') {
			# for page we add page completion to the entry
			$entry = Gtk2::Entry->new();
			$entry->set_text($f[2]) if defined $f[2];
			$table->attach_defaults($entry, 1,2, $i,$i+1);
			$self->set_page_completion($entry);
		}
		elsif ($f[1] eq 'password') {
			# of course a password should not be inputted
			# in plain text
			$entry = Gtk2::Entry->new();
			$entry->set_text($f[2]) if defined $f[2];
			$entry->set_visibility(0);
			$table->attach_defaults($entry, 1,2, $i,$i+1);
		}
#		elsif ($f[1] eq 'dropdown') {
#			my $combo = ...;
#			$combo->set_text($_) for @$f[2];
#		}
		else {
			# string or unknown type
			$entry = Gtk2::Entry->new();
			$entry->set_text($f[2]) if defined $f[2];
			$table->attach_defaults($entry, 1,2, $i,$i+1);
		}
		push @entries, $entry;
	}

	for my $i (0 .. $#entries - 1) {
		$entries[$i]->signal_connect(
			activate => sub { $entries[$i+1]->grab_focus } );
	}
	if ($dialog and @entries) {
		$entries[-1]->signal_connect(
			activate => sub { $dialog->response('ok') } );
	}

	return ($table, \@entries);
}

=item C<set_page_completion(ENTRY)>

Attach page completions code to a L<Gtk2::Entry> object.

=cut

sub set_page_completion {
	my ($self, $entry) = @_;
	my $completion = Gtk2::EntryCompletion->new;
	my $model = Gtk2::ListStore->new('Glib::String');
	$completion->set_model($model);
	$completion->set_text_column(0);
	$completion->set_inline_completion(1)  if Gtk2->CHECK_VERSION(2, 6, 0);
	$entry->set_completion($completion);
	$entry->signal_connect(changed => \&_update_completion, $self);
}

sub _update_completion {
	my ($entry, $self) = @_;
	return unless $self->{app}{notebook} and $self->{app}{page};
	my $ns = $entry->get_text;
	$ns =~ s/[^:]+$//;
	return if defined $entry->{_ns} and $entry->{_ns} eq $ns;
	$entry->{_ns} = $ns;

	my $_ns = length($ns)
		? $self->{app}{notebook}->resolve_namespace($ns)
		: $self->{app}{page}->namespace() ;
		#warn "Complete namespace: $_ns\n";

	my $model = $entry->get_completion->get_model;
	$model->clear;
	for ($self->{app}{notebook}->list_pages($_ns)) {
		s/_/ /g;
		my $iter = $model->append();
		$model->set($iter, 0 => $ns.$_);
		#warn "Appended: $ns$_\n";
	}
}

=item C<run_prompt(..)>

Wrapper around C<new_prompt()> that runs the dialog and
returns a list with input values. Returns undef on 'cancel'.

=cut

sub run_prompt {
	my $self = shift;
	my ($dialog, $entries) = $self->new_prompt(@_);

	my $values = ($dialog->run eq 'ok')
		? [map $_->get_text, @$entries]
		: undef ;
	$dialog->destroy;

	return $values;
}

=item C<prompt_question(TYPE, TEXT, BUTTONS ..., TIME)>

TYPE can either be 'error', 'warning', 'question', 'info' or C<undef>.

Runs a dialog displaying TEXT To comform with the Gnome HIG,
the text should consist of a primary text in bold, possibly followed by
an empty line and secondary text in normal style. Please make sure the
text ends with a question if you expect a response.

BUTTONS is a list of array references, each containing a name, a stock item
name and/or text. The id of the button that was pressed is returned.

TIME is an optional argument, it gives a timeout in seconds. This is used
for popups that can popup while the user is typing to prevent accidental
triggering of a accelerator.

=cut

sub prompt_question {
	my ($self, $type, $text, @buttons) = @_;
	my $time = pop @buttons unless ref $buttons[-1];

	my $dialog = Gtk2::Dialog->new(
		undef, $self->{app}{window}, # HIG says no title
	       	[qw/modal destroy-with-parent no-separator/],
	);
	$dialog->set_resizable(0);
	$dialog->set_border_width(6); # border from HIG
	$dialog->set_icon($self->{app}{window}->get_icon);

	my @button_widgets;
	for (0 .. $#buttons) {
		my ($id, $stock, $string) = @{$buttons[$_]};
		my $button = (defined($stock) && ! defined($string))
			? Gtk2::Button->new_from_stock($stock)
			: $self->new_button($stock, $string)   ;
		$button->set_sensitive(0);
		$dialog->add_action_widget($button, $_);
		$dialog->action_area->set_child_secondary($button, 1)
			if $stock eq 'gtk-help';
		push @button_widgets, $button;
	}

	my $hbox = Gtk2::HBox->new(0,12); # spacing from HIG
	$hbox->set_border_width(6); # border from HIG
	$dialog->vbox->pack_start($hbox, 0,0,0);

	if (defined $type) {
		my $image = Gtk2::Image->new_from_stock(
			"gtk-dialog-$type", 'dialog' );
		$image->set_alignment(0.5, 0.0); # HIG says valign top
		$hbox->pack_start($image, 0,0,0);
	}
	if (defined $text) {
		$text =~ s/\n*$/\n/; # HIG says one empty line
		my $label = Gtk2::Label->new($text);
		$label->set_use_markup(1); # enable bold text
		$label->set_alignment(0.0, 0.0); # left top
		$hbox->add($label);
	}

	$dialog->show_all;
	if ($time) {
		my $label = Gtk2::Label->new($time.' sec.');
		$label->set_state('insensitive');
		$label->set_alignment(0.9, 0.5); # right center
		$label->show;
		$dialog->vbox->add($label);
		Glib::Timeout->add( 1000, sub {
			$time--;
			if ($time > 0) {
				$label->set_text($time. ' sec.');
				1; # continue
			}
			else {
				$label->set_text('');
				$_->set_sensitive(1) for @button_widgets;
				0; # last
			}
		} );
	}
	else { $_->set_sensitive(1) for @button_widgets }
	my $id = $dialog->run;
	$dialog->destroy;

	return undef unless $id =~ /^\d+$/;
	return $buttons[$id][0];
}

=item C<exit_error(ERROR)>

Like C<error_dialog> but exits afterwards.

=cut

sub exit_error {
	my $self = shift;
	my ($text1, $text2) = @_;
	if (defined $text1) { $self->error_dialog($text1, $text2) }
	else {
		$text2 ||= "Unknown error";
		warn "zim: $text2\n";
	}
	unlink $self->{app}{pidfile}
		if ref $self and defined $self->{app}{pidfile};
	exit 1;
}

=item C<error_dialog(ERROR)>

This method is used to display errors.

=cut

sub error_dialog {
	my ($self, $text1, $text2) = @_;
	$text2 ||= $@ || $text1;
	warn "zim: $text2\n";
	$text1 =~ s/\%/%%/g; # MessageDialog uses sprintf interface
	my $window = $self->{app}{window} if ref $self;
	$window = undef unless defined $window and $window->visible;
		# window might not yet be realized
	my $dialog = Gtk2::MessageDialog->new(
		# no markup, $@ can contain "<" symbols
		$window, 'modal', 'error', 'ok', $text1 );
		# parent, flags, type, buttons, message
	$dialog->run;
	$dialog->destroy;
	return undef;
}

=item C<filechooser_dialog(PATH, WANT_DIR, TITLE)>

Show the user a dialog to browse the file system and choose a file or
directory. PATH is the suggested file or directory. WANT_DIR is a
boolean that controls whether this dialog selects a file or a dir.
TITLE is an optional title for the dialog.

If PATH is not defined, either the last directory used by a filechooser
dialog from this GUI Component, the current document root or
document dir will be opened. To control which directory opens, set the
attribute C<$$self{filechooser_dir}>. This attribute will be set to the
lastest directory after the dialog is closed.

Returns an absolute path or undef.

=cut

sub filechooser_dialog {
	my ($self, $file, $want_dir, $title) = @_;
	my ($doc_dir, $doc_dir_root, $doc_root) = $$self{app}{page}
		? ( $$self{app}{page}->document_dir,
		    $$self{app}{notebook}->document_dir,
		    $$self{app}{notebook}->document_root )
		: (undef, undef, undef) ;
		# need to check page here because this method is also
		# used by e.g. NotebookDialog

	# construct filechooser dialog
	my $dialog;
	$title ||= $want_dir
		? __('Select Folder') : __('Select File') ; #. dialog title
	$title .= ' - Zim';
	$dialog = Gtk2::FileChooserDialog->new(
		$title, $self->{app}{window}, 'open',
		'gtk-cancel' => 'cancel',
		'gtk-ok'     => 'ok'
	);
	$dialog->set_icon($self->{app}{window}->get_icon);
	$dialog->set_action('select-folder') if $want_dir;

	# add links to special directories in side pane
	for (grep {defined $_} $doc_root, $doc_dir_root, $doc_dir) {
		my $folder = Zim::FS->localize($_);
		eval { $dialog->add_shortcut_folder($folder) } if -e $folder;
			# dies for some gtk version if folder does not exist
			# dies for other gtk version if shortcut is double
	}

	# set the file or dir we want the dialog to open
	if (defined $file and $file =~ /\S/) {
		# opens the dir for file (file can be a dir itself)
		$file = Zim::FS->localize(file($file));
		$dialog->set_filename($file);
	}
	else {
		# set the directory to start browsing
		my ($dir) = grep {-d $_} grep {defined $_}
			$$self{filechooser_dir},
			$doc_root, $doc_dir, $doc_dir_root ;
		if (defined $dir) {
			$dir = Zim::FS->localize(dir($dir));
			$dialog->set_current_folder($dir);
		}
	}

	# run the dialog
	$dialog->show_all;
	my $re = $dialog->run;
	if ($re eq 'ok') {
		$file = $dialog->get_filename;
		$file = Zim::FS->abs_path($file);
			# abs_path to un-localize
		my $dir = $dialog->get_current_folder;
		$$self{filechooser_dir} = Zim::FS->abs_path($dir);
			# abs_path to un-localize
	}
	else { $file = undef }
	$dialog->destroy;

	return $file;
}

=item C<new_progress_bar(TITLE, LABEL)>

Returns a dialog with a progress bar.

=cut

sub new_progress_bar {
	my ($self, $title, $label) = @_;
	my $dialog = Gtk2::Dialog->new(
		$title, $self->{window},
	   	[qw/destroy-with-parent no-separator/],
		'gtk-cancel' => 'cancel',
	);
	$dialog->set_resizable(0);
	$dialog->vbox->set_spacing(5);
	$dialog->vbox->set_border_width(10);
	$label = Gtk2::Label->new($label);
	$dialog->vbox->add($label);
	my $bar = Gtk2::ProgressBar->new;
	$dialog->vbox->add($bar);
	$dialog->show_all;
	return ($dialog, $bar, $label);
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

