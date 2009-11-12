package Gtk2::Ex::HyperTextBuffer;

our $VERSION = '0.28';

use strict;
use Gtk2;
use Gtk2::Pango; # pango constants
use File::Spec;  # for locating images
use Glib::Object::Subclass
	Gtk2::TextBuffer::,
	signals => {
		# new signals
		edit_mode_changed => { },
	} ;

=head1 NAME

HyperTextBuffer - A TextBuffer for the HyperTextView widget

=head1 DESCRIPTION

This module is a subclass of L<Gtk2::TextBuffer> intended for use with 
L<Gtk2::Ex::HyperTextView>. It has a high level interface that uses parse trees
instead of plain text. It also keeps an undo-/redo-stack.

=head1 HIERARCHY

  Glib::Object
  +----Gtk2::TextBuffer
       +----Gtk2::Ex::HyperTextBuffer


=cut

# TODO make tag styles configable
our %TAGS = (
	bold      => [weight => PANGO_WEIGHT_BOLD],
	italic    => [style => 'italic'],
	underline => [underline => 'single'],
	strike    => [strikethrough => 'true', foreground => 'grey'],
	verbatim  => [family => 'monospace'], # wrap_mode => 'none'], # Bug withwrap_mode !?
	Verbatim  => [family => 'monospace', wrap_mode => 'none', 'left-margin' => 40, indent => 0],
	link      => [foreground => 'blue', underline => 'single'],
	head1     => [weight => PANGO_WEIGHT_BOLD, scale => 1.15**4 ],
	head2     => [weight => PANGO_WEIGHT_BOLD, scale => 1.15**3 ],
	head3     => [weight => PANGO_WEIGHT_BOLD, scale => 1.15**2 ],
	head4     => [weight => PANGO_WEIGHT_ULTRABOLD, scale => 1.15 ],
	head5     => [weight => PANGO_WEIGHT_BOLD, scale => 1.15, style  => 'italic'],
);

our @_tags = grep {$_ ne 'link'} keys %TAGS;

our ($_clipboard, $_primary);

our @_targets = (
	{ target => 'STRING'        },
	{ target => 'TEXT'          },
	{ target => 'COMPOUND_TEXT' },
	{ target => 'UTF8_STRING'   },
	{ target => 'text/plain'    },
	{ target => 'ZIM_TREE'      },
);

=head1 METHODS

=over 4

=item C<< new(PROPERTY => VALUE, ..) >>

Simple constructor.

=cut

sub INIT_INSTANCE {
	my $self = shift;
	$self->{edit_mode_tags} = [];
	$self->{_edit_mode_string} = '';
	$self->{undo} = [];
	$self->{redo} = [];
	$self->signal_connect(mark_set => sub {
			my ($self, $iter, $mark) = @_;
			my $name = $mark->get_name;
			$self->set_edit_mode_from_cursor()
				if defined($name) and $name eq 'insert';
		} );
	$self->signal_connect_after(insert_text => \&on_insert);
	$self->signal_connect(delete_range => \&on_delete_range);
	$self->signal_connect(apply_tag => \&on_apply_tag);
	$self->signal_connect(remove_tag => \&on_remove_tag);
	$self->signal_connect(begin_user_action => sub {$$self{_ua} = 1});
	$self->signal_connect(end_user_action => sub {$$self{_ua} = 0});
}

=item C<clear()>

Deletes all buffer contents.

Be aware that this module sometimes stores a reference to the buffer in a
global variable in order to get copy-pasting with markup work. This means
you could save a lot of memory when you always clear the object when you are
done with it.

=cut

sub clear {
	my $self = shift;
	$self->{edit_mode_tags} = [];
	$self->delete( $self->get_bounds );
}

=item C<create_default_tags()>

Initialise pre-defined text tags. See TAGS for a listing of these tags.

=cut

sub create_default_tags {
	$_[0]->create_tag($_ => @{$TAGS{$_}}) for @_tags;
}

=item C<set_parse_tree(TREE)>

Load the buffer with contents from a parse tree. The tree format is based on
the format as used by L<Pod::Simple> but it uses more verbose element names.

For example:

	['Page', {},
		['head1', {}, 'Test page'],
		"\n\n",
		"This is a test page showing some syntax:\n\n",
		['bold', {}, 'Bold text'], "\n",
		['italic', {}, 'Italic text'], "\n",
		['bold', {},
			['italic', {}, 'Bold and Italic']
		], "\n",
	]

This function creates a new unmodified buffer.
This action is not un-doable.

=cut

sub set_parse_tree {
	my ($self, $tree) = @_;
	#use Data::Dumper; print "HyperTextBuffer got tree: ", Dumper $tree;
	$self->clear;
	$self->{_undo_lock} = 1;
	$self->insert_blocks_at_cursor($tree);
	$self->{_undo_lock} = 0;
	$self->set_modified(0);
}

=item C<insert_blocks(ITER, BLOCK, ...)>

Insert one or more partial parse trees in the buffer at ITER.
The blocks will also be added to the undo stack.

=cut

sub insert_blocks {
	my $self = shift;
	my $iter = shift;
	my $insert = $self->get_insert;
	my $mark = $self->create_mark(
		'insert-blocks-orig-insert',
		$self->get_iter_at_mark($insert),
		1 );
	$self->place_cursor($iter);
	$self->insert_blocks_at_cursor(@_);
	$self->place_cursor( $self->get_iter_at_mark($mark) );
	$self->delete_mark($mark);
}

=item C<insert_blocks_at_cursor(BLOCK, ...)>

Like C<insert_blocks()> but inserts at current cursor position.

=cut

sub insert_blocks_at_cursor {
	# Make sure not to modify content of the reference !
	# TODO: check default editable / region editable
	my $self = shift;
	$self->signal_handlers_block_by_func($_)
		for \&on_insert, \&on_apply_tag, \&on_remove_tag;
	my $begin = $self->get_iter_at_mark( $self->get_insert )->get_offset;
	$self->_insert_blocks(@_);
	my $end = $self->get_iter_at_mark( $self->get_insert )->get_offset;
	$self->_record_step('I', $begin, $end, @_);
	$self->signal_handlers_unblock_by_func($_)
		for \&on_insert, \&on_apply_tag, \&on_remove_tag;
	return 1;
}

sub _insert_blocks {
	my ($self, @blocks) = @_;

	for (@blocks) {
		unless (ref $_) {
			my $text = $_;
			$self->insert_at_cursor($text);
			if (@{$self->{edit_mode_tags}}) {
				my $end = $self->get_iter_at_mark(
					$self->get_insert );
				my $start = $end->copy;
				$start->backward_chars(length $text);
				$self->remove_all_tags($start, $end);
				$self->apply_tag($_, $start, $end)
					for @{$self->{edit_mode_tags}};
			}
		}
		else {
			my ($type, $meta) = @$_[0, 1];
			my $tag;
			if ($type eq 'image') {
				$self->insert_image_from_file(%$meta);
				next;
			}
			elsif ($type eq 'checkbox') {
				my $icon = 
					($$meta{state} == 1) ? 'checked-box'  :
					($$meta{state} == 2) ? 'xchecked-box' : 'unchecked-box' ;
				$$meta{icon} = $icon;
				$$meta{type} = 'checkbox';
				$self->insert_image_from_file(%$meta);
				next;
			}
			elsif ($type eq 'link') {
				my $bit = (@$_ == 3 and $$_[2] eq $$meta{to});
				$tag = $self->create_link_tag($bit ? undef : $$meta{to});
			}
			else { $tag = $self->get_tag_table->lookup($type) }

			if ($tag) {
				push @{$self->{edit_mode_tags}}, $tag;
				#@{$self->{edit_mode_tags}} = ($tag);
				$self->_insert_blocks(@$_[2 .. $#$_]); # recurs
				pop @{$self->{edit_mode_tags}};
				#@{$self->{edit_mode_tags}} = ();
			}
			elsif ($type eq 'Page' or $type eq 'Para') {
				my $iv = $$meta{indent};
				if ($iv) {
					$self->{indent}=$iv;
#warn "indent: $iv  / $type / " . @$_[2];
					my $itag = $self->create_tag(
						undef, ('left-margin' => 12 * $iv )
					);
					push @{$self->{edit_mode_tags}}, $itag;
				}
				$self->_insert_blocks(@$_[2 .. $#$_]); # recurs
				if ($iv) {
					pop @{$self->{edit_mode_tags}};
				}
			}
			elsif ($type eq 'bullet') {
				my $itag = $self->create_tag(
					undef, (
						'indent' => -10,
						'left-margin' => $self->{indent} * 10 - 10
					)
				);
				push @{$self->{edit_mode_tags}}, $itag;
				$self->_insert_blocks(@$_[2 .. $#$_]); # recurs
				pop @{$self->{edit_mode_tags}};
			}
			else { die "Unknown tag in parse tree: $type" }

			my $lines = ($type =~ /^head/) ? 1 : 0;
			$lines += $$meta{empty_lines} if $$meta{empty_lines}; 
			$self->insert_at_cursor("\n"x$lines) if $lines;
		}
	}
}

=item C<insert_image_from_file(%PARAM)>

Insert an image in the buffer at the cursor. The params should at least contain
'file' and optionally 'src', 'width' and 'height'.

The 'file' param is used as source for the image. If both 'width' and 'height'
are set the image is resized to these dimensions. If one of both is zero or
undefined the image is scaled with fixed ratio. All other params are attached
to the image as data field.

Use C<insert_blocks()> if you want this action to be un-doable. 

=cut

sub insert_image_from_file {
	my ($self, %param) = @_;
	die "BUG: image without 'file' attribute"
		unless length $param{file} or length $param{icon};

	my $pixbuf = undef;
	if ($param{file}) {
		my ($w, $h) = @param{'width', 'height'};
		eval {
			$pixbuf = ($w || $h)
				? Gtk2::Gdk::Pixbuf->new_from_file_at_size(
					$param{file}, $w || -1, $h || -1 )
				: Gtk2::Gdk::Pixbuf->new_from_file(
					$param{file} ) ;
		} if -f $param{file} and -r _ ;
		$pixbuf ||= Gtk2::Image->new->render_icon(
				'gtk-missing-image', 'dialog' )->copy;
		die "Could not insert image: $param{file}\n" unless $pixbuf;
	}
	elsif ($param{icon}) {
		$pixbuf ||= Gtk2::Image->new->render_icon(
				$param{icon}, 'menu' )->copy;
		die "Could not insert icon: $param{icon}\n" unless $pixbuf;
	}
	else { die 'BUG' }
	
	$pixbuf->{image_data} = \%param;
	my $iter ||= $self->get_iter_at_mark( $self->get_insert );

	#my $mark = $self->create_mark(undef, $iter, 0);
	#$mark->set_visible(1);
	
	$self->insert_pixbuf($iter, $pixbuf);

	return $pixbuf;
}

=item C<get_parse_tree()>

Returns a parse tree based on the buffer contents.

=cut

sub get_parse_tree {
	# TODO Nesting order of tags starting on the same
	# position is arbitrary - add logic to sort this out
	# TODO: restructure the tree to order it in paragraphs
	my ($self, $start, $end) = @_;
	($start, $end) = $self->get_bounds unless defined $start;

	# First we build a parse tree based on the tags we find
	my $root = [];
	my @stack = ($root);
	my $iter = $start->copy;
	for ($iter->get_tags) {
		my $link_data = Gtk2::Ex::HyperTextView->get_link_at_iter($iter, $_)
			if $_->{is_link}; # FIXME quick hack here
		my $tag = $_->{is_link}
			? [ 'link', {to => $link_data}   ]
			: [ $_->get_property('name'), {} ] ;
		next if $$tag[0] =~ /gtkspell/;
		push @{$stack[-1]}, $tag;
		push @stack, $tag;
	}
	my $previous = $iter->copy;
	while ($iter->forward_to_tag_toggle(undef)) {
		last if $iter->compare($end) != -1;
		
		EXTRACT_TAGS:
		my $slice = $previous->get_slice($iter);
		if ($slice =~ /\x{fffc}/) {
			my $image = $previous->copy;
			while ($slice =~ s/^(.*?)\x{fffc}//s) { # Embeded image
				push @{$stack[-1]}, $1 if length $1;
				$image->forward_chars(length $1);
				my $pixbuf = $image->get_pixbuf;
				if ($pixbuf) {
					my $meta = $pixbuf->{image_data};
					my $node = ($$meta{type} and $$meta{type} eq 'checkbox')
						? 'checkbox' : 'image' ;
					push @{$stack[-1]}, [$node, $meta];
				}
				$image->forward_char;
			}
		}
		push @{$stack[-1]}, $slice if length $slice;
		$previous = $iter->copy;
		for ($iter->get_toggled_tags(0)) { # closed tags
			# warning: no consistency check is being done here
			#          because order of closing tags is unsorted
			next if !$_->{is_link}
				and $_->get_property('name') =~ /gtkspell/;
			pop @stack;
		}
		for ($iter->get_toggled_tags(1)) { # opened tags
			my $link_data = Gtk2::Ex::HyperTextView->get_link_at_iter($iter, $_)
				if $_->{is_link}; # FIXME quick hack here
			my $tag = $_->{is_link}
				? [ 'link', {to => $link_data}   ]
				: [ $_->get_property('name'), {} ] ;
			next if $$tag[0] =~ /gtkspell/;
			push @{$stack[-1]}, $tag;
			push @stack, $tag;
		}
	}
	unless ($previous->equal($end)) { # last part
		$iter = $end->copy;
		goto EXTRACT_TAGS;
	}

	# Check lines around headings - FIXME very ugly implementation
	# Also add sanity check to merge blocks of 'verbatim' to 'Verbatim'
	for (0 .. $#$root) {
		next unless ref $$root[$_] and $$root[$_][0] =~ /^head/;
		$$root[$_][-1] =~ s/(\n*)$//;
		my $lines = length $1;

		# check empty lines at start next para
		if (ref $$root[$_+1]) { # unwrap tree
			my $next = $$root[$_+1];
			next if $$next[0] =~ /^head/;
			while (ref $$next[2]) { $next = $$next[2] }
			$$next[2] =~ s/^(\n*)//;
			$lines += length $1;
			splice @$next, 2, 1 unless length $$next[2];
		}
		elsif (defined $$root[$_+1]) {
			$$root[$_+1] =~ s/^(\n*)//;
			$lines += length $1;
			$$root[$_+1] = undef unless length $$root[$_+1];
		}
		
		# Set end of line on previous para
		if ($_ > 0) {
			if (ref $$root[$_-1]) { # unwrap tree
				my $prev = $$root[$_-1];
				next if $$prev[0]  =~ /^head/;
				while (ref $$prev[-1]) { $prev = $$prev[-1] }
				$$prev[-1] =~ s/\n?$/\n/;
			}
			elsif (defined $$root[$_-1]) {
				$$root[$_-1] =~ s/\n?$/\n/;
			}
		}
		
		$$root[$_][1]{empty_lines} = $lines - 1 if $lines > 1;
	}

	# Filter out empty tags
	@$root = grep {
		defined($_) and
		(ref($_) and ($$_[0] ne 'image') and ($$_[0] ne 'checkbox')) 
			? (@$_ > 2)
			: length($_)
	} @$root;
		
	unshift @$root, 'Page', {};
	#use Data::Dumper; warn "get_parse_tree: ", Dumper $root;
	return $root;
}

=item C<create_link_tag(LINK_DATA)>

Returns an anonymous L<Gtk2::TextIter> that holds LINK_DATA.

Every link tag should only be applied to one text region.

=cut

sub create_link_tag {
	my($self, $data) = @_;
	
	my $tag = $self->create_tag(undef, @{$TAGS{link}});
	$tag->{is_link}   = 1;
	$tag->{link_data} = $data;

	return $tag;
}

=item C<auto_selection(TAG, ITER)>

Returns start and end iterators for the current selection.
If there is no selection in the buffer TAG and ITER are used to
automaticly select a range if possible.
ITER is optional and defaults to the cursor.

=cut

sub auto_selection {
	my ($self, $tag, $iter) = @_;
	my ($start, $end) = $self->get_selection_bounds;
	#warn "selection: $start, $end tag: $tag\n";
	if (!$end or $start == $end) { # autoselect word if defined tag
		if ($tag eq 'link') {
			($start, $end) = $self->select_link($iter);
			($start, $end) = $self->select_word($iter)
				if !$end or $start == $end;
		}
		elsif ($tag =~ /^head/) {
			($start, $end) = $self->select_line($iter);
		}
		elsif ($tag and $tag !~ /^[A-Z]/) {
			($start, $end) = $self->select_word($iter);
		}
		#warn "   => $start, $end\n";
		return undef if !$end or $start == $end;
	}
	return ($start, $end);
}

=item C<select_word(ITER)>

Selects the current word if ITER is inside a word.
Cursor is used when ITER is undefined.
Returns Gtk2::TextIter for start and end or undef.

=cut

sub select_word {
	my ($self, $iter) = @_;
	$iter ||= $self->get_iter_at_mark( $self->get_insert );
	#warn "select-word: ", $iter->inside_word, "\n";
	return unless $iter->inside_word
		or $iter->starts_word or $iter->ends_word;
	my $begin = $iter->copy;
	$begin->backward_word_start unless $begin->starts_word;
	$iter->forward_word_end unless $iter->ends_word;
	$self->select_range($begin, $iter);
	return ($begin, $iter);
}

=item C<select_line(ITER)>

Selects the line that contains ITER.
Cursor is used when ITER is undefined.
Returns Gtk2::TextIter for start and end or undef.

=cut

sub select_line {
	my ($self, $iter) = @_;
	$iter ||= $self->get_iter_at_mark( $self->get_insert );
	my $begin = $iter->copy;
	$begin = $self->get_iter_at_line( $begin->get_line )
		unless $begin->starts_line;
	while (! $iter->ends_line) { $iter->forward_char }
	return unless $iter->compare($begin) == 1;
	$self->select_range($begin, $iter);
	return ($begin, $iter);
}

=item C<select_tag(ITER, TAG)>

Selects TAG if ITER has TAG.
Cursor is used when ITER is undefined.
Tag can be either a Gtk2::TextTag or a tag name.
Returns Gtk2::TextIter for start and end or undef.

=cut

sub select_tag {
	my ($self, $iter, $tag) = @_;
	#warn "select_tag: $tag\n";
	$tag = $self->get_tag_table->lookup($tag) unless ref $tag;
	$iter ||= $self->get_iter_at_mark( $self->get_insert );
	return unless $iter->has_tag($tag) or $iter->toggles_tag($tag);
	my $begin = $iter->copy;
	$begin->backward_to_tag_toggle($tag) unless $begin->begins_tag($tag);
	$iter->forward_to_tag_toggle($tag) unless $begin->ends_tag($tag);
	$self->select_range($begin, $iter);
	return ($begin, $iter);
}

=item C<select_link(ITER)>

Selects link if ITER is on a link.
Cursor is used when ITER is undefined.
Returns Gtk2::TextIter for start and end or undef.

=cut

sub select_link {
	#warn "select_link\n";
	my ($self, $iter) = @_;
	$iter ||= $self->get_iter_at_mark( $self->get_insert );
	for ($iter->get_tags) {
		next unless $_->{is_link};
		return $self->select_tag($iter, $_);
	}
}

=item C<replace_selection(TEXT)>

Replace any selected text with TEXT.
Returns iterators for the start and end of the newly inserted selection.

=cut

sub replace_selection {
	my ($self, $text) = @_;
	my ($start, $end) = $self->get_selection_bounds;
	return if !$end or $start == $end;

	my $_start = $start->get_offset;
	my $_end   = $start->get_offset + length $text;

	$self->delete($start, $end);
	$self->insert($start, $text);

	($start, $end) = map $self->get_iter_at_offset($_), ($_start, $_end);
	$self->select_range($start, $end);

	return $start, $end;
}

=item C<set_edit_mode_tags(TAG, ..)>

Set the current edit mode to a certain list of tags. This means that all
text you insert will get these tags applied.

=cut

sub set_edit_mode_tags {
	my $self = shift;
	my $table = $self->get_tag_table;
	$self->{edit_mode_tags} =
		[ map { ref($_) ? $_ : $table->lookup($_) } @_ ];
	$$self{_edit_mode_string} = "@{$self->{edit_mode_tags}}";
	$self->signal_emit('edit_mode_changed');
}

=item C<set_edit_mode_from_cursor()>

Like C<set_edit_mode_tags()> but copies tags from the cursor position.
This function is called automaticly after moving the cursor.

=cut

sub set_edit_mode_from_cursor {
	my $self = shift;
	my $iter = $self->get_iter_at_mark( $self->get_insert );
	$self->{edit_mode_tags} = [$self->_get_open_tags($iter)];
	my $string = "@{$self->{edit_mode_tags}}";
	return if $string eq $$self{_edit_mode_string};

	$$self{_edit_mode_string} = $string;
	$self->signal_emit('edit_mode_changed');
	#warn join ' ', "Mode:", map(
	#	{$_->{is_link} ? 'link' : $_->get_property('name')}
	#	@{$self->{edit_mode_tags}}
	#), "\n";
}

sub _get_open_tags {
	# iter->get_tags has "left" gravity
	# this function has "right" gravity
	my ($self, $iter) = @_;
	my @tags = $iter->get_tags;
	for my $t ($iter->get_toggled_tags(1)) { # tags that are toggles on here
		@tags = grep {$_ ne $t} @tags;
	}
	push @tags, $iter->get_toggled_tags(0);
	@tags = grep {$_->get_property('name') !~ /gtkspell/} @tags;
	return @tags;
}

=item C<get_edit_mode_tags()>

Returns a list of tags that will be applied to newly entered text.

=cut

sub get_edit_mode_tags {
	$_[0]->set_edit_mode_from_cursor
		unless defined $_[0]->{edit_mode_tags};
	@{$_[0]->{edit_mode_tags}};
}

=item C<toggle_edit_mode_tag(TAG, BOOL)>

Toggles a tag for editing. If BOOL is undefined it just toggles, else it sets the tag to the value of BOOL.

=cut

sub toggle_edit_mode_tag {
	my ($self, $tag, $bool) = @_;
	$tag = $self->get_tag_table->lookup($tag) unless ref $tag;
	my @tags = grep {$_ ne $tag} @{$self->{edit_mode_tags}};
	push @tags, $tag
		if @tags == @{$self->{edit_mode_tags}} and $bool != 0;
	@{$self->{edit_mode_tags}} = @tags;
	$$self{_edit_mode_string} = "@{$self->{edit_mode_tags}}";
	$self->signal_emit('edit_mode_changed');
}

sub on_insert {
	my ($self, $end, $string) = @_;

	# length in argument list does not understand utf8
	my $start = $end->copy;
	$start->backward_chars(length $string);

	$self->_record_step('I', $start->get_offset, $end->get_offset, $string);
		# record this step _before_ triggering any steps from tags
	$self->remove_all_tags($start, $end);
	$self->apply_tag($_, $start, $end) for @{$self->{edit_mode_tags}};
}

sub on_delete_range {
	my ($self, $begin, $end) = @_;
	my $tree = $self->get_parse_tree($begin, $end);
	$self->_record_step('D', $begin->get_offset, $end->get_offset, $tree);
}

sub on_apply_tag {
	my ($self, $tag, $begin, $end) = @_;
	my $name = $tag->get_property('name') || '';
	return if $name =~ /^gtkspell/;
	$self->_record_step('A', $begin->get_offset, $end->get_offset, $tag);
}

sub on_remove_tag {
	my ($self, $tag, $begin, $end) = @_;
	my $name = $tag->get_property('name') || '';
	return if $name =~ /^gtkspell/;
	$self->_record_step('R', $begin->get_offset, $end->get_offset, $tag);
}

=item C<undo>

Undo one editing step.

=item C<redo>

Redo one editing step.

=cut

my %_reverse_step = qw/I D D I A R R A/; # two pairs of complementary actions

sub undo {
	my $self = shift;
	return 0 unless @{$self->{undo}};
	my $step = pop @{$self->{undo}};
	push @{$self->{redo}}, [@$step];
	$self->_do_step($step, 1);
	return 1;
}

sub redo {
	my $self = shift;
	return 0 unless @{$self->{redo}};
	my $step = pop @{$self->{redo}};
	push @{$self->{undo}}, [@$step];
	$self->_do_step($step, 0);
	return 1;
}

sub _record_step {
	my ($self, $step, $begin, $end, @data) = @_;
	#return unless $$self{_ua} and !$$self{_undo_lock};
	return if $$self{_undo_lock};
	#warn "# Record ($$self{_ua}): $step, $begin, $end, @data\n";
	$self->_fold_steps if @{$self->{redo}};
	push @{$self->{undo}}, [$step, $begin, $end, @data];
}

sub _fold_steps {
	# Triggered if you start editing after an undo
	# "folds" the undo sequence instead of throwing it away
	my $self = shift;
	my @steps = reverse @{$self->{redo}}; # reverse because we pop in undo()

	# redo the whole stack
	$self->{redo} = [];
	push @{$self->{undo}}, @steps;

	# add the "undo" action as undoable action
	@steps = reverse map [@$_], @steps; # copy, no ref, reverse again
	$$_[0] = $_reverse_step{$$_[0]} for @steps;
	push @{$self->{undo}}, [@steps]; # push whole group as single step
}

sub _do_step {
	# does one step or one group of steps
	my ($self, $ref, $reverse) = @_;
	my @steps = (ref($$ref[0]) ? @$ref : $ref);
	@steps = reverse @steps if $reverse;
	
	$self->{_undo_lock} = 1;
	for my $step (@steps) {
		my ($act, $begin, $end, @data) = @$step;
		$act = $_reverse_step{$act} if $reverse;
		#warn "Do: $act, $begin, $end, @data\n";
		$_ = $self->get_iter_at_offset($_) for $begin, $end;
		if ($act eq 'I') { # insert
			$self->place_cursor($begin);
			$self->insert_blocks_at_cursor(@data);
		}
		elsif ($act eq 'D') { # delete
			my $tree = $self->get_parse_tree($begin, $end);
			splice @$tree, 3, 0, $tree;
				# replace insert data with actual deleted data
				# these should be the same
			$self->delete($begin, $end);
			$self->place_cursor($end);
		}
		elsif ($act eq 'A') { # apply tag
			$self->apply_tag($data[0], $begin, $end);
		}
		elsif ($act eq 'R') { # remove tag
			$self->remove_tag($data[0], $begin, $end);
		}
		else { die "BUG: unknown step type: $act" }
	}
	$self->set_modified(1);
	$self->{_undo_lock} = 0;
}

=item C<copy_clipboard>

TODO

=cut

sub copy_clipboard {
	my $self = shift;
	$self->begin_user_action;
	$self->_cut_or_copy(shift, 0, 1, shift);
	$self->end_user_action;
}

=item C<cut_clipboard>

TODO

=cut

sub cut_clipboard {
	my $self = shift;
	$self->begin_user_action;
	$self->_cut_or_copy(shift, 1, 1, shift);
	$self->end_user_action;
}

sub _cut_or_copy {
	my ($self, $clipboard, $delete, $interactive, $editable) = @_;
	my ($start, $end) = $self->get_selection_bounds;
	
	# TODO check anchor
	
	return if !$start or $start->equal($end);

	my $tree = $self->get_parse_tree($start, $end);
	$tree->[1]{comment} = 'Copy-paste buffer';
	
	$clipboard->set_with_data(
		\&_clipboard_get, \&_clipboard_clear, $tree, @_targets)
		or return;

	#$interactive ? $self->delete_interactive($start, $end, $editable) :
	$self->delete($start, $end)
		if $delete ;
}

sub _clipboard_get { # clipboard callback
	my ($clipboard, $selection, $id, $tree) = @_;
	#print STDERR '_clipboard_get type: '.$selection->target->name."\n";
	
	if ($selection->target->name eq 'ZIM_TREE') {
		$_clipboard = $tree;
		#print STDERR "_clipboard_get set ref: $tree\n";
		$selection->set(
			Gtk2::Gdk::Atom->intern('ZIM_TREE', 0),
			8, "$tree" );
	}
	else { # text
		my $string = _dump_tree($tree);
		#print STDERR "_clipboard_get set_text >>$string<<\n";
		$selection->set_text($string);
	}
}

sub _clipboard_clear {
	my $tree = pop;
	$_clipboard = undef if "$tree" eq "$_clipboard";
	@$tree = ();
}

sub _dump_tree { # TODO add "\n" around headings and support lists
	# Make sure not to modify content of the reference !
	my $tree = shift;
	my $string = '';
	$string .= ref($_) ? _dump_tree($_) : $_
		for @$tree[2 .. $#$tree];
	$string .= "\n" if $$tree[0] =~ /^head/;
	$string .= "\n"x$$tree[1]{empty_lines}
		if $$tree[1]{empty_lines};
	return $string;
}

=item C<paste_clipboard>

TODO

=cut

sub paste_clipboard {
	my ($self, $clipboard, $insert, $editable) = @_;
	
	# check selections
	my $replace = 0;
	my ($start, $end) = $self->get_selection_bounds;
	if (defined $start) {
		my $iter = $insert || $self->get_iter_at_mark( $self->get_insert );
		if ($iter->in_range($start, $end) or $iter->equal($end)) {
			$insert = $iter;
			$replace = 1;
		}
	}	
	
	# check insert point
	$self->create_mark('gtk_paste_point_override', $insert, 0)
		if defined $insert ;
	
	my $paste_data = {
		buffer      => $self,
		interactive => 1,
		editable    => $editable,
		replace     => $replace,
	};
	
	my %targets = map {($_->name => $_)} $clipboard->wait_for_targets();
	#warn "Available targets: ".join(' ', keys %targets)."\n";
	my ($atom) = grep defined($_),
		@targets{qw#ZIM_TREE text/x-zim-page-list text/uri-list#};
	if ($atom) {
		$clipboard->request_contents(
			$atom, \&_clipboard_paste, $paste_data);
	}
	else {
		$clipboard->request_text(
			\&_clipboard_paste, $paste_data);
	}
}

sub _clipboard_paste { # callback which does the actual paste
	my ($clipboard, $data, $paste_data) = @_;
	my $self = $paste_data->{buffer};
	my $type = ref($data) ? $data->target->name : 'text/plain' ;
	my $string = ref($data) ? $data->data : $data;

	return unless length $string;
	if ($type eq 'ZIM_TREE' and "$string" ne "$_clipboard") {
		# not same process - fall back
		$clipboard->request_text(
			\&_clipboard_paste, $paste_data);
		return;
	}
	#warn "pasting: $type\n$string\n...\n";

	$self->begin_user_action if $paste_data->{interactive};
	
	# check selection
	$self->delete_selection(@{$paste_data}{'interactive','editable'})
		if $paste_data->{replace};
	
	# check gtk_paste_point_override
	my $iter;
	my $mark = $self->get_mark('gtk_paste_point_override');
	if ($mark) {
		$iter = $self->get_iter_at_mark( $mark );
		$self->delete_mark($mark);
	}
	
	# actual insert
	my $tree;
	if ($type eq 'ZIM_TREE') { $tree = $_clipboard }
	elsif ($type eq 'text/plain') {
		# FIXME url parsing copy-pasted from Zim/Formats/Wiki.pm
		my $i = 0;
		my @tree = ('Page', {},
			map   { ($i++ % 2) ? _parse_link($_) : $_ }
			split m#(
				\b\w[\w\+\-\.]+://  \S*\[\S+\](?:\S+[\w\/])? |
				\b\w[\w\+\-\.]+://  \S+[\w\/]                |
				\bmailto:\S+\@      \S*\[\S+\](?:\S+[\w/])?  |
				\bmailto:\S+\@      \S+[\w/]                 |
				\b\S+\@\S+\.\w+\b
			)#x, $string);
			# The host name in an uri can be "[hex:hex:..]" for ipv6
			# but we do not want to match "[http://foo.org]"
			# See rfc3986 for the official -but unpractical- regex
		$tree = \@tree;
	}
	else { # text/uri-list or text/x-zim-page-list
		my @links = Zim::GUI::Component->decode_uri_list($string);
		if ($type eq 'text/x-zim-page-list') {
			my $rep = $self->{_zim_name}; # FIXME FIXME FIXME
			@links = map {s/^\Q$rep\E\?//; $_} @links;
		}
		$tree = [ 'Page', {}, 
			map {(['link', {to => $_}, $_], "\n")} @links ];
	}

	if ($iter) { $self->insert_blocks($iter, $tree)           }
	else       { $self->insert_blocks_at_cursor($iter, $tree) }
	$self->end_user_action if $paste_data->{interactive};
}

sub _parse_link { # FIXME copy-pasted from Zim/Formats/Wiki.pm
	my $l = shift;
	my $text;
	if ($l =~ /^\[\[([^|]+)\|?(.*)\]\]$/) { # [[link]] or [[link|text]]
		($l, $text) = ($1, $2);
	}
	if ($l =~ /^mailto:|^\S+\@\S+\.\w+$/) {
		$text = $l unless length $text;
		$l =~ s/^(mailto:)?/mailto:/;
	}
	return ['link', {to => $l}, length($text) ? $text : $l ];
}

1;

__END__

=back

=head1 TAGS

Tags are used in L<Gtk2::TextBuffer> to render certain parts of the text buffer with
a certain colours or certain decorations. In B<Gtk2::Ex::HyperTextBuffer> they also
represent a node in the document parse tree. See L<Gtk2::TextTag> for more details.

The following tags are pre-defined:

=over 4

=item head1

=item head2

=item head3

=item head4

=item head5

=item bold

=item italic

=item underline

=item verbatim

=item Verbatim

Like 'verbatim' but intended for multiline blocks.

=item link

For links anonymous TextTags are used, but the visual properties are defined the
same way as for other tags.

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

