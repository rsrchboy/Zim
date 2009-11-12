package Gtk2::Ex::HyperTextView;

our $VERSION = '0.28';

use strict;
use vars '%TAGS';
use Gtk2;
use Gtk2::Gdk::Keysyms;
use Glib::Object::Subclass
	Gtk2::TextView::,
	signals => {
		# new signals
		link_clicked    => { param_types => [qw/Glib::Scalar/] },
		link_enter      => { param_types => [qw/Glib::Scalar/] },
		link_leave      => { },
		# overloaded signals
		copy_clipboard  => \&on_copy_clipboard,
		cut_clipboard   => \&on_cut_clipboard,
		paste_clipboard => \&on_paste_clipboard,
	 };

=head1 NAME

Gtk2::Ex::HyperTextView - A TextView widget with hyper links

=head1 DESCRIPTION

This module derives from Gtk2::TextView but adds code to have
hyperlinks in your text. It adds 3 signals to make it easier to
work with links.

This module can be used together with L<Gtk2::Ex::HyperTextBuffer>
but also with other TextBuffer classes.

=head1 HIERARCHY

  Glib::Object
  +----Gtk2::Object
        +----Gtk2::Widget
              +----Gtk2::Container
                    +----Gtk2::TextView
                          +---- Gtk2::Ex::HyperTextView

=head1 METHODS

=over 4

=item C<new()>

=item C<new_with_buffer(BUFFER)>

Constructors.

=cut

*TAGS = \%Gtk2::Ex::HyperTextBuffer::TAGS;
$TAGS{link} ||= [foreground => 'blue', underline => 'single'];

# sub new() inherited from Glib::Object

sub new_with_buffer {
	# needs to be overoaded, TextView->new_with returns TextView object
	my ($class, $buffer) = @_;
	my $self = $class->new();
	$self->set_buffer($buffer);
	return $self;
}

sub INIT_INSTANCE {
	my $self = shift;
	
	$self->{text_cursor} = Gtk2::Gdk::Cursor->new('xterm');
	$self->{link_cursor} = Gtk2::Gdk::Cursor->new('hand2');
	$self->{arrow_cursor} = Gtk2::Gdk::Cursor->new('left_ptr');
	$self->{cursor} = 'text_cursor';
	$self->{follow_on_enter} = 1;
	
	$self->signal_connect_after('realize' => sub {
		my ($view) = @_;

		$view->get_window('text')->set_events([ qw(
			pointer-motion-mask
			button-release-mask
			key-press-mask
			exposure-mask
			button-press-mask
			structure-mask
			property-change-mask
			scroll-mask	)]);
		return 0;
	});
	$self->set_wrap_mode('word');
	
	# existing signals
	$self->signal_connect(motion_notify_event => \&on_motion_notify_event);
	$self->signal_connect(visibility_notify_event => \&on_visibility_notify_event);
	$self->signal_connect(button_release_event => \&on_button_release_event);
	$self->signal_connect(key_press_event => \&on_key_press_event);
}

=item insert_link_at_iter(START, TEXT, DATA)

Inserts a piece of text into the buffer, giving it the usual appearance of a
hyperlink in a web browser: blue and underlined. Additionally, attaches some
data on the tag, to make it recognizable as a link.

DATA is the argument that will be passed back on events for this link,
it can be any perl scalar.

=cut

sub insert_link_at_iter {
	my ($self, $iter, $text, $data) = @_;
	$data = $text unless defined $data;
	
	my $tag = $self->_create_link_tag($data);
	$self->get_buffer->insert_with_tags($iter, $text, $tag);
}

sub _create_link_tag {
	my($self, $data) = @_;
	
	my $tag = $self->get_buffer->create_tag(
		undef, @{$TAGS{link}} );
	$tag->{is_link}   = 1;
	$tag->{link_data} = $data;

	return $tag;
}

=item apply_link(DATA, START, END)

Makes a link of all text between START and END and attaches
the perl scalar DATA to this link.

=cut

sub apply_link {
	my ($self, $data, $start, $end) = @_;

	my $tag = $self->_create_link_tag($data);
	$self->get_buffer->apply_tag($tag, $start, $end);
}

=item get_link_at_cursor( )

Returns link data or undef.

=cut

sub get_link_at_cursor {
	my $self = shift;
	my $buffer = $self->get_buffer;
	my $iter = $buffer->get_iter_at_mark($buffer->get_insert);
	return $self->get_link_at_iter($iter);
}

=item get_link_at_pointer( )

Like L<get_link_at_cursor( )> except that it looks at the
mouse cursor, not at the text cursor.

=cut

sub get_link_at_pointer {
	my $self = shift;
	my $iter = $self->get_iter_at_pointer;
	return unless defined $iter;
	return $self->get_link_at_iter($iter);
}

=item get_link_at_iter(ITER)

Returns link data or undef.

=cut

sub get_link_at_iter { # $tag is a private argument
	my ($self, $iter, $tag) = @_;
	($tag) = grep {$_->{is_link}} $iter->get_tags unless $tag;
	return undef unless $tag;
	my $link_data = $tag->{link_data};
	unless (defined $link_data) {
		my ($begin, $end) = ($iter->copy, $iter->copy);
		$begin->backward_to_tag_toggle($tag) unless $begin->begins_tag($tag);
		$end->forward_to_tag_toggle($tag) unless $end->ends_tag($tag);
		$link_data = $begin->get_text($end);
	}
	return $link_data;
}

=item click_if_link_at_cursor( )

Emits the link_clicked signal if the text cursor is at a link.

Returns undef or link data.

=cut

sub click_if_link_at_cursor {
	my $self = shift;
	my $buffer = $self->get_buffer;
	my $iter = $buffer->get_iter_at_mark($buffer->get_insert);
	return $self->click_if_link_at_iter($iter);
}

=item click_if_link_at_iter(ITER)

Emits the link_clicked signal if ITER is part of a link.

Returns undef or link data.

=cut

sub click_if_link_at_iter {
	my ($self, $iter) = @_;

	my $link_data = $self->get_link_at_iter($iter);
	return unless $link_data;
	
	$self->signal_emit('link_clicked', $link_data);
	return $link_data;
}

=item C<get_iter_at_pointer()>

Returns the text iter for the current pointer (mouse cursor) position.

=cut

sub get_iter_at_pointer {
	my $self = shift;
	my ($x, $y) = $self->get_pointer;
	   ($x, $y) = $self->window_to_buffer_coords('widget', $x, $y);
	return unless defined $x;
	my $iter = $self->get_iter_at_location($x, $y);
}

=item set_cursor_if_appropriate(X, Y)

Looks at all tags covering the position (X, Y) in the text view, 
and if one of them is a link, change the cursor to the "hands" 
cursor typically used by web browsers.

If no (X, Y) is given the pointer coordinates are used.

This method is called on a number of events.

Returns the link data if the cursor is above a link.

=cut

sub set_cursor_if_appropriate {
	my ($self, $x, $y) = @_;
	
	my $iter = defined($x) 
		? $self->get_iter_at_location($x, $y)
		: $self->get_iter_at_pointer()        ;
	return unless defined $iter;

	my ($link_tag) = grep {$_->{is_link}} $iter->get_tags;
	my $cursor = $link_tag ? 'link_cursor': 'text_cursor' ;

	if ($cursor ne 'link_cursor') {
		my $pixbuf = $iter->get_pixbuf;
		unless ($pixbuf) {
			$iter->backward_char;
			$pixbuf = $iter->get_pixbuf;
		}
		$cursor = 'arrow_cursor'
			if $pixbuf and $$pixbuf{image_data}{type} eq 'checkbox'
	}

	if ($cursor ne $self->{cursor}) {
		$self->{cursor} = $cursor;
		$self->get_window('text')->set_cursor($$self{$cursor});
	}
	
	return ($cursor eq 'link_cursor')
		? $self->get_link_at_iter($iter, $link_tag)
		: undef;
}

=item C<toggle_if_checkbox_at_iter(ITER, TYPE)>

Toggles a checkbox. If type if "x" it uses the "x checked" state, else just normale "v" check.

=cut

sub toggle_if_checkbox_at_iter {
	my ($self, $iter, $type) = @_;
	$type = lc $type || 'v';
	my $pixbuf = $iter->get_pixbuf;
	unless ($pixbuf and $$pixbuf{image_data}{type} eq 'checkbox') {
		$iter->backward_char;
		$pixbuf = $iter->get_pixbuf;
	}
	return 0 unless $pixbuf and $$pixbuf{image_data}{type} eq 'checkbox';
	my $state = $$pixbuf{image_data}{state};
	$state = ($state == 0 and $type eq 'v') ? 1 :
	         ($state == 0 and $type eq 'x') ? 2 :
	         ($state == 2 and $type eq 'v') ? 1 :
	         ($state == 1 and $type eq 'x') ? 2 : 0 ;
	my $buffer = $self->get_buffer;
	my $insert = $buffer->get_insert;
	my $mark = $buffer->create_mark(
		'toggle-checkbox-orig-insert',
		$buffer->get_iter_at_mark($insert),
		1 );
	_toggle_checkbox($buffer, $iter, $state);
	$self->_smart_checkbox_toggle($state) if $$self{use_recurscheck};
	$buffer->place_cursor( $buffer->get_iter_at_mark($mark) );
	$buffer->delete_mark($mark);
	return 1;
}

sub _toggle_checkbox {
	my ($buffer, $iter, $state) = @_;
	my $pixbuf = $iter->get_pixbuf;
	return $iter unless 
		$pixbuf and $$pixbuf{image_data}{type} eq 'checkbox';
	my $offset = $iter->get_offset;
	my $end = $iter->copy;
	$end->forward_char;
	$buffer->delete($iter, $end);
	$buffer->insert_blocks($iter, ['checkbox', {state => $state}]);
	return $buffer->get_iter_at_offset($offset);
}

sub _smart_checkbox_toggle {
	my ($self, $state) = @_;
	my $buffer = $self->get_buffer;
	my $iter = $buffer->get_iter_at_mark( $buffer->get_insert );

	## Check child items
	my $offset = $iter->get_offset;
	$self->_check_sublist_items($buffer, $iter, $state, 'UPDATE');
	$iter = $buffer->get_iter_at_offset($offset);

	while (1) { # loop through all levels in chcekbox list
		## Find parent
		my $startline = $iter->get_line;
		my $line = _get_line($buffer, $iter);
		$line =~ /(\s*)/;
		my $prefix = $1;
		while ($line =~ /^($prefix\s*\S|\s*$)/) {
			# match linkes with same indent or only whitespace
			$iter->backward_line or last;
			$line = _get_line($buffer, $iter);
		}
		# Break loop if no parent found
		return if $iter->get_line == $startline;
		return unless $line =~ /^\s*\x{FFFC}/; # parent is in fact a checkbox

		## Check child items for parent - no update
		$offset = $iter->get_offset;
		my $ok = $self->_check_sublist_items($buffer, $iter, $state, undef);
		$iter = $buffer->get_iter_at_offset($offset);

		## Check parent item in sync with children
		$state = 0 if not $ok;
		$line = _get_line($buffer, $iter);
		$line =~ /^(\s*)/;
		$iter->forward_chars(length $1);
		$iter = _toggle_checkbox($buffer, $iter, $state);
	}
}

sub _check_sublist_items {
	my ($self, $buffer, $iter, $state, $update) = @_;
	my $line = _get_line($buffer, $iter);
	$line =~ /(\s*)/;
	my $prefix = $1;
	$iter->forward_line or return 0; # false at end of buffer
	$line = _get_line($buffer, $iter);
	my $done = 0; # did we find any items or not
	while ($line =~ /^($prefix\s+\S|\s*$)/) {
		my $level = length $1;
		if ($line =~ /^(\s*)\x{FFFC}/) {
			$iter->forward_chars(length $1);
			if ($update) {
				$iter = _toggle_checkbox($buffer, $iter, $state);
			}
			else {
				my $pixbuf = $iter->get_pixbuf;
				return 0 unless $pixbuf
					and $$pixbuf{image_data}{type} eq 'checkbox'
					and $$pixbuf{image_data}{state} == $state;
				# check state or return 0
			}
			$done = 1;
		}
		$iter->forward_line or return $done;
		$line = _get_line($buffer, $iter);
	}
	return $done;
}

sub _get_line {
	# FIXME belongs in TextBuffer
	my ($buffer, $iter) = @_;
	my $start = $buffer->get_iter_at_line($iter->get_line);
	return '' if $start->ends_line; # empty line
	my $end = $start->copy;
	$end->forward_to_line_end;
	return $buffer->get_slice($start, $end, 1);
}

# ###### #
# Search #
# ###### #

=item C<search(STRING, DIRECTION, CASE, WORD)>

Searches for STRING in the buffer and selects the next occurence it finds.
The search is case-insensitive and TEXT can not include line breaks.
The search wraps around when nothing is found before the end/begin
of the buffer.

DIRECTION can be 1, -1 for forward and backward search.
If DIRECTION is 0 it will match forward including the current cursor. Try:

	$entry->signal_connect( changed =>
		sub { $htext->search( $entry->get_text, 0 ) }    );

to get an entry that searches while typing.

CASE is a boolean for case sensitive search.

WORD is a boolean for matching whole words only.

Returns boolean for success.

=cut

sub search {
	my ($self, $string, $direction, $case, $word) = @_;
	my $regex = join '\\s+', map quotemeta($_), split /\s+/, $string;
	$regex = '\\b'.$regex.'\\b' if $word;
	$regex = '(?i)'.$regex unless $case;

	my $buffer = $self->get_buffer;
	my $iter = $buffer->get_iter_at_mark( $buffer->get_insert );
	if    ($direction == 1 ) { $iter->forward_char  }
	elsif ($direction == -1) { $iter->backward_char }
	my $offset = $iter->get_line_offset;
	my $line = $iter->get_line;
	my $last = $buffer->get_line_count - 1;

	my $range;
	if (! length $string) {} # do nothing
	elsif ($direction != -1) { # forward
		$range =  _search_lines($buffer, qr/^(.{$offset,}?)($regex)/, $line)
		       || _search_lines($buffer, qr/^(.*?)($regex)/, $line+1 .. $last, 0 .. $line-1)
		       || _search_lines($buffer, qr/^(.{0,$offset}?)($regex)/, $line) ;
	}
	else { # backward
		$range =  _search_lines($buffer, qr/^(.{0,$offset})($regex)/, $line)
		       || _search_lines($buffer, qr/^(.*)($regex)/, reverse $line+1 .. $last, 0 .. $line-1)
		       || _search_lines($buffer, qr/^(.{$offset,})($regex)/, $line) ;
	}
	
	my $succes = defined $range;
	if ($succes) { $buffer->select_range(@$range) }
	else { # unset selection
		$buffer->move_mark(
			$buffer->get_selection_bound,
			$buffer->get_iter_at_mark( $buffer->get_insert ) );
	}
	
	$self->scroll_mark_onscreen( $buffer->get_insert );
	return $succes;
}

sub _search_lines {
	my ($buffer, $regex, @lines) = @_;
	for (@lines) {
		my $begin = $buffer->get_iter_at_line($_);
		next if $begin->ends_line;
		my $end = $begin->copy;
		$end->forward_to_line_end;
		my $line = $begin->get_slice($end);
		$line =~ $regex;
		#warn "Matched $regex against \"$line\"\n";
		#warn "\$1: >>$1<< \$2: >>$2<<\n";
		if (defined $2) {
			$begin->forward_chars(length $1);
			$end = $begin->copy;
			$end->forward_chars(length $2);
			return [$begin, $end];
		}
	}
	return undef;
}

=item C<replace(STRING)>

Replace the current selection with STRING.
To be used in combination with C<search()> to create a
"Find and Replace" function.

=cut

sub replace {
	my ($self, $string) = @_;
	my $buffer = $self->get_buffer;
	my ($start, $end) = $buffer->get_selection_bounds;
	return if !$end or $start == $end;

	my $offset = $start->get_offset;
	$buffer->delete($start, $end);
	$start = $buffer->get_iter_at_offset($offset);
	$buffer->insert($start, $string);
}

=item C<replace_all(OLD, NEW)>

Loop through the document once and replace all matches for OLD with NEW.

=cut

sub replace_all {
	my ($self, $old, $new) = @_;
	my $buffer = $self->get_buffer;

	my $insert = $buffer->get_insert;
	my $iter = $buffer->get_iter_at_mark( $insert );
	my $mark = $buffer->create_mark('replace_all_mark', $iter, 1);
	my $i = 0;
	my $wrap = 0;
	while ( $self->search($old, $i++) ) {
		my ($match) = $buffer->get_selection_bounds;
		$wrap ||= ($match->compare($iter) == -1);
		if ($wrap) {
			my $end = $buffer->get_iter_at_mark($mark);
			last if $match->compare($end) >= 0;
		}
		$self->replace($new);
		$iter = $buffer->get_iter_at_mark( $insert );
	}
	$buffer->delete_mark($mark);
	return $i;
}

# ###### #
# Events #
# ###### #

sub on_motion_notify_event {
	# Update the cursor image if the pointer moved.
	
	my ($self, $event) = @_;

	my ($x, $y) = $event->get_coords;
	   ($x, $y) = $self->window_to_buffer_coords('widget', $x, $y);

	my $cursor  = $self->{cursor};
	my $link_data = $self->set_cursor_if_appropriate($x, $y);

	if ($cursor eq 'link_cursor') { # was hovering
		if ($self->{cursor} eq 'link_cursor') { # still hovering
			if ("$link_data" ne $self->{_last_link}) {
				$self->signal_emit('link_leave');
				$self->signal_emit('link_enter', $link_data);
				$self->{_last_link} = "$link_data";
			}
		}
		else { $self->signal_emit('link_leave') } # but not anymore
	}
	else { # was not hovering
		if ($self->{cursor} eq 'link_cursor') { # but hovering now
			$self->signal_emit('link_enter', $link_data);
			$self->{_last_link} = "$link_data";
		}
	}
		
	return 0;
}

sub on_visibility_notify_event {
	# Update the cursor image if the window becomes visible
	# (e.g. when a window covering it got iconified).
	
	my $self = shift;
	$self->set_cursor_if_appropriate();
	return 0;
}

my ($k_return, $k_kp_enter) = @Gtk2::Gdk::Keysyms{qw/Return KP_Enter/};

sub on_key_press_event {
	my ($self, $event) = @_;

	my $val = $event->keyval();
	if ($val == $k_return or $val == $k_kp_enter) { # Enter
		my $buffer = $self->get_buffer;
		my $iter = $buffer->get_iter_at_mark($buffer->get_insert());
		my $alt = $event->state >= 'mod1-mask'; # <alt><enter>
		if ($self->{follow_on_enter} or $alt ) {
			# follow link for <enter> *inside* link or
			# <alt><enter> anywhere
			my ($l) = grep {$_->{is_link}} $iter->get_tags;
			return 0 unless defined $l;
			my $link_data = $self->get_link_at_iter($iter, $l);
			return 0 unless $alt or ! $iter->toggles_tag($l);
			$self->signal_emit('link_clicked', $link_data);
			return 1;
		}
		else {
			# ignore <enter> inside link
			my ($l) = grep {$_->{is_link}} $iter->get_tags;
			return 1 if defined($l) and ! $iter->toggles_tag($l);
		}
	}
#	else { printf "key %x pressed\n", $val } # perldoc -m Gtk2::Gdk::Keysyms
	
	return 0;
}

sub on_button_release_event {
	my ($self, $event) = @_;
	return 0 if $event->type ne 'button-release';

	# return if user made a selection
	my ($start, $end) = $self->get_buffer->get_selection_bounds;
	return 0 if $start && $end and $start->get_offset != $end->get_offset;
	
	my $iter = $self->get_iter_at_pointer;
	return 0 unless defined $iter;
	if ($event->button == 1) { # left mouse button
		$self->click_if_link_at_iter($iter)
			or $self->toggle_if_checkbox_at_iter($iter, 'v');
	}
	elsif ($event->button == 3) { # right mouse button
		$self->toggle_if_checkbox_at_iter($iter, 'x');
	}
	
	return 0;
}

# The following three methods are needed because TextBuffer doesn't have
# signals for these things and we want to make sure the overloaded methods
# in HyperTextBuffer get called.

sub on_copy_clipboard {
	my $view = shift;
	my $buffer = $view->get_buffer;
	my $clipboard = $view->get_clipboard(
		Gtk2::Gdk::Atom->new('CLIPBOARD') );
	$buffer->copy_clipboard($clipboard);
	$view->scroll_mark_onscreen( $buffer->get_insert );
}

sub on_cut_clipboard {
	my $view = shift;
	my $buffer = $view->get_buffer;
	my $clipboard = $view->get_clipboard(
		Gtk2::Gdk::Atom->new('CLIPBOARD') );
	$buffer->cut_clipboard($clipboard);
	$view->scroll_mark_onscreen( $buffer->get_insert );
}

sub on_paste_clipboard {
	my $view = shift;
	return unless $view->get_editable;
	my $buffer = $view->get_buffer;
	my $clipboard = $view->get_clipboard(
		Gtk2::Gdk::Atom->new('CLIPBOARD') );
	$buffer->paste_clipboard($clipboard, undef, $view->get_editable);
	$view->scroll_mark_onscreen( $buffer->get_insert );
}

1;

__END__

=back

=head1 SIGNALS

=over 4

=item link_clicked(DATA)

Emitted when the user clicks on a link or presses
"Enter" while on a link.

=item link_enter(DATA)

Emitted when the mouse cursor enters the region of a link.

=item link_leave( )

Emitted when the mouse cursor leaves the region of a link.

=back

=head1 AUTHOR

Jaap Karssenberg || Pardus [Larus] <pardus@cpan.org>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut

