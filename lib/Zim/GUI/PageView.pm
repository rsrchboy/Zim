package Zim::GUI::PageView;

use strict;
use vars qw/$CODESET/;
use Carp;
use POSIX qw(strftime);
use Encode;
use Gtk2;
use Gtk2::Pango;               # pango constants
use Gtk2::Ex::HyperTextView;   # custom widget
use Gtk2::Ex::HyperTextBuffer; #    "     "
use Gtk2::Gdk::Keysyms;	       # key identifiers
use File::MimeInfo q/mimetype_isa/;
use File::MimeInfo::Magic qw/mimetype/;
use File::BaseDir 0.03 qw/data_files data_home/;
use Zim::Utils;
use Zim::GUI::Component;

eval "use Gtk2::Ex::DesktopEntryMenu";
my $has_mimeapplications = $@ ? 0 : 1;

our $VERSION = '0.27';

our @ISA = qw/Zim::GUI::Component/;

*CODESET = \$Zim::CODESET;
$CODESET ||= 'utf8';

our %OBJECTS;

# TODO move more logic into Gtk2::Ex::HyperTextBuffer !

=head1 NAME

Zim::GUI::PageView - Page TextView widgets

=head1 DESCRIPTION

This module contains the widgets to display an editable
text buffer containing the current page. It includes a search entry
at the bottom of the TextView, and autoformatting logic.

=head1 METHODS

Undefined methods are AUTOLOADED to the Gtk2::Ex::HyperTextView object.

=over 4

=cut

my $ui_format_actions = __actions(
# name,		stock id,	label,		accelerator,	tooltip
qq{
Head1		.		Head _1		<ctrl>1		Heading 1
Head2		.		Head _2		<ctrl>2		Heading 2
Head3		.		Head _3		<ctrl>3		Heading 3
Head4		.		Head _4		<ctrl>4		Heading 4
Head5		.		Head _5		<ctrl>5		Heading 5
Normal		.		_Normal		<ctrl>6		Normal
Bold		gtk-bold	_Bold		<ctrl>B		Bold
Italic		gtk-italic	_Italic		<ctrl>I		Italic
Underline	gtk-underline	_Underline	<ctrl>U		Underline
Strike		gtk-strikethrough	Stri_ke	<ctrl>K		Strike
Verbatim	.		_Verbatim	<ctrl>T		Verbatim
} );

my $ui_format_toggle_actions = __actions(
qq{
TLink		gtk-connect	_Link		.		Link
TBold		gtk-bold	_Bold		.		Bold
TItalic		gtk-italic	_Italic		.		Italic
TUnderline	gtk-underline	_Underline	.		Underline
TStrike		gtk-strikethrough	Stri_ke	.		Strike
} );

my $ui_actions = __actions(
qq{
Undo		gtk-undo	_Undo		<ctrl>Z		Undo
Redo		gtk-redo	_Redo		<ctrl><shift>Z	Redo
Delete		gtk-delete	_Delete		.		Delete
ToggleCheckbox	checked-box	Toggle Checkbox 'V'	F12	Toggle checkbox
XToggleCheckbox	xchecked-box	Toggle Checkbox 'X'	<shift>F12	Toggle checkbox
EditObject	gtk-properties	_Edit Link...	<ctrl>E		Edit link
InsertDate	.		_Date and Time...	<ctrl>D	Insert date
InsertLink	gtk-connect	_Link...		.	Insert link
InsertExtLink	gtk-connect	E_xternal Link...	.	Insert external link
InsertImage	.		_Image...	.	Insert image
InsertFromFile	.		Text _From File...	.	Insert text from file
FindReplace	gtk-find-and-replace	_Replace...	<ctrl>H	Find and Replace
} );

my $ui_copy_paste_actions = __actions(
q{
Cut		gtk-cut		Cu_t		<ctrl>X		Cut
Copy		gtk-copy	_Copy		<ctrl>C		Copy
Paste		gtk-paste	_Paste		<ctrl>V		Paste
} );

my $ui_actions_ro = __actions(
qq{
Link		gtk-connect	_Link		<ctrl>L		Link
Find		gtk-find	_Find...	<ctrl>F		Find
FindNext	.		Find Ne_xt	<ctrl>G		Find next
FindPrev	.		Find Pre_vious	<ctrl><shift>G	Find previous
WordCount	.		_Word Count	.		Word count
} );

my $ui_layout_ro = q{<ui>
	<menubar name='MenuBar'>
		<menu action='SearchMenu'>
			<placeholder name='FindItems'>
				<menuitem action='Find'/>
				<menuitem action='FindNext'/>
				<menuitem action='FindPrev'/>
			</placeholder>
		</menu>
		<menu action='ToolsMenu'>
			<placeholder name='PageTools'>
				<menuitem action='WordCount'/>
			</placeholder>
		</menu>
	</menubar>
	<accelerator action='Link'/>
</ui>};

my $ui_layout = q{<ui>
	<menubar name='MenuBar'>
		<menu action='EditMenu'>
			<placeholder name='EditPage'>
				<menuitem action='Undo'/>
				<menuitem action='Redo'/>
				<separator/>
				<menuitem action='Cut'/>
				<menuitem action='Copy'/>
				<menuitem action='Paste'/>
				<menuitem action='Delete'/>
				<separator/>
				<menuitem action='ToggleCheckbox'/>
				<menuitem action='XToggleCheckbox'/>
				<menuitem action='EditObject'/>
				<separator/>
			</placeholder>
		</menu>
		<menu action='InsertMenu'>
			<menuitem action='InsertDate'/>
			<separator/>
			<menuitem action='InsertImage'/>
			<placeholder name='PluginItems'/>
			<separator/>
			<menuitem action='InsertFromFile'/>
			<menuitem action='InsertExtLink'/>
			<menuitem action='InsertLink'/>
		</menu>
		<menu action='FormatMenu'>
			<menuitem action='Head1'/>
			<menuitem action='Head2'/>
			<menuitem action='Head3'/>
			<menuitem action='Head4'/>
			<menuitem action='Head5'/>
			<menuitem action='Normal'/>
			<separator/>
			<menuitem action='Bold'/>
			<menuitem action='Italic'/>
			<menuitem action='Underline'/>
			<menuitem action='Strike'/>
			<menuitem action='Verbatim'/>
			<separator/>
			<menuitem action='Link'/>
		</menu>
		<menu action='SearchMenu'>
			<placeholder name='FindItems'>
				<menuitem action='FindReplace'/>
			</placeholder>
		</menu>
	</menubar>
	<toolbar name='ToolBar'>
		<placeholder name='Format'>
			<toolitem action='TLink'/>
			<toolitem action='TBold'/>
			<toolitem action='TItalic'/>
			<toolitem action='TUnderline'/>
			<toolitem action='TStrike'/>
		</placeholder>
	</toolbar>
</ui>};

our %Styles = ( # needed for translations
	Head1     => __('Head1'),      #. Text style
	Head2     => __('Head2'),      #. Text style
	Head3     => __('Head3'),      #. Text style
	Head4     => __('Head4'),      #. Text style
	Head5     => __('Head5'),      #. Text style
	Normal    => __('Normal'),     #. Text style
	Bold      => __('Bold'),       #. Text style
	Italic    => __('Italic'),     #. Text style
	Underline => __('Underline'),  #. Text style
	Strike    => __('Strike'),     #. Text style
	Verbatim  => __('Verbatim'),   #. Text style
);

sub _user_action_ (&$) {
	# This is a macro needed to make actions undo-able
	# wrap all interactive operations with this method.
	$_[1]->signal_emit('begin_user_action');
	$_[0]->();
	$_[1]->signal_emit('end_user_action');
}

=item C<new(app => PARENT)>

Simple constructor.

=cut

my ($k_tab, $k_l_tab, $k_return, $k_kp_enter, $k_backspace, $k_escape, $k_multiply, $k_home, $k_F3) =
	@Gtk2::Gdk::Keysyms{qw/Tab ISO_Left_Tab Return KP_Enter BackSpace Escape KP_Multiply Home F3/};
#my @k_parse_word = ($k_tab, map ord($_), ' ', qw/. ; , ' "/);

sub init { # called by new()
	my $self = shift;

	# load style data
	my $profile = $$self{app}{profile} || 'default';
	my $file = Zim::GUI::_config_data_files('zim', $profile.'.style');
	$file ||= Zim::GUI::_config_data_files('zim', 'default.style');
	my $style = Zim::FS::File::Config->new($file)->read(undef, 'TextView')
		if $file;
	for my $k (grep s/^Tag //, keys %$style) {
		no strict 'refs';
		my $list = [
			map { # map constants
				/^PANGO_/ ? &{"Gtk2::Pango::$_"} : $_
			}
			%{$$style{"Tag $k"}}
		];
		$Gtk2::Ex::HyperTextBuffer::TAGS{$k} = $list;
	}
	#use Data::Dumper; warn Dumper \%Gtk2::Ex::HyperTextBuffer::TAGS;

	my $vbox = Gtk2::VBox->new(0, 0);
	$self->{vbox} = $vbox;
	$self->{top_widget} = $vbox;
	
	my $scrolled_window = Gtk2::ScrolledWindow->new();
	$scrolled_window->set_policy('automatic', 'automatic');
	$scrolled_window->set_shadow_type('in');
	$vbox->add($scrolled_window);
	$self->{scrolled_window} = $scrolled_window;

	# init TextView
	my $htext = Gtk2::Ex::HyperTextView->new();
	$htext->set_left_margin(10);
	$htext->set_right_margin(5);
	$htext->set_tabs( Gtk2::Pango::TabArray->new_with_positions(
		# initial_size, pos_in_pixels, ... allign => position
		1, 1, 'left' => $$style{tabs} ) )
		if $$style{tabs};
	$htext->signal_connect(link_clicked =>
		sub { $self->{app}->link_clicked($_[1]) }  );
	$htext->signal_connect(link_enter =>
		sub {
			my $p = $self->{app}{page};
			my ($t, $l) = $p->parse_link($_[1], 'NO_RESOLVE');
			#warn "parsed: $_[1] => $l ($t)\n";
			$l = $p->resolve_name($l) if $t eq 'page';
			$self->{app}->push_status("Go to \"$l\"", 'link');
		}  );
	$htext->signal_connect(link_leave =>
		sub { $self->{app}->pop_status('link') }  );
	$htext->signal_connect_after(toggle_overwrite => \&on_toggle_overwrite, $self);
	$htext->signal_connect(populate_popup => \&on_populate_popup, $self);
	$htext->signal_connect(key_press_event => \&on_key_press_event, $self);
	$htext->drag_dest_set(['motion', 'highlight'],
		['link', 'copy', 'move'] ); # We would prefer only 'link' here, but KDE needs 'move' 
	my $tlist = Gtk2::TargetList->new();
	if (Gtk2->CHECK_VERSION(2, 6, 0)) {
		$tlist->add_uri_targets(0);
		$tlist->add_text_targets(1);
	}
	else { # 2.4
		$tlist->add_table(
			['text/uri-list', [], 0],
			$self->list_text_targets(1) );
	}
	$tlist->add_table(['text/x-zim-page-list', [], 2]);
	$htext->drag_dest_set_target_list($tlist);
	$htext->signal_connect_swapped(
		drag_data_received => \&on_drag_data_received, $self );
	#$htext->signal_connect(drag_motion => \&on_drag_motion); # debug
	$scrolled_window->add($htext);
	$self->{htext} = $htext;
	$self->{widget} = $htext;

	# init search box
	my $hbox = Gtk2::HBox->new(0, 5);
	$hbox->set_no_show_all(1);
	$hbox->signal_connect(key_press_event => \&on_key_press_event_hbox, $self);
	$vbox->pack_start($hbox, 0, 1, 3);
	$self->{hbox} = $hbox;
	
	my $close_button = $self->new_small_button('gtk-close');
	$close_button->set_relief('none');
	$close_button->signal_connect_swapped(
		clicked => \&CloseFind, $self );
	$hbox->pack_end($close_button, 0,1,0);
	
	$hbox->pack_start( Gtk2::Label->new(' '.__('Find').': '), 0,1,0); #. query entry label
	
	my $entry = Gtk2::Entry->new();
	$entry->signal_connect(changed => sub { $self->_find($entry->get_text, 0) });
	$entry->signal_connect_swapped(activate => \&on_activate_entry,  $self);
	$hbox->pack_start($entry, 0, 1, 0);
	$self->{entry} = $entry;

	my $prev_button = $self->new_button('gtk-go-back', __('_Previous')); #. search button
	$prev_button->set_sensitive(0);
	$prev_button->signal_connect_swapped(clicked => \&FindPrev, $self);
	$hbox->pack_start($prev_button, 0, 1, 0);
	$self->{find_prev_button} = $prev_button;
	
	my $next_button = $self->new_button('gtk-go-forward', __('_Next')); #. search button
	$next_button->set_sensitive(0);
	$next_button->signal_connect_swapped(clicked => \&FindNext, $self);
	$hbox->pack_start($next_button, 0, 1, 0);
	$self->{find_next_button} = $next_button;

	# add toolbar buttons and key bindings
	$self->add_actions($ui_actions_ro);
	$self->{ro_actions} = delete $self->{actions}; # rename action group
	$self->add_ui($ui_layout_ro);
	
	my $accels = $self->{app}{ui}->get_accel_group;
	unless ($self->{app}{read_only}) {
		# we do not show these actions in global read_only mode
		# new action group will be initialized
		$self->add_actions($ui_format_actions, undef, 'ApplyFormat');
		$self->add_actions($ui_format_toggle_actions, 'TOGGLE', 'ApplyFormat');
		$self->add_actions($ui_copy_paste_actions, undef, 'clipboard');
		$self->add_actions($ui_actions);
		$self->add_ui($ui_layout);
		$accels->connect( # ^Y (identical with the shift-^Z defined above)
			ord('Y'), ['control-mask'], ['visible'], sub {$self->Redo} );
	}
	$accels->connect( # alt-/ (identical with the ^F defined above)
		ord('/'), ['mod1-mask'], ['visible'], sub {$self->Find} );
	$accels->connect( $k_F3, [], ['visible'], sub { $self->on_FindNext } );
	$accels->connect( $k_F3, ['shift-mask'], ['visible'], sub { $self->on_FindPrev } );

	# FIXME - prevent our accelerators from triggering while 
	# another widget has focus 
	if (my $actions = $self->{actions}) {
		$htext->signal_connect(
			focus_in_event  => sub { $actions->set_sensitive(1)
				unless $$self{app}{read_only} });
		$htext->signal_connect(
			focus_out_event => sub { $actions->set_sensitive(0) });
	}

	$$self{app}->signal_connect(t_read_only => sub {
		my ($app, $ro) = @_;
		$$self{actions}->set_sensitive(!$ro) if defined $$self{actions};
		$$self{htext}->set_editable(!$ro);
		$self->on_show_cursor;
	} );
	
	my $sendto_dir = data_home('zim', 'SendTo');
	$self->{sendto_dir} = $sendto_dir if -d $sendto_dir;
	#warn "sendTo dir: $sendto_dir\n";
	
	$$self{app}->signal_connect(
		'settings-changed' => \&on_load_settings, $self);
	$self->on_load_settings;
	$self->on_show_cursor;

}

sub on_load_settings {
	my $self = pop;
	my $settings = $$self{app}{settings};
	$$self{htext}{follow_on_enter} = $$settings{follow_on_enter};
	$$self{htext}{use_recurscheck} = $$settings{use_recurscheck};
	$self->set_font($$settings{textfont})
		if defined $$settings{textfont};
}

sub _init_buffer {
	# create a new HyperTextBuffer
	# called by load_page
	my $self = shift;
	my $buffer = Gtk2::Ex::HyperTextBuffer->new();
	$buffer->create_default_tags;
	$self->{buffer} = $buffer;
	$self->{htext}->set_buffer($buffer);
	$buffer->signal_connect(modified_changed =>
		sub {$self->{app}->update_status} );
	$buffer->signal_connect(edit_mode_changed =>
		\&on_edit_mode_changed, $self );
	$self->on_show_cursor;
	$buffer->{_zim_name} = $self->{app}{notebook}{name}; # FIXME FIXME FIXME
}

=back

=head2 Actions

=over 4

=item C<ApplyFormat(FORMAT, BOOLEAN)>

Applies the property FORMAT to any selected text
or toggles the edit mode.

BOOLEAN is used to force format (TRUE) or un-format (FALSE). If BOOLEAN is
undefined the function acts as a toggle.

=cut


sub on_ApplyFormat {
	# Catches all for format actions
	#
	# This function passes on boolean values for toggles in order to
	# make sure that the action is consistent with the displayed toggle.
	# Without this it is possible to end up in a infinite loop when the
	# two end up out of sync.
	my ($action, $self) = @_;
	return if $self->{_block_actions};
	my $tag = lc $action->get_name;
	my $bool = undef;
	if ($action->isa('Gtk2::ToggleAction')) {
		$tag =~ s/^t//;
		$bool = $action->get_active;
	}
	warn "## dispatch ACTION " .
		(($tag eq 'link') ? "Link(undef, $bool)" : "ApplyFormat($tag, $bool)") . "\n";
	($tag eq 'link')
		? $self->Link(undef, $bool)
		: $self->ApplyFormat($tag, $bool) ;
}

sub ApplyFormat {
	my ($self, $tag, $bool) = @_;
	die "BUG: Can't call ApplyFormat without a tag" unless length $tag;
	my $buffer = $self->{buffer};
	my $has_tag = ($tag eq 'normal') ? 1 : 0;

	# Check selections
	my $_tag = $buffer->get_tag_table->lookup($tag);
	my $_Verbatim;
	my $select;
	my ($start, $end) = $buffer->get_selection_bounds;
	CHECK_TAG:
	if ($end and $start != $end) {
		$select = 'normal';
		$has_tag ||= $start->has_tag($_tag);
	}
	else {
		$has_tag ||= grep {$_ eq $_tag} $buffer->get_edit_mode_tags;
	}
	if (!$has_tag and $tag eq 'verbatim' and ! $_Verbatim) { # ugly exception
		$_Verbatim = $buffer->get_tag_table->lookup('Verbatim');
		$_tag = $_Verbatim;
		goto CHECK_TAG;
	}

	if (!$has_tag and !$select and $self->{app}{settings}{use_autoselect}) {
		($start, $end) = $buffer->auto_selection($tag);
		$select = 'auto' if defined $start;
	}

	return 0 if defined $bool and $bool == $has_tag;
		# do nothing if state is same

	if ($select) { # there is a selection
		if ($tag eq 'verbatim' and !$has_tag) {
			$_Verbatim ||= $buffer->get_tag_table->lookup('Verbatim');
			$tag = 'Verbatim'
				if $start->get_line != $end->get_line
				or $start->starts_line && $end->ends_line
				or $start->has_tag($_Verbatim)
				or $end->has_tag($_Verbatim)  ;
		}
	
		$buffer->remove_all_tags($start, $end);
		$buffer->apply_tag_by_name($tag, $start, $end)
			unless $has_tag or $tag eq 'normal';
		$buffer->set_modified(1);
	
		if ($tag =~ /^head/ and !$has_tag) { # give headers their own line
			$end = $end->ends_line ? undef : $end->get_offset ;
			$buffer->insert($start, "\n") unless $start->starts_line;
			$buffer->insert($buffer->get_iter_at_offset($end+1), "\n")
				unless ! defined $end;
		}

		if ($select eq 'auto') { # unselect
			($start, $end) = $buffer->get_selection_bounds;
			$buffer->select_range($end, $end) if $end;
		}
	}

		$buffer->set_edit_mode_tags($has_tag ? () : ($tag));
	}


=item C<Link(LINK, BOOLEAN)>

This method is called by the "Link" button or by the ^L keybinding.
It makes any selected text a link or toggles the link property.
This link is followed immediatly if the 'follow_new_link' config option is set.

If LINK is undefined the link target is the same as the selected text.

In readonly modus the selected text is regarded as a link and
followed immediatly, but no actual link is made.

BOOLEAN is used to force link (TRUE) or unlink (FALSE). If BOOLEAN is
undefined the function acts as a toggle.

=cut

sub Link {
	my ($self, $link, $bool) = @_;
	my $buffer = $self->{buffer};
	my ($start, $end) = $buffer->get_selection_bounds;
	
	unless ($end and $start != $end) { # no selection
		if (grep {$_->{is_link}} $buffer->get_edit_mode_tags) {
			$bool = 0 unless defined $bool;
			$buffer->set_edit_mode_tags() unless $bool; # reset
			return !$bool;
		}
		elsif ($self->{app}{settings}{use_autoselect}) {
			($start, $end) = $buffer->auto_selection('link');
		}

		unless ($end and $start != $end) {
			return 0 if defined $bool and !$bool;
			my $tag = $buffer->create_link_tag;
			$buffer->set_edit_mode_tags($tag);
			return;
		}
	}

	my $text = $buffer->get_text($start, $end, 0);
	$link = $text unless defined $link;
	return if $link =~ /\n/;
	
	my $ro = $$self{app}{read_only};
	unless ($ro) {
		return 0 if defined $bool and !$bool;
		my $bit = $link eq $text;
		$buffer->remove_all_tags($start, $end);
		$self->{htext}->apply_link(($bit ? undef : $link), $start, $end);
		$buffer->set_modified(1);
	}

	if ($ro or $$self{app}{settings}{follow_new_link}) {
		my ($type, $l) = $$self{app}{page}->parse_link(
			$link, 'NO_RESOLVE');
		$$self{app}->link_clicked($link)
			if $type eq 'page';
	}
}

=item C<Undo()>

Undo one editing step in the buffer.

=item C<Redo()>

Redo one editing step in the buffer.

=cut

sub Undo {
	my $self = shift;
	$self->{htext}->get_buffer->undo;
}

sub Redo {
	my $self = shift;
	$self->{htext}->get_buffer->redo;
}

sub on_clipboard {
	my ($action, $self) = @_;
	return 0 unless $self->{htext}->get('has-focus');
	my $signal = lc($action->get_name).'_clipboard';
	$self->{htext}->signal_emit($signal);
	return 1;
}

=item C<Delete()>

Delete from cursor.

=cut

sub on_Delete {
	my ($action, $self) = @_;
	$self->Delete if $$self{htext}->get('has-focus');
}

sub Delete {
	my $self = shift;
	$$self{htext}->signal_emit('delete_from_cursor', 'chars', 1);
}

=item C<ToggleCheckbox(ITER, TYPE)>

=item C<XToggleCheckbox(ITER)>

Same as ToggleCheckbox with type 'x'.

=cut

sub ToggleCheckbox {
	my ($self, $iter, $type) = @_;
	$type ||= 'v';
	$iter ||= $$self{buffer}->get_iter_at_mark(
			$$self{buffer}->get_insert() );
	my $lf = $$self{buffer}->get_iter_at_line( $iter->get_line );
	my $line = $$self{buffer}->get_slice($lf, $iter, 0);
	return unless $line =~ /^(\s*)\x{FFFC}/;
	$lf->forward_chars(length $1);
	$$self{htext}->toggle_if_checkbox_at_iter($lf, $type);
}

sub XToggleCheckbox { $_[0]->ToggleCheckbox($_[1], 'x') }

=item C<EditObject(ITER)>

Dispatches to C<EditLink()>, C<EditImage()> or a custom handler
for special objects.

If no object is found and text is selected it calls C<EditLink()>

=cut

sub EditObject {
	my ($self, $iter) = @_;
	$iter ||= $$self{buffer}->get_iter_at_mark(
			$$self{buffer}->get_insert() );

	if ($$self{htext}->get_link_at_iter($iter)) {
		$self->EditLink($iter);
	}
	elsif (my $pixbuf = $iter->get_pixbuf) {
		$self->EditImage($iter) unless $$pixbuf{type} eq 'checkbox';
	}
	else {
		my ($start, $end) = $$self{buffer}->get_selection_bounds;
		return if ! $end or $end == $start; # no selection

		# Check for an image in this range
		my $iter = $start->copy;
		while ($iter->compare($end) < 1) {
			my $pixbuf = $iter->get_pixbuf;
			return $self->EditImage($iter) if $pixbuf;
			$iter->forward_char or last;
		}

		return $self->EditLink;
	}
}

=item C<EditLink(ITER)>

Shows the "Edit link" dialog. ITER defaults to the current cursor position.
Doesn't do anything if there is no link at ITER.

=cut

sub EditLink {
	my ($self, $iter) = @_;
	my $buffer = $self->{buffer};
	my ($start, $end) = $buffer->auto_selection('link', $iter);

	return unless defined $start;
	my $link = $self->{htext}->get_link_at_iter($start);
	my $text = $buffer->get_text($start, $end, 0);
	$text = undef if $text =~ /\n/;

	my ($t, undef) = $$self{app}{page}->parse_link($link, 'NO_RESOLVE');
	($link, $text) = $self->_prompt_link_properties(
		$link, $text, 'edit', ($t eq 'page') ? 0 : 1);
	return unless defined $link;
	
	$buffer->delete($start, $end);
	$buffer->insert_blocks($start, ['link', {to => $link}, $text]);
}

=item C<EditImage(ITER)>

Shows the "Edit Image" dialog. ITER defaults to the current cursor position.
Doesn't do anything if there is no image at ITER.

=cut

sub EditImage {
	my ($self, $iter) = @_;
	$iter ||= $$self{buffer}->get_iter_at_mark(
			$$self{buffer}->get_insert );
	my $pixbuf = $iter->get_pixbuf;
	return unless $pixbuf;

	my (%meta) = $self->_prompt_image_properties($pixbuf);
	return unless %meta;

	my $end = $iter->copy;
	$end->forward_char;
	$$self{buffer}->delete($iter, $end);
	$$self{buffer}->place_cursor($iter);
	$self->{buffer}->insert_blocks_at_cursor(['image', \%meta]);
}

=item C<Find(STRING)>

Shows the "Find" bar below the TextView.
STRING is optional query string, which is executed.

=item C<FindNext()>

Repeat previous find in forward direction.

=item C<FindPrev()>

Repeat previous find in backward direction.

=item C<CloseFind()>

Hides the "Find" bar.

=item C<FindReplace(STRING)>

Show the "Find and Replace" dialog.
STRING is the optional query string.

=cut

sub Find {
	my ($self, $query) = @_;
	unless ($self->{entry}->visible) {
		$self->{hbox}->set_no_show_all(0);
		$self->{hbox}->show_all;
	}
	if (length $query) {
		$self->{entry}->set_text($query);
		$self->_find($query, 0);
	}
	$self->{entry}->grab_focus;
}

sub FindNext { $_[0]->_find( $_[0]->{entry}->get_text, 1  ) }

sub FindPrev { $_[0]->_find( $_[0]->{entry}->get_text, -1 ) }

sub _find {
	my $self = shift;
	my $succes = $self->{htext}->search(@_);
	# set buttons active depending on whether we found something or not
	$_->set_sensitive($succes)
		for @{$self}{'find_prev_button', 'find_next_button'};
}

sub CloseFind {
	my $self = shift;
	$self->{hbox}->hide_all;
	$self->{hbox}->set_no_show_all(1);
	$self->{htext}->grab_focus;
}

sub FindReplace {
	$_[0]->{app}->FindReplaceDialog->show($_[1]);
}

=item C<InsertDate(DATE, NO_ASK)>

Inserts a date into the text.
DATE is optional and should be an array ref to the fields
as produced by C<localtime()>.
By default the current date is used.

A dialog with formatting options is presented to the user
unless NO_ASK is true.

=item C<prompt_date_format(DATE)>

Used by C<InsertDate()>.

=cut

sub InsertDate { # insert date that is linked
	my ($self, $date, $no_ask) = @_;
	$date ||= [localtime];
	
	my ($l, $fmt) = $no_ask
		? (1, "%c")
		: $self->prompt_date_format($date) ;
	return unless length $fmt;
	#warn "Got date fmt: $fmt link: $l\n";

	my $buffer = $self->get_buffer;
	my $string = Encode::decode($CODESET, strftime($fmt, @$date));
	my $ns = $self->{app}{settings}{'Calendar Plugin'}{Namespace}
		|| ':Date:' ;
		# FIXME HACK - should not hardcode plugin here !
	my $link = $ns . strftime('%Y:%m:%d', @$date) ;
	
	$buffer->insert_blocks_at_cursor(
		($l ? ['link', {to => $link}, $string] : $string), ' ' );
}

sub prompt_date_format {
	my ($self, $date) = @_;
	
	my $dialog = Gtk2::Dialog->new(
		__('Insert Date'), $self->{app}{window}, #. dialog title
		[qw/modal destroy-with-parent no-separator/],
		'gtk-cancel'  => 'cancel',
	);
	my $button = $self->new_button(
		'gtk-properties', __('_Edit')); #. dialog button
	$dialog->add_action_widget($button, 42);
	$button = $self->new_button(
		'gtk-ok', __('_Insert')); #. dialog button
	$dialog->add_action_widget($button, 'ok');
	
	my $view = Gtk2::SimpleList->new('Date' => 'scalar');
	$view->set_headers_visible(0);
	$view->get_selection->set_mode('browse');
	$view->signal_connect(
		row_activated => sub { $dialog->response('ok') });
	$dialog->vbox->add($view);

	my $check = Gtk2::CheckButton->new(__('_Link to date')); #. check box
	my $l = $self->{app}{settings}{recent_date_link};
	$check->set_active($l);
	$dialog->vbox->add($check);

	my $file = data_files('zim', 'dates.list');
	my @dates;
 	if (defined $file) {
 		for (file($file)->read()) {
 			chomp;
 			! /^\s*#/ and /\S/ or next;
 			push @dates, $_;
 		}
 	}
 	else { @dates = ('%A %d/%m/%Y', '%A %d/%m/%Y %H:%M', '%c', '%x') }

	# For some reason perl 5.10 segfaults if we use a map {} here !?
	foreach (@dates) {
	    push @{$view->{data}},
	    	Encode::decode($CODESET, strftime($_, @$date));
	}

	my $i = $self->{app}{settings}{recent_date_format};
	$view->select($i) if defined $i;
	
	$dialog->show_all;
	my $r = $dialog->run;
	if ($r eq 'ok') {
		($i) = $view->get_selected_indices;
		$self->{app}{settings}{recent_date_format} = $i;
		$l = $check->get_active;
		$self->{app}{settings}{recent_date_link} = $l;
		$dialog->destroy;
		return ($l, $dates[$i]);
	}
	elsif ($r == 42) {
		$file = data_files('zim', 'dates.list');
		my $rw_file = data_home('zim', 'dates.list');
		file($file)->copy($rw_file)
			if $file ne $rw_file and not -e $rw_file;
		$$self{app}->EditSource(undef, $rw_file); # using private arg
		$dialog->destroy;
		return $self->prompt_date_format($date); # recurs
	}
	else {
		$dialog->destroy;
		return undef;
	}
}

=item C<InsertLink(LINK, TEXT, NO_ASK)>

Insert LINK or prompt the user for a link.
LINK can be either a page, a file or a url, however the dialog only has
page name completion. See C<InsertExtLink> for an alternative interface.

NO_ASK is a boolean to suppress the prompt.

=item C<InsertExtLink(LINK, TEXT, NO_ASK)>

Like C<InsertLink()> but shows a dialog with a browse button
instead of page name completion.

=cut

sub InsertLink {
	# $ext is a private argument used for InsertExtLink
	my ($self, $link, $text, $no_ask, $ext) = @_;
	$text = $link unless length $text;
	($link, $text) = $self->_prompt_link_properties($link, $text, 0, $ext)
		unless defined $link and $no_ask;
	my ($t, undef) = $$self{app}{page}->parse_link($link, 'NO_RESOLVE');
	if ($t eq 'file') {
		my $file = $self->check_file_input($link);
		$file = $$self{app}{page}->relative_path($file);
		$text = $file if $text eq $link;
		$link = $file;
	}
	return unless defined $link;
	$self->{buffer}->insert_blocks_at_cursor(
		['link', {to => $link}, $text], ' ' );
}

sub InsertExtLink {
	my ($self, $link, $text, $no_ask) = @_;
	return $self->InsertLink($link, $text, $no_ask, 'EXTERNAL');
}

=item C<InsertImage(PATH, NO_ASK)>

Inserts an image into the buffer. PATH is an optional path for the
image. Unless NO_ASK is a dialog is presented which allows the user to set the
path and other properties for the image. An error is raised when NO_ASK is set
but no PATH is given.

If PATH is given and it is not absolute we assume it to be a relative path
returned by e.g. C<$page->store_file()>.

=cut

sub InsertImage {
	my ($self, $path, $no_ask) = @_;
	croak "BUG: no image path given" if $no_ask and ! defined $path;

	my %meta;
	if (defined $path) {
		# Image properties can be give in URL style
		%meta = split /[=&]/, $1
			if $path =~ s/\?(\w+=\w+(?:&\w+=\w+)*)$//;
	
		# The absolute path, $meta{file} is used to create the
		# pixbuf etc. The human readable $meta{src} is used to
		# present to the user and is the path that will be saved
		# in the wiki source.
		my $page = $$self{app}{page};
		@meta{'file', 'src'} = Zim::FS->is_abs_path($path)
				? ( $path, $page->relative_path($path) )
				: ( $page->resolve_file($path), $path  ) ;
	}
	else {
		$path = $self->filechooser_dialog(undef, 0, __('Insert Image')); #. dialog title
		return unless defined $path;
		$meta{src} = $path;
	}

	unless ($no_ask) {
		%meta = $self->_prompt_image_properties(undef, %meta);
		return unless length $meta{src};
	}

	# Insert image into buffer
	$self->{buffer}->insert_blocks_at_cursor(['image', \%meta]);
}

=item C<InsertFromFile(FILE, NO_ASK)>

Insert contents of FILE as verbatim.

=cut

sub InsertFromFile {
	my ($self, $file, $no_ask) = @_;
	unless (defined $file and $no_ask) {
		$file = $self->filechooser_dialog(
			$file, 0, __('Insert from file') ); #. dialog title
		return unless defined $file;
	}
	return $self->error_dialog(
		__("No such file: {file}", file => $file))
		unless -e $file;
	my $mt = mimetype("$file");
	return $self->error_dialog(
		__("File is not a text file: {file}", file =>$file)) #. error
		unless mimetype_isa($mt, 'text/plain');
	$$self{buffer}->insert_blocks_at_cursor(
		['Verbatim', {}, ''.file($file)->read] );
}

sub on_key_press_event_hbox {
	my ($hbox, $event, $self) = @_;
	return 0 unless $event->keyval == $k_escape;
	$self->CloseFind;
	return 1;
}

sub on_activate_entry {
	my ($self, $entry) = @_;
	$self->_find($entry->get_text, 0);
	$self->{htext}->grab_focus;
	$self->CloseFind;
}

=item C<WordCount()>

Pop up a dialog showing word, line and char count.

=cut

sub WordCount {
	my $self = shift;
	my $buffer= $self->{htext}->get_buffer;
	my %stat = (
		lines => $buffer->get_line_count,
		chars => $buffer->get_char_count,
	);

	my ($start, $end) = $buffer->get_bounds;
	my $words = 0;
	while ($start->forward_word_end()) {
		$words++;
	}
	$stat{words} = $words;

	warn "Lines: $stat{lines} Words: $stat{words} Chars: $stat{chars}\n";
	my $dialog = Gtk2::Dialog->new(
		__('Word Count'), $self->{app}{window}, #. dialog title
		[qw/modal destroy-with-parent no-separator/],
		'gtk-close'  => 'close',
	);
	my $table = Gtk2::Table->new(3, 2);
	$table->set_border_width(5);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);
	$dialog->vbox->add($table);

	my $i = 0;
	my %label = (
		lines => __('Lines'), #. label
		words => __('Words'), #. label
		chars => __('Chars'), #. label
	);
	for (qw/lines words chars/) {
		my $label = Gtk2::Label->new();
		$label->set_markup('<b>'.$label{$_}.':</b>');
		my $align = Gtk2::Alignment->new(0,0.5, 0,0);
		$align->add($label);
		$table->attach_defaults($align, 0,1, $i,$i+1);
		
		$label = Gtk2::Label->new($stat{$_});
		$align = Gtk2::Alignment->new(1,0.5, 0,0);
		$align->add($label);
		$table->attach_defaults($align, 1,2, $i,$i+1);

		$i++;
	}

	$table->show_all;
	$dialog->run;
	$dialog->destroy;
}

=back

=head2 Other Functions

=over 4

=cut

sub on_show_cursor {
	my $self = shift;
	$self->{htext}->set_cursor_visible(
		! $$self{app}{read_only}
			|| $$self{app}{settings}{ro_cursor} );
}

sub on_edit_mode_changed {
	my ($buffer, $self) = @_;
	my %tags;
	for ($buffer->get_edit_mode_tags) {
		my $name = $_->{is_link} ? 'link' : $_->get_property('name');
		$tags{$name} = 1;
	}

	if ( $tags{link} ) {
		my $data = $self->{htext}->get_link_at_cursor;
		if (defined $data) {
			my $p = $self->{app}{page};
			my ($t, $l) = $p->parse_link($data, 'NO_RESOLVE');
			$l = $p->resolve_name($l) if $t eq 'page';
			$self->{app}->push_status(
				__("Go to \"{link}\"", link => $l), 'link'); #. status bar info
		}
	}
	else { $self->{app}->pop_status('link') }

	$self->actions_show_active(
		TLink      => $tags{link},
		TBold      => $tags{bold},
		TItalic    => $tags{italic},
		TUnderline => $tags{underline},
		TStrike    => $tags{strike},
	) if $$self{actions};
	
	my ($tag) = grep {$_ ne 'link'} keys(%tags), 'normal';
	$$self{app}{statuss}->set_text($Styles{ucfirst($tag)});
}

sub on_toggle_overwrite {
	my $self = pop;
	my $over = $_[0]->get_overwrite;
	my $sbar = $self->{app}{status2};
	my $id = $sbar->get_context_id('over');
	if ($over) { $sbar->push($id, '  OVR') }
	else       { $sbar->pop($id)           }
}

sub on_drag_motion { # debugging purposes only
	my $context = $_[1];
	my @targets = map $_->name, $context->targets;
	warn "Drag motion with targets: @targets\n";
}

sub on_drag_data_received {
	my ($self, $context, $x, $y, $selection, $info, $time) = @_;
	my $type = $selection->target->name;
	my $data = $selection->data;
	#warn "$info ($time): $type: $data\n";

	return unless grep {$_ eq $type}
		qw#text/x-zim-page-list text/uri-list#;
	
	my @items = $self->decode_uri_list($data);
	my @blocks;
	if ($type eq 'text/x-zim-page-list') {
		my $rep = $$self{app}{notebook}{name};
		@blocks = map {
			if (s/^\Q$rep\E\?//) {
				$_ = $self->{app}{page}->relative_name($_);
			}
			['link', {to => $_}, $_], "\n"
		} @items;
	}
	else { # 'text/uri-list'
		@blocks = map {
			$_ = $self->{app}{page}->relative_path(
					Zim::FS->path2uri($_) ) 
				if m#^file:/#;
			if (m#^\w[\w\+\-\.]+:/#) { # uri
				['link', {to => $_}, $_], "\n";
			}
			else { # path
				my $mtype = mimetype($_);
				($mtype =~ /^image\//)
					? ['image', {src => $_}, $_]
					: ['link',  {to  => $_}, $_]
					, "\n" ;
			}
		} @items;
	}

	$$_[1]{file} = $$self{app}{page}->resolve_file($$_[1]{src})
		for grep {ref $_ and $$_[0] eq 'image'} @blocks;
	
	($x, $y) = $self->{htext}->window_to_buffer_coords('widget', $x, $y);
	my $iter = $self->{htext}->get_iter_at_location($x, $y);
	$self->{buffer}->insert_blocks($iter, @blocks);
}

sub on_populate_popup {
	# Add items to context menu. Object can be a link to a page, an URL 
	# (mail / file / http) or an image (which is a file)
	# images can have a custom type that is handled by a plugin.
	# (For example the EquationEditor uses special images.)
	my ($htext, $menu, $self) = @_;
	my $iter = $htext->get_iter_at_pointer;
	#warn "ITER ", $iter->get_offset, "\n";
	return unless $iter;
	
	my ($type, $meta);
	my $link = $htext->get_link_at_iter($iter);
	if (defined $link) {
		($type, $link) = $self->{app}{page}->parse_link($link);
	}
	else {
		# Try to find a pixbuf, since clicking on an image can result
		# in iters on both sides of the image we need to check also
		# on char backward for an pixbuf.
		my $pixbuf = $iter->get_pixbuf;
		unless ($pixbuf) {
			$iter->backward_char;
			$pixbuf = $iter->get_pixbuf;
		}
		return unless $pixbuf and $$pixbuf{image_data};
		$meta = $$pixbuf{image_data};
		($type, $link) = ('image', $$meta{file});
	}
	#warn "LINK: $link\n";
	
	_separator($menu);
	
	# Edit object
	my $edit_item = Gtk2::MenuItem->new(__('_Edit Link')); #. context menu
	$edit_item->show;
	$edit_item->signal_connect(activate => ($type eq 'image')
		? sub { $self->EditImage($iter) }
		: sub { $self->EditLink($iter)  }  );
		# We can not use $link here - need link as typed,
		# not as resolved. So we pass iter.
	$menu->prepend($edit_item);

	# Copy object
	my $copy_item = Gtk2::MenuItem->new(
		($type eq 'mail')
			? __('Copy Email Address') #. context menu
			: __('Copy _Link')  ); #. context menu
	$copy_item->signal_connect(activate => sub {
		# copy to both clipboard and selection
		my $l = $link;
		$l =~ s/^mailto://;
		warn "## Copy to clipoard: $l\n";
		for (qw/CLIPBOARD PRIMARY/) {
			my $c = Gtk2::Clipboard->get(
				Gtk2::Gdk::Atom->new($_) );
			$c->set_text($l);
		}
	} );
	$copy_item->show;
	$menu->prepend($copy_item);

	# Open Directory
	if ($type eq 'image' or $type eq 'file') {
		# This includes images with special type
		my $browse_item = Gtk2::ImageMenuItem->new_with_mnemonic(
			__('Open _Directory') ); #. context menu
		$browse_item->set_image(
			Gtk2::Image->new_from_stock('gtk-open', 'menu') );
		$browse_item->signal_connect(activate =>
			sub { $self->{app}->open_directory($link) } );
		$browse_item->show;
		$menu->prepend($browse_item);
	}

	if ($meta->{type} and exists $OBJECTS{$meta->{type}}) {
		# Here we handle images that have special actions
		# like equations etc.
		my $obj = $OBJECTS{$meta->{type}};
		$self->{app}->$obj->populate_popup($menu, $iter->get_pixbuf);
	}
	elsif ($type eq 'image' or $type eq 'file') {
		_separator($menu);

		# SendTo
		$self->_sendto_menu($menu, $link)
			if $self->{sendto_dir};
		
		# Open with...
		Gtk2::Ex::DesktopEntryMenu->populate_menu($menu, "$link")
			if $has_mimeapplications;
	}
	else {
		_separator($menu);

		# Open link
		my $open_item = Gtk2::MenuItem->new(
			__('_Open link') ); #. context menu
		$open_item->signal_connect(activate =>
			sub { $self->{app}->link_clicked($link) }  );
		$open_item->show;
		$menu->prepend($open_item);
	}
	
}

sub _separator {
	my $menu = shift;
	my $item = Gtk2::SeparatorMenuItem->new();
	$item->show;
	$menu->prepend($item);
}

sub _sendto_menu {
	my ($self, $menu, $file) = @_;
	$file = Zim::FS->abs_path($file);

	my $st_dir = $self->{sendto_dir} || return;
	my @dirs = ($st_dir);
	
	if (my $mt = mimetype("$file")) {
		$mt =~ m#(.+?)/(.+)#;
		push @dirs, "$st_dir/.$1" if -d "$st_dir/.$1";
		push @dirs, "$st_dir/.$1_$2" if -d "$st_dir/.$1_$2";
	}
	
	my $st_menu = Gtk2::Menu->new();
	for my $dir (dir($_), reverse @dirs) {
		for my $script ($dir->list) {
			my $item = Gtk2::MenuItem->new_with_label($script);
			$item->signal_connect(activate =>
				sub {Zim::Utils->run($dir->file($script), $file)} );
			$st_menu->append($item);
		}
	}

	my $sep = Gtk2::MenuItem->new();
	$st_menu->append($sep);
	
	my $custom = Gtk2::MenuItem->new(__('Customise')); #. context menu
	$custom->signal_connect(
		activate => sub {$self->{app}->open_directory($st_dir)} );
	$st_menu->append($custom);

	my $submenu = Gtk2::MenuItem->new(__('Send To...')); #. context menu
	$submenu->set_submenu($st_menu);
	$menu->prepend($submenu);
	$submenu->show_all;
}

sub on_key_press_event { # some extra keybindings
	# FIXME for more consistent behaviour test for selections
	my ($htext, $event, $self) = @_;
	my $val = $event->keyval;

	if ($$self{app}{read_only}) {
		# Unix like key bindings for read-only mode
		if ($val == ord '/') {
			$self->Find;
			return 1;
		}
		elsif ($val == ord ' ') {
			my $step = ($event->state >= 'shift-mask') ? -1 : 1 ;
			$self->{htext}->signal_emit('move-cursor', 'pages', $step, 0);
			return 1;
		}
		else { return 0 }
	}
	
	if ($val == $k_return or $val == $k_kp_enter) { # Enter
		my $buffer = $htext->get_buffer;
		my $iter = $buffer->get_iter_at_mark($buffer->get_insert());
		#return 1 if defined $htext->click_if_link_at_iter($iter); # ?
		$self->parse_word($iter); # end-of-line is also end-of-word
		$iter = $buffer->get_iter_at_mark($buffer->get_insert());
		$self->parse_line($iter) or return 0;
		$htext->scroll_mark_onscreen( $buffer->get_insert );
		return 1;
	}
	elsif (
		$self->{app}{settings}{backsp_unindent} and $val == $k_backspace
		or $val == $k_l_tab
		or $val == $k_tab and $event->state >= 'shift-mask'
	) { # BackSpace or Shift-Tab
		my $buffer = $htext->get_buffer;
		my ($start, $end) = $buffer->get_selection_bounds;
		if ($end and $end != $start) {
			my $cont = $self->selection_backspace($start, $end);
			return $val == $k_tab ? 1 : $cont;
		}
		my $iter = $buffer->get_iter_at_mark($buffer->get_insert());
		if ($self->parse_backspace($iter)) {
			$htext->scroll_mark_onscreen( $buffer->get_insert );
			return 1;
		}
	}
	elsif ($val == $k_tab or $val == ord(' ')) { # WhiteSpace
		my $buffer = $htext->get_buffer;
		if ($val == $k_tab) { # TAB
			my ($start, $end) = $buffer->get_selection_bounds;
			if ($end and $end != $start) {
				$self->selection_tab($start, $end);
				return 1;
			}
		}
		my $iter = $buffer->get_iter_at_mark($buffer->get_insert());
		my $string = ($val == $k_tab) ? "\t" : ' ';
		if ($self->parse_word($iter, $string)) {
			$htext->scroll_mark_onscreen( $buffer->get_insert );
			return 1;
		}
	}
	elsif ($val == ord('*') or $val == $k_multiply or $val == ord('>')) { # Bullet or Quote
		my $buffer = $htext->get_buffer;
		my ($start, $end) = $buffer->get_selection_bounds;
		return 0 if !$end or $end == $start;
		my $char = ($val == ord('>')) ? '>' : '' ;
		$self->toggle_bullets($start, $end, $char);
		return 1;
	}
	elsif ($val == $k_home and not $event->state >= 'control-mask') { # Home toggle
		my $buffer = $htext->get_buffer;
		my $insert = $buffer->get_iter_at_mark($buffer->get_insert());
		my $start  = $insert->copy;
		$htext->backward_display_line_start($start)
			unless $htext->starts_display_line($start);
		my $begin  = $start->copy;
		my $indent = '';
		while ($indent =~ /^\s*([^\s\w]\s*)?$/) {
			last if $begin->ends_line or ! $begin->forward_char;
			$indent = $start->get_text($begin);
		}
		$indent =~ /^(\s*([^\s\w]\s+)?)/;
		my $back = length($indent) - length($1);
		$begin->backward_chars($back) if $back > 0;
		$insert = ($begin->ends_line || $insert->equal($begin)) ? $start : $begin;
		if ($event->state >= 'shift-mask') {
			$buffer->move_mark_by_name('insert', $insert);
			# leaving the "selection_bound" mark behind
		}
		else { $buffer->place_cursor($insert) }
		return 1;
	}
		
	#else { printf "key %x pressed\n", $val } # perldoc -m Gtk2::Gdk::Keysyms

	return 0;
}

=item C<set_font(STRING)>

Set the default font for the pageview.
Calling with C<undef> as argument will reset to the default.

=cut

sub set_font {
	my ($self, $string) = @_;
	my $font = defined($string)
		? Gtk2::Pango::FontDescription->from_string($string)
		: undef ;
	$self->{htext}->modify_font($font);
}

=item C<get_state()>

Returns a HASH ref with properties that need to be saved in the history.

=cut

sub get_state {
	my $self = shift;
	my $buffer = $self->{buffer} || return;
	my $cursor = $buffer->get_iter_at_mark($buffer->get_insert)->get_offset;
	my $vscroll = $self->{scrolled_window}->get_vadjustment->get_value;
	my $hscroll = $self->{scrolled_window}->get_hadjustment->get_value;
	my %rec = (cursor  => $cursor,
	           vscroll => $vscroll,
		   hscroll => $hscroll  );
	#warn "get_state cursor @ $cursor ($vscroll, $hscroll)\n";
	return \%rec;
}

=item C<set_state(\%PROPETIES)>

Set a number of properties that were saved in the history.

=cut

sub set_state {
	my $self = shift;
	my %rec = %{shift()};
	#warn "set_state cursor @ $rec{cursor} (@rec{'vscroll', 'hscroll'})\n";
	if (defined $rec{cursor}) {
		$self->{buffer}->place_cursor(
			$self->{buffer}->get_iter_at_offset($rec{cursor}) );
	
		$self->{htext}->scroll_mark_onscreen( $self->{buffer}->get_insert );
	}
	if (defined $rec{vscroll}) {
		my $vadj = $self->{scrolled_window}->get_vadjustment;
		$vadj->set_value($rec{vscroll});
		$vadj->value_changed;
	}
	if (defined $rec{hscroll}) {
		my $hadj = $self->{scrolled_window}->get_hadjustment;
		$hadj->set_value($rec{hscroll});
		$hadj->value_changed;
	}
}

=item C<load_page(PAGE)>

Load a new page in the page view widgets.

=cut

sub load_page {
	my ($self, $page) = @_;
	my $mode = $page->properties->{view};
	$self->on_exit_mode
		if $self->{mode} and $mode ne $self->{mode};
	if ($mode and $mode ne $self->{mode}) { # to special mode
		my $class = 'Zim::GUI::PageView::'.ucfirst(quotemeta($mode));
		eval "use $class";
		unless ($@) {
			bless $self, $class;
			$self->on_enter_mode;
		}
		else { warn $@ }
	}
	elsif ($self->{mode} and ! $mode) { # to default mode
		bless $self, 'Zim::GUI::PageView';
	}
	$self->{mode} = $mode;
	$self->load_page_contents($page);
}

sub on_enter_mode {} # stub to be overloaded

sub on_exit_mode {} # stub to be overloaded

=item C<load_page_contents(PAGE, TREE)>

To be overloaded by child classes, use C<load_page()> from the GUI.

Load the contents of PAGE into the buffer.
This method should die when an error is encountered.

TREE is an optional argument, child classes do not need to support it.

=cut

sub load_page_contents {
	my ($self, $page, $tree) = @_;
	my $use_spell = defined $self->{app}{objects}{Spell}; # FIXME ugly internals
	$tree ||= $page->get_parse_tree(); 
	
	# clear the old buffer
	$self->{buffer}->clear if $self->{buffer};
	$self->{app}->Spell->detach($self->{htext}) if $use_spell;
	$self->{_prev_buffer} = $self->{buffer}; # FIXME hack to prevent segfaults
	# set up the new buffer
	$self->_init_buffer;
	my $buffer = $$self{buffer};
	$buffer->set_parse_tree( $tree );
	$self->{app}->Spell->attach($self->{htext}) if $use_spell;
	
	if ($page->exists) {
		$buffer->place_cursor(
	 	      	$buffer->get_iter_at_offset(0) );
	}
	else { # new page, place cursor below headers
		my (undef, $iter) = $buffer->get_bounds;
		$buffer->place_cursor( $iter );
	}
	on_edit_mode_changed($buffer, $self);
	
	$self->{htext}->scroll_mark_onscreen( $buffer->get_insert );

	$buffer->set_modified(0);
	$self->_match_all_words($buffer, $page)
		if $self->{app}{settings}{use_autolink} && $page->exists;
}

=item C<modified()>

=item C<modified(BOOLEAN)>

Get or set the modified bit. This bit is set when the buffer
is modified by the user.
It should be reset after succesfully saving the buffer content.

=cut

sub modified {
	return 0 unless defined $_[0]->{buffer};
	$_[0]->{buffer}->set_modified($_[1]) if defined $_[1];
	$_[0]->{buffer}->get_modified;
}

=item C<save_page(PAGE)>

Save current buffer contents to PAGE.

=cut

sub save_page {
	my ($self, $page) = @_;
	my $existed = $page->exists;
	my $ack = $self->save_page_contents($page);
	if ($ack) {
		my $act = $existed ? 'page_saved' : 'page_created';
		$self->{app}->signal_emit($act => $page->name);
	}
	else { # page was empty => delete instead of save
		$page->delete;
		$self->{app}->signal_emit('page_deleted', $page->name);
	}
	$self->modified(0);
}

=item C<save_page_contents(PAGE)>

To be overloaded by child classes, use C<save_page()> from the GUI.

This method saves the buffer contents to PAGE.
Should return 1 on success or 0 when the buffer was empty.
Returning 0 results in the page being deleted.

This method should die when an error is encountered.

=cut

sub save_page_contents {
	my ($self, $page) = @_;
	my $tree = $self->{buffer}->get_parse_tree;
	return 0 unless @$tree > 2 ; # check content in buffer
	$page->set_parse_tree($tree);
	return 1;
}

=item C<change_widget(WIDGET)>

Replaces the curren page view widget in the interface with WIDGET.
Returns the old widget.

=cut

sub change_widget {
	my ($self, $widget) = @_;
	my $old = $self->{top_widget};
	#warn "switching $old for $widget\n";
	$self->{app}{r_vbox}->remove($old);
	$self->{app}{r_vbox}->pack_end($widget, 1,1,0);
	$self->{top_widget} = $widget;
	$self->{app}{vbox}->set_focus_chain($self->{app}{l_vbox}, $widget);
	return $old;
}

=item C<parse_backspace(ITER)>

This method is called when the user types a backspace.
It tries to update the formatting of the current line.
 
When TRUE is returned the widget does not receive the backspace.

=cut

sub parse_backspace {
	my ($self, $iter) = @_;
	my $buffer = $self->{buffer};
	my $lf = $buffer->get_iter_at_line( $iter->get_line );
	my $line = $buffer->get_slice($lf, $iter, 0);
	if ($line =~ /\t([\*\x{2022}\x{FFFC}]\s)$/) {
		$iter->backward_chars(length $1);
		my $begin = $iter->copy;
		$begin->backward_char;
		_user_action_ {
			$buffer->delete($begin, $iter);
		} $buffer;
		return 1;
	}
	elsif ($line =~ /\t$/) {
		my $back = $iter->copy;
		$back->backward_char;
		_user_action_ { $buffer->delete($back, $iter) } $buffer;
		return 1;
	}
	return 0;
}

=item C<parse_line(ITER)>

This method is called when the user is about to insert a linebreak.
It checks the line left of the cursor of any markup that needs 
updating. It also takes care of autoindenting.

When TRUE is returned the widget does not receive the linebreak.

=cut

#use Roman;

sub parse_line {
	my ($self, $iter) = @_;
	my $buffer = $self->{buffer};
	my $Verbatim = $buffer->get_tag_table->lookup('Verbatim');
	$buffer->set_edit_mode_tags(
		grep {$_ eq $Verbatim}
		$buffer->get_edit_mode_tags() ); # reset all tags except Verbatim
	my $lf = $buffer->get_iter_at_line( $iter->get_line );
	my $line = $buffer->get_slice($lf, $iter, 0);
		# Need to use get_slice instead of get_text to avoid deleting
		# images because we think a range is empty
	#print ">>$line<<\n";
	if ($line =~ s/^(=+)\s*(\w)/$2/) { # heading
		my $offset;
		($lf, $offset) = ($lf->get_offset, $iter->get_offset);
		_user_action_ { $buffer->insert($iter, "\n") } $buffer;
		($lf, $iter) = map $buffer->get_iter_at_offset($_), $lf, $offset;
		$iter->forward_char;
		my $h = length($1); # no (7 - x) monkey bussiness here
		$h = 5 if $h > 5;
		$line =~ s/\s+=+\s*$//;
		$offset = $lf->get_offset + length $line;
		_user_action_ {
			$buffer->delete($lf, $iter);
			$buffer->insert_with_tags_by_name($lf, $line, "head$h");
			$iter = $buffer->get_iter_at_offset($offset);
			$buffer->insert($iter, "\n");
		} $buffer;
		return 1;
	}
	elsif ($line =~ /^(\s*(:?\W+|\d+\W?|\w\W)(\s+)|\s+)$/) { # empty bullet or list item
		my $post = $2;
		# TODO check previous line for same pattern !
		if ($line =~ /\x{FFFC}/) { # embedded image or checkbox
			my $i = $iter->copy;
			$i->backward_chars(length($post)+1);
			my $pixbuf = $i->get_pixbuf;
			return 0 unless $pixbuf and $$pixbuf{image_data}{type} eq 'checkbox';
		}
		_user_action_ { $buffer->delete($lf, $iter) } $buffer;
	}
#	elsif ($line =~ /^(\s*(\w+)\W\s+)/ and isroman($2)) {
#		my ($indent, $num) = ($1, Roman(arabic($2)+1));
#		$indent =~ s/\w+/$num/;
#		my $offset = $iter->get_offset;
#		_user_action_ { $buffer->insert($iter, "\n") } $buffer;
#		$iter = $buffer->get_iter_at_offset($offset);
#		$iter->forward_char;
#		_user_action_ { $buffer->insert($iter, "$indent") } $buffer;
#		$self->{htext}->scroll_mark_onscreen( $buffer->get_insert() );
#		return 1;
#	}
	elsif ($line =~ /^(\s*(\W+|\d+\W?|\w\W)(\s+)|\s+)/) { # auto indenting + aotu incremnt lists
		my ($indent, $number, $post) = ($1, $2, $3);
		$number =~ s/\W//g;
		if ($indent =~ /\x{FFFC}/) { # embedded image or checkbox
			my $i = $lf->copy;
			$i->forward_chars(length($indent)-length($post)-1);
			my $pixbuf = $i->get_pixbuf;
			return 0 unless $pixbuf and $$pixbuf{image_data}{type} eq 'checkbox';
		}
		elsif (length $number) { # numbered list
			return 0 unless $$self{app}{settings}{use_autoincr};
			$number = ($number =~ /\d/)
				? $number+1
				: chr(ord($number)+1) ;
			$indent =~ s/(\d+|\w)/$number/;
		}
		my $offset = $iter->get_offset;
		_user_action_ { $buffer->insert($iter, "\n") } $buffer;
		$iter = $buffer->get_iter_at_offset($offset);
		$iter->forward_char;
		if ($indent =~ /\x{FFFC}/) { # checkbox
			my ($begin, $end) = split /\x{FFFC}/, $indent, 2;
			$buffer->insert_blocks_at_cursor(
				$begin, ['checkbox', {state => 0}], $end)
		}
		else {
			_user_action_ {
				$buffer->insert($iter, "$indent")
			} $buffer;
		}
		$self->{htext}->scroll_mark_onscreen( $buffer->get_insert() );
		return 1;
	}
	return 0;
}

=item C<parse_word(ITER, CHAR)>

This method is called after the user ended typing a word.
It checks the word left of the cursor for any markup that
needs updating.

CHAR can be the key that caused a word to end, returning TRUE
makes it never reaching the widget.

=cut

sub parse_word {
	# remember that $char can be empty
	# first insert the char, then replace it, keep undo stack in proper order
	my ($self, $iter, $char) = @_;
	return 0 if $self->_is_verbatim($iter);
	my $buffer = $self->{buffer};
	my $lf = $iter->copy;
	$self->{htext}->backward_display_line_start($lf)
		unless $self->{htext}->starts_display_line($lf);
	my $line = $buffer->get_slice($lf, $iter, 0);
	#warn ">>$line<< >>$char<<\n";
	if ($line =~ /^\s*([\*\x{2022}\x{FFFC}]|(?:[\*\x{2022}]\s*)?\[[ *xX]?\])(\s*)$/) {
		# bullet or checkbox (or checkbox prefixed with bullet)
		return unless $lf->starts_line; # starts_display_line != starts_line
		my ($bullet, $post) = ($1, $2);
		if ($bullet eq "\x{FFFC}") {
			my $i = $iter->copy;
			$i->backward_chars(length($bullet.$post));
			my $pixbuf = $i->get_pixbuf;
			return unless $pixbuf and $$pixbuf{image_data}{type} eq 'checkbox';
		}
		my $offset;
		if (defined $char) {
			# insert char 
			$offset = $iter->get_offset;
			_user_action_ { $buffer->insert($iter, $char) } $buffer;
			$iter = $buffer->get_iter_at_offset($offset);
			if (defined $char and $char eq "\t") {
				# delete the char again and indent
				my $end = $iter->copy;
				$end->forward_char;
				_user_action_ {
					$buffer->delete($iter, $end);
					$iter = $buffer->get_iter_at_offset($offset);
					$buffer->insert($iter, ' ') unless length $post;
					$iter = $buffer->get_iter_at_offset($offset);
					$iter->backward_chars(length $bullet.$post);
					$buffer->insert($iter, "\t");
				} $buffer;
				$iter = $buffer->get_iter_at_offset($offset+1);
			}
		}
		my $end = $iter->copy;
		$iter->backward_chars(length $bullet.$post);
		$end->backward_chars(length $post);
		if ($bullet eq '*') {
			# format bullet
			_user_action_ {
				$buffer->delete($iter, $end);
				$buffer->insert($iter, "\x{2022}");
			} $buffer;
		}
		elsif ($bullet =~ /\[([ *xX]?)\]/) {
			# format checkbox
			my $state = ($1 eq '*') ? 1 : (lc($1) eq 'x') ? 2 : 0 ;
			$offset = $iter->get_offset;
			_user_action_ {
				$buffer->delete($iter, $end);
				$buffer->place_cursor($iter);
				$buffer->insert_blocks_at_cursor(['checkbox', {state => $state}]);
			} $buffer;
			$iter = $buffer->get_iter_at_offset($offset+1);
			$iter->forward_chars(length($post)+1);
			$buffer->place_cursor($iter);
		}
		return 1;
	}
	elsif (
		$line =~ qr{(?<!\S)(\w[\w\+\-\.]+://\S+)$} # url
		or $line =~ qr{ (?<!\S)(
		        [\w\.\-\(\)]*(?: :[\w\.\-\(\)]{2,} )+:?
		      | \.\w[\w\.\-\(\)]+(?: :[\w\.\-\(\)]{2,} )*:?
		            )$  }x # page (ns:page .subpage)
		or $line =~ qr{(?<!\S)(
		      \w[\w\+\-\.]+\?\w\S+
		            )$}x # interwiki (name?page)
		or ( $self->{app}{settings}{use_linkfiles}
		  and $line =~ qr{ (?<!\S)( (?:
	  	      ~/[^/\s] | ~[^/\s]*/ | \.\.?/ | /[^/\s]
		               ) \S* )$  }x ) # file (~/ ~name/ ../ ./ /)
		or ( $self->{app}{settings}{use_camelcase}
		  and $line =~ qr{(?<!\S)(
	  	      [[:upper:]]+[[:lower:]]+[[:upper:]]+\w*
		               )$}x  ) # CamelCase
	) { # any kind of link
		my $word = $1;
		return 0 if $word !~ /[[:alpha:]]{2}/; # at least two letters in there
		return 0 if $word =~ /^\d+:/; # do not link "10:20h", "10:20PM" etc.
		my ($start, $end) = ($iter->copy, $iter->copy);
		$start->backward_chars(length $word);
		return 0 if grep {$_->get_property('name') !~ /spell/}
			$start->get_tags, $end->get_tags;
		if (defined $char) {
			($start, $end) = ($start->get_offset, $end->get_offset);
			_user_action_ { $buffer->insert($iter, $char) } $buffer;
			($start, $end) = map $buffer->get_iter_at_offset($_), $start, $end;
		}
		_user_action_ {
			$self->{htext}->apply_link(undef, $start, $end);
		} $buffer;
		return 1;
		
	}
	elsif ( $self->{app}{settings}{use_utf8_ent} &&
		$line =~ /(?<!\S)\\(\w+)$/
	) { # utf8 chars
		my $word = $1;
		my $chr = _entity($word);
		return 0 unless defined $chr;
		
		if (defined $char) {
			my $offset = $iter->get_offset;
			_user_action_ { $buffer->insert($iter, $char) } $buffer;
			$iter = $buffer->get_iter_at_offset($offset)
		}
		my $begin = $iter->copy;
		$begin->backward_chars(1 + length $word);
		_user_action_ {
			$buffer->delete($begin, $iter);
			$buffer->insert($begin, $chr);
		} $buffer;
		return 1;
	}
#	elsif ($line =~ /^(\t|  )/) { # pre
#		# FIXME \s* => \t
#		$iter->forward_char unless $iter->is_end; # FIXME somthing at end
#		$buffer->apply_tag_by_name('pre', $lf, $iter);
#	}
	elsif ($self->{app}{settings}{use_autolink}) {
		$self->_match_words($buffer, $iter);
	}
	
	return 0;
}

my %_entities; # cache entity lookup

sub _entity {
	my $key = shift;
	return chr($key) if $key =~ /^\d+$/;
	unless (exists $_entities{$key}) {
		for (data_files(qw/zim entities.list/)) {
			for (file($_)->read) {
				next unless /^\Q$key\E\s+(\d+)/;
				$_entities{$key} = chr($1);
				last;
			}
		}
	}
	return $_entities{$key};
}

sub _match_words {
	my ($self, $buffer, $iter, $page) = @_;
	return if $iter->starts_line;
	$page ||= $self->{app}{page};
	my $start = $iter->copy;
	$start->backward_chars( $iter->get_line_offset );
	my $line = $start->get_text($iter);
	
	while ($line =~ /\w/) {
		my ($word) = ($line =~ /(\w+)/);
		#warn "Checking: >>$word<<\n";
		while ($_ = $page->match_word($word)) {
			warn "Matching: $_ for >>$word<<\n";
			# match_word returns 1 for single match
			#            and 2 for multiple or partial matches
			if ($_ == 1) {
				my $start = $iter->copy;
				$start->backward_chars(length $line);
				my $end = $start->copy;
				$end->forward_chars(length $word);
				last if $start->get_tags or $end->get_tags;
				$self->{htext}->apply_link(undef, $start, $end);
				last;
			}
			else {
				($word) = ($line =~ /(\Q$word\E\W+\w+)/);
				last unless $word;
			}
		}
		$line =~ s/^\W*\w+\W*//;
		#warn "line: >>$line<<\n";
	}
}

sub _match_all_words { # call _match_words on all lines
	my ($self, $buffer, $page) = @_;
	my ($iter, undef) = $buffer->get_bounds;
	while ($iter->forward_to_line_end) {
		$self->_match_words($buffer, $iter, $page);
	}
}

sub _is_verbatim {
	my ($self, $iter) = @_;
	for ($iter->get_tags) {
		return 1 if lc($_->get_property('name')) eq 'verbatim';
	}
	return 0;
}

=item C<toggle_bullets()>

If selected text is a bullet list this removes the bullets, else it adds
bullets.

=cut

sub toggle_bullets {
	my ($self, $start, $end, $char) = @_;
	my $buffer = $self->{buffer};
	($start, $end) = $buffer->get_selection_bounds unless defined $start;
	return if !$end or $start == $end;
	
	my $text = $self->{buffer}->get_text($start, $end, 1);
	my $match = length($char) ? quotemeta($char) : qr/[\*\x{2022}]/;
	if ($text =~ /^\s*$match\s+/m) { # remove bullets
		$text =~ s/^(\s*)$match\s+/$1/mg
	}
	else { # set bullets
		$char ||= "\x{2022}";
		$text =~ s/^(\s*)(\S)/$1$char $2/mg;
	}

	_user_action_ { $buffer->replace_selection($text) } $buffer;
}

=item C<selection_tab()>

Puts a tab before every line of a selection.

=cut

sub selection_tab {
	my ($self, $start, $end) = @_;
	my $buffer = $self->{buffer};
	($start, $end) = $buffer->get_selection_bounds
		unless defined $start;
	return if !$end or $start == $end;
	
	# Collect offsets
	my @offsets;
	push @offsets, $start->get_offset if $start->starts_line;
	$start->forward_line;
	while ($start->compare($end) == -1) {
		push @offsets, $start->get_offset;
		$start->forward_line;
	}

	# Insert tabs at offsets
	_user_action_ {
		for (reverse @offsets) {
			my $iter = $buffer->get_iter_at_offset($_);
			$buffer->insert($iter, "\t");
		}
	} $buffer;
}

=item C<selection_backspace()>

Removes a tab for every line of a selection.

=cut

sub selection_backspace {
	my ($self, $start, $end) = @_;
	my $buffer = $self->{buffer};
	($start, $end) = $buffer->get_selection_bounds unless defined $start;
	return if !$end or $start == $end;

	# Collect offsets
	my @offsets;
	push @offsets, $start->get_offset
		if $start->starts_line and $start->get_char eq "\t";
	$start->forward_line;
	while ($start->compare($end) == -1) {
		push @offsets, $start->get_offset
			if $start->get_char eq "\t";
		$start->forward_line;
	}
	return 0 unless @offsets; # default deletes selection

	# Delete tabs
	_user_action_ {
		for (reverse @offsets) {
			$buffer->delete(
				$buffer->get_iter_at_offset($_),
				$buffer->get_iter_at_offset($_+1) );
		}
	} $buffer;

	return 1;
}

sub _prompt_link_properties {
	my ($self, $link, $text, $edit, $ext) = @_;

	# Run the dialog
	my $val = $self->run_prompt(
		($edit ? __('Edit Link') : __('Insert Link')), #. dialog title
		['txt', 'link'], {
			txt  => [__('Text'), 'string', $text], #. dialog label
			link => [__('Links to'), #. dialog label
				($ext ? 'file' : 'page'), $link],
		}, 'gtk-connect', __('_Link') ) #. dialog button
		or return;
	($text, $link) = @$val;
	return unless $text =~ /\S/ or $link =~ /\S/;
	
	# both entries default to the other
	$link = $text unless $link =~ /\S/;
	$text = $link unless $text =~ /\S/;

	return $link, $text;
}

# This is a quite complicated dialog because we want to have the
# properties for resizing the image under an expander. So we have
# some code to add the expander and add a second form under it.
# Also the logic for resizing forces the width and height to stay
# locked to each other in order to keep a fixed ration. When we
# return we only return either width or height, depending on which
# one the user changed last.

sub _prompt_image_properties {	
	my ($self, $pixbuf, %meta) = @_;
	%meta = (%{$$pixbuf{image_data}}, %meta)
		if $pixbuf and $$pixbuf{image_data};

	# Base dialog with input field for file name
	my ($dialog, $entries) = $self->new_prompt(
		($pixbuf ? __('Edit Image') : __('Insert Image') ), #. dialog title
		['src'], {src => [__('Source'), 'file', $meta{src}]}, #. dialog label
		'gtk-connect', __('_Link') ); #. dialog button
	
	# Add expander with advanced properties
	my ($w, $h, $ratio) = (0, 0, 1);
	if ($pixbuf) {
		($w, $h) = ($pixbuf->get_width, $pixbuf->get_height);
		$ratio = $w / $h;
	}

	my $frame = Gtk2::Expander->new_with_mnemonic(
		__('_Properties') ); #. expander label
	$dialog->vbox->add($frame);
	# logic to resize dialog after hiding the exander..
	# listening to notify::expanded doesn't work since the size did not
	# change yet when that event is emitted.
	$frame->signal_connect_after(size_request => sub {
		return if $frame->get_expanded;
		my ($width, $height) = $dialog->get_size;
		$dialog->resize($width, 1);
			# do not touch width, minimize height
	} );

	# Create the form for inside the expander. Allow size to range
	# from 1 pixel to 4 times the current size (yes, this is arbitrary).
	# Step size will be 1 of course.
	my ($table, $spin) = $self->new_form(
		['width', 'height'], {
			width  => [__('Width'),  'int', $w, [1, 4*$w||1, 1]], #. input label
			height => [__('Height'), 'int', $h, [1, 4*$h||1, 1]], #. input label
		} );
	$table->set_border_width(24);
	$frame->add($table);

	my $block = 0;
		# only react to user changes, not internal ones
	my $changed = $meta{width} ? 'w' : $meta{height} ? 'h' : undef ;
		# use this parameter to keep track of latest change
	$$spin[0]->signal_connect(value_changed => sub {
		# width changed, update height according to ratio
		return if $block;

		$changed = 'w';
		$w = $$spin[0]->get_value;
		$h = int $w / $ratio;

		$block = 1;
		$$spin[1]->set_value($h);
		$block = 0;
	} );
	$$spin[1]->signal_connect(value_changed => sub {
		# heigth changed, update width according to ratio
		return if $block;

		$changed = 'h';
		$h = $$spin[1]->get_value;
		$w = int $ratio * $h;

		$block = 1;
		$$spin[0]->set_value($w);
		$block = 0;
	} );

	# this button resets height and width to the actual image size
	my $reset_button = Gtk2::Button->new(__('_Reset')); #. button
	$table->attach_defaults($reset_button, 1,2, 2,3);

	$reset_button->signal_connect(clicked => sub {
		# This will read the dimensions from the actual file and
		# set the spin buttons.
		$_->set_sensitive(0) for @$spin;
		$changed = undef;

		my $file = $$entries[0]->get_text;
		return unless length $file;
		$file = $self->check_file_input($file);
		
		($w, $h) = (0, 0);
		eval { # dies on my win32 installation
			(undef, $w, $h) =
				Gtk2::Gdk::Pixbuf->get_file_info($file);
		} if -f $file and -r _ ;

		if ($w && $h) {
			# file exists and eval did not die
			$ratio = $w / $h;
			$block = 1; # block signals
			$$spin[0]->set_range(1, 4*$w);
			$$spin[0]->set_value($w);
			$$spin[1]->set_range(1, 4*$h);
			$$spin[1]->set_value($h);
			$block = 0;
			$_->set_sensitive(1) for @$spin;
		}
		else {
			# image does not exist or get_info died
			# anyway spin buttons will be insensitive
			$_->set_value(0) for @$spin;
		}
	} );
	$reset_button->clicked unless $pixbuf; # init for new files

	# Run the dialog
	$dialog->show_all;
	my $r = $dialog->run;
	$dialog->destroy;
	return unless $r eq 'ok';

	# get the file name and optionally the properties
	my $path = $$entries[0]->get_text;
	return unless $path =~ /\S/;

	my $file = $self->check_file_input($path);
	$meta{file} = $file->path;
	$meta{src} = $$self{app}{page}->relative_path($file);
		# The absolute path, $meta{file} is used to create the
		# pixbuf etc. The human readable $meta{src} is used to
		# present to the user and is the path that will be saved
		# in the wiki source.
	if ($changed eq 'w') { # width was set explicitly
		$meta{width}  = $w;
		delete $meta{height};
	}
	elsif ($changed eq 'h') { # heigth was set explicitly
		$meta{height} = $h;
		delete $meta{width};
	}
	else { # we used reset
		delete $meta{width};
		delete $meta{height};
	}

	return %meta;
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

