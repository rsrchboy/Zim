package Gtk2::Ex::PathBar;

our $VERSION = '0.14';

use strict;
use Gtk2;
use Glib::Object::Subclass
	Gtk2::Box::,
	signals => {
		size_request => \&do_size_request,
		size_allocate => \&do_size_allocate,
		# new signal
		path_clicked => {
			param_types => [qw/Glib::Scalar Glib::Int/],
		},
	};

our $scroll_timeout = 150;
our $initial_scroll_timeout = 300;

=head1 NAME

Gtk2::Ex::PathBar - A button path bar widget

=head1 SYNOPSIS

	use Gtk2;
	use Gtk2::Ex::PathBar;
	use File::Spec;
	
	my $pathbar = Gtk2::Ex::PathBar->new(spacing => 3);
	$pathbar->show;
	
	# show a path
	my $name = '/foo/bar/baz';
	my ($vol, $dir, $file) = File::Spec->splitpath($name);
	my @path = (($vol || '/'), File::Spec->splitdir($dir), $file);
	$pathbar->set_path(grep length($_), @path);
	$pathbar->signal_connect(path_clicked => \&load_dir);

	# or show a history
	my @hist = qw(/foo/bar /tmp/baz /home/pardus);
	$pathbar->set_path(map [basename($_), $_], @hist);
	$pathbar->signal_connect(path_clicked => \&load_dir);

	sub load_dir {
		my ($button, @path) = @_;
		# ...
	}

=head1 DESCRIPTION

This widget is intended as a look-a-like for the "button path bar" used
in the gtk file dialog. Each part of the path is represented by a button.
If the button row gets to long sliders are shown left and right to scroll
the bar.

It can be used to display a path to a file or directory or to display
similar data like a history (trace) or a namespace.

=head1 HIERARCHY

  Glib::Object
  +----Gtk2::Object
        +----Gtk2::Widget
              +----Gtk2::Container
	           +----Gtk2::Box
                        +----Gtk2::Ex::PathBar

=head1 METHODS

=over 4

=item C<< new(spacing => $spacing, ..) >>

Simple constructor, takes pairs of properties.

=cut

# constructor inherited from Glib::Object

sub INIT_INSTANCE {
	my $self = shift;
	$self->{anchor} = ['first_item', 0];
	$self->{_scroll_timeout} = -1;
	$self->{hide_sliders} = 0;
	
	$self->add( $self->_get_slider_button('back') );
	$self->add( $self->_get_slider_button('forw') );
}

# Slider buttons get 3 signals connected, "button_press" to start continuous
# scrolling, "button_release" to stop continuous scrolling and "clicked" to 
# scroll one position. There are two timeouts, one between "button_press" and
# the actual start of continuous scrolling and one between scroll steps during
# continuous scrolling.

sub _get_slider_button {
	my ($self, $direction) = @_;
	
	my $slider = Gtk2::Button->new();
	my $type = ($direction eq 'back') ? 'left' : 'right';
	my $arrow = Gtk2::Arrow->new($type, 'out');
	$slider->add($arrow);
	$slider->signal_connect_swapped(
		button_press_event => \&_on_button_press_event, $self );
	$slider->signal_connect_swapped(
		button_release_event => \&stop_scrolling, $self );
	my $sub = ($direction eq 'back')
		? sub { $self->scroll_back(1) }
		: sub { $self->scroll_forw(1) } ;
	$slider->signal_connect(clicked => $sub);
	$slider->show_all;
	
	$slider->{direction} = $direction;
	return $slider;
}

sub _on_button_press_event {
	my ($self, $event, $button) = @_;
	return unless $event->button == 1;
	
	$self->stop_scrolling;
	$self->{_scroll_timeout} =
		Glib::Timeout->add($initial_scroll_timeout,
			sub {$self->start_scrolling($button->{direction})} );
	return 0;
}

sub FINALIZE_INSTANCE {
	my $self = shift;
	$self->stop_scrolling;
}

=item C<start_scrolling(DIRECTION)>

Start continuous scrolling. DIRECTION can be either 'left' or 'right'.

=cut

sub start_scrolling {
	my ($self, $direction) = @_;
	my $sub = ($direction eq 'back')
		? sub { $self->scroll_back(1) }
		: sub { $self->scroll_forw(1) } ;
	$self->{_scroll_timeout} =
		Glib::Timeout->add($scroll_timeout, $sub);
	return 0; # for event
}

=item C<stop_scrolling()>

Stop continuous scrolling.

=cut

sub stop_scrolling {
	my $self = shift;
	my $timeout = $self->{_scroll_timeout};
	Glib::Source->remove($timeout) if $timeout >= 0;
	$self->{_scroll_timeout} = -1;
	return 0; # for event
}

=item C<hide_sliders(BOOLEAN)>

By default the sliders are made insensitive if you are displaying
multiple items but you scrolled to one end of the list.
After setting this method sliders are hidden instead of showing
insensitive.

=cut

sub hide_sliders { $_[0]->{hide_sliders} = $_[1] }

sub do_size_request {
	# get minimum required size and store it in $requisition
	my ($self, $requisition) = @_;
	my $spacing = $self->get_spacing;
	my $border = $self->get_border_width;
	
	my ($min_width, $min_height);
	for ($self->get_children) {
		my $c_requisition = $_->size_request;
		my ($w, $h) = ($c_requisition->width, $c_requisition->height);
		$min_height = $h if $h > $min_height;
		$min_width = $w if $w > $min_width;
	}

	my $slider_width = $min_height * 2 / 3 + 5; # formula from gtkpathbar.c
	$slider_width = $min_height if $min_height < $slider_width;
	$self->{slider_width} = $slider_width;
	
	$min_width += $slider_width + 2 * $spacing + 2 * $border;
	$min_height += 2 * $border;
	$requisition->height($min_height);
	$requisition->width($min_width);

	$self->signal_chain_from_overridden($requisition);
		# not sure whether this call is needed
}

# In order to display as many items as possible we use the following
# scrolling algorith:
#
# There is an "anchor" containing "first_item" or "last_item" plus an
# item index. The anchor item will be visible. We start filling the space
# by taking this anchor as either left or right side of the visible range
# and start adding other items from there. We can run out of items when we
# reach the end of the item list, or we can run out of space when the next
# item is larger than the space that is left.
# Next we check if we can show more items by adding items in the opposite
# direction. Possibly replacing our anchor as outer left or outer right item.
# Once we know which items are the new "first_item" and "last_item" we 
# start allocating space to the widgets.
#
# To make things more complex one should realize that whether "first_item" is
# on the left or the right depends on the current locale. For right-to-left
# environments the items are allocated from the right.
#
# Slide buttons are shown when all buttons do not fit in the given space.
# The space is calculated either with or without sliders. At the end we
# check if the sliders are really needed. We choose to hide the slider if
# it can't be used to scroll more instead of making it insensitive because 
# the arrows do not show very clear when they are sensitive and when not.
# The space that is freed when a slider is hidden is not recycled because
# that would pose the risk of clicking on a button when the slider suddenly
# disappears.

sub do_size_allocate {
	my ($self, $allocation) = @_;
	my ($back_slider, $forw_slider, @items) = $self->get_children;
	return unless @items; # no items to allocate
	
	# Get basic parameters
	my ($x, $y, $w, $h) = ($allocation->values);
	my ($spacing, $border, $slider_width) = 
		($self->get_spacing, $self->get_border_width, $self->{slider_width});
	my @items_width = map $_->requisition->width, @items;
	my ($anchor, $begin) = @{$self->{anchor}};
	#warn "anchor: $anchor, $begin\n";

	# Calculate which items to display
	my $total_width = $spacing * $#items;
	$total_width += $_ for @items_width;
	my $show_sliders = ($total_width > $w - 2 * $border);
	my $available_width = $w - 2 * $border;
	$available_width -= 2 * ($slider_width + $spacing) if $show_sliders;
	$available_width -= $items_width[$begin];
	my $end = $begin;
	for ( ($anchor eq 'first_item')
		? ($begin + 1 .. $#items  )
		: (reverse 0 .. $begin - 1)
	) {
		if ($available_width > $spacing + $items_width[$_]) {
			$available_width -= $spacing + $items_width[$_];
			$end = $_;
		}
		else { last }
	}
	
	# Check if we have any space left to fill from the other side
	for ( ($anchor eq 'first_item')
		? (reverse 0 .. $begin - 1)
		: ($begin + 1 .. $#items  )
	) {
		if ($available_width > $spacing + $items_width[$_]) {
			$available_width -= $spacing + $items_width[$_];
			$begin = $_;
		}
		else { last }
	}
	#warn "available: $available_width, begin and end: $begin, $end, show_sliders: $show_sliders\n";
	
	# Switch order
	($begin, $end) = ($anchor eq 'first_item') ? ($begin, $end) : ($end, $begin) ;
	@{$self}{qw/first_item last_item/} = ($begin, $end);
	
	# Allocate items
	my $direction = $self->get_direction;
	my $child_allocation = Gtk2::Gdk::Rectangle->new(
		0, $y + $border, 0, $h - 2 * $border); # x, y, w, h
	my @x_sliders;
	if ($direction eq 'ltr') { # left-to-right environement
		my $child_x = $x + $border;
		$child_x += $slider_width + $spacing if $show_sliders;
		for ($begin .. $end) {
			#print "allocating item $_\n";
			$child_allocation->width($items_width[$_]);
			$child_allocation->x($child_x);
			$items[$_]->set_child_visible(1);
			$items[$_]->size_allocate($child_allocation);
			$child_x += $items_width[$_] + $spacing;
		}
		@x_sliders = ($x + $border, $x + $w - $border - $slider_width);
	}
	else { # right-to-left environment
		my $child_x = $x + $w - $border;
		$child_x -= $slider_width + $spacing if $show_sliders;
		for ($begin .. $end) {
			#print "allocating item $_\n";
			$child_allocation->width($items_width[$_]);
			$child_allocation->x($child_x - $items_width[$_]);
			$items[$_]->set_child_visible(1);
			$items[$_]->size_allocate($child_allocation);
			$child_x -= $items_width[$_] + $spacing;
		}
		@x_sliders = ($x + $w - $border - $slider_width, $x + $border);
	}
		
	
	# Hide invisible items
	$items[$_]->set_child_visible(0)
		for 0 .. $begin - 1, $end + 1 .. $#items;
	
	# Allocate sliders
	$show_sliders = 0 if $self->{hide_sliders};
	if ($show_sliders or $begin != 0) {
		$child_allocation->width($slider_width);
		$child_allocation->x($x_sliders[0]);
		$back_slider->set_child_visible(1);
		$back_slider->size_allocate($child_allocation);
		$back_slider->set_sensitive($begin != 0);
	}
	else {	$back_slider->set_child_visible(0) }
	
	if ($show_sliders || $end != $#items) {
		$child_allocation->width($slider_width);
		$child_allocation->x($x_sliders[1]);
		$forw_slider->set_child_visible(1);
		$forw_slider->size_allocate($child_allocation);
		$forw_slider->set_sensitive($end != $#items);
	}
	else {	$forw_slider->set_child_visible(0) }

	# Make sure $allocation gets stored in our object
	$self->signal_chain_from_overridden($allocation);
	
	# Thats all ...
}

=item C<scroll_back(INT)>

Scrolls the path bar one or more items back.
This is to the left for left-to-right oriented environements.

=cut

sub scroll_back {
	my $self = shift;
	shift if ref $_[0];
	my $i = shift || 1;
	my $first = $self->{first_item};
	return 0 if $first == 0;
	$first = ($first <= $i) ? 0 : $first - $i;
	$self->{anchor} = ['first_item', $first];
	$self->queue_resize;
	return 1;
}

=item C<scroll_forw(INT)>

Scrolls the path bar one or more items forward.
This is to the right for left-to-right oriented environements.

=cut

sub scroll_forw {
	my $self = shift;
	shift if ref $_[0];
	my $i = shift || 1;
	my $last = $self->{last_item};
	my (undef, undef, @items) = $self->get_children;
	return 0 if $last == $#items;
	$last += $i;
	$last = $#items if $last > $#items;
	$self->{anchor} = ['last_item', $last];
	$self->queue_resize;
	return 1;
}

=item C<set_path(PART, PART, ..)>

This method fills the path bar with a button for each part of the path.
When one of theses buttons is clicked the 'path_clicked' signal is emitted
with as argument an array reference holding the path elements to that button.

You can also use array references instead of strings for the parts of the path.
In this case the first element of these arrays is the string to display on 
the button. All other parts of the array are passed as a array reference to the
'path_clicked' signal. This can be used if the data you want to display is
not really a path.

=cut

sub set_path {
	my ($self, @parts) = @_;
	my @buttons;
	my @path;
	for (0 .. $#parts) {
		my ($name, $arg);
		if (ref $parts[$_]) { # part is array ref
			$arg = [@{$parts[$_]}]; # force copy
			$name = shift @$arg;
		}
		else { # part is string
			$name = $parts[$_];
			push @path, $name;
			$arg = [@path];
		}
		my $button = Gtk2::ToggleButton->new_with_label($name);
		$button->{path_data} = $arg;
		$button->{path_index} = $_;
		$button->signal_connect_swapped(
			clicked => \&_button_clicked, $self );
		$button->show;
		push @buttons, $button;
	}
	$self->set_items(@buttons);
}

sub _button_clicked {
	my ($self, $button) = @_;
	$self->select_item($button);
	$self->signal_emit('path_clicked', @{$button}{qw/path_data path_index/});
}

=item C<set_items(WIDGET, WIDGET, ..)>

Low level method used by C<set_path()> to fill the path bar with buttons.
You can use this method to fill the path bar with your own buttons or other widgets.
Of course widgets added with this method will not automaticly trigger the 
C<path_clicked> signal.

=cut

sub set_items {
	my $self = shift;
	$self->clear_items;
	$self->pack_start($_, 0,0,0) for @_;
	$self->select_item($#_);
}

=item C<get_items()>

Returns a list of widgets coresponding to the items in the path bar.
Notice that this differs from C<get_children()> which will also give
you the widgets for the sliders.

=cut

sub get_items {
	my $self = shift;
	my (undef, undef, @items) = $self->get_children;
	return @items;
}

=item C<clear_items()>

Removes all buttons from the path bar.

=cut

sub clear_items { # reset all rendering attributes
	my $self = shift;
	$self->{anchor} = ['first_item', 0];
	$self->{first_item} = -1;
	$self->{last_item} = -1;
	$self->{selected_item} = undef;
	$self->{button_clicked_handler} = undef;
	my (undef, undef, @items) = $self->get_children;
	$self->remove($_) for @items;
}

=item C<select_item(INDEX)>

Selects the button associated with path part number INDEX in the array given
to C<set_path()> or C<set_items()>. This will have the same visual effect as
when the user clicked the button in question.

If you used C<set_items()> to add your own widgets you can also use an object
ref instead of INDEX here.

=cut

sub select_item {
	# toggle selected item, untoggle previous selected item
	# selected item gets bold text
	my ($self, $item) = @_;
	my (undef, undef, @items) = $self->get_children;
	
	my $s_item = $self->{selected_item};
	if ($s_item and $s_item->isa('Gtk2::ToggleButton')) {
		$s_item->signal_handlers_block_by_func(\&_button_clicked);
		$s_item->set_active(0);
		my $label = $s_item->get_child;
		if ($label->isa('Gtk2::Label')) { # remove bold
			my $text = $label->get_text;
			$label->set_text($text);
		}
		$s_item->signal_handlers_unblock_by_func(\&_button_clicked);
	}
	
	$item = $items[$item] unless ref $item; # allow for index and object ref
	return unless ref $item;
	if ($item->isa('Gtk2::ToggleButton')) {
		$item->signal_handlers_block_by_func(\&_button_clicked);
		$item->set_active(1);
		my $label = $item->get_child;
		if ($label->isa('Gtk2::Label')) { # set text bold
				my $text = $label->get_text;
				$label->set_markup("<b>$text</b>");
		}
		$item->signal_handlers_unblock_by_func(\&_button_clicked);
	}
	$self->{selected_item} = $item;

	# bring/keep selected item in the visual range
	$self->queue_resize;
	my ($i) = grep {$items[$_] eq $item} 0 .. $#items;
	my $anchor =	($i < $self->{first_item}) ? 'first_item' :
			($i > $self->{last_item})  ? 'last_item'  : undef;
	if ($anchor) {
		$self->{anchor} = [$anchor, $i];
		$self->queue_resize;
	}
}

1;

__END__

=back

=head1 SIGNALS

=over 4

=item C<path_clicked(PATH, INDEX)>

Emitted when one of the buttons in the path is clicked.
PATH is an array reference containing the path coresponding to the
button clicked. INDEX is the list index of the button in the path.

=back

=head1 AUTHOR

Jaap Karssenberg || Pardus [Larus] <pardus@cpan.org>

Copyright (c) 2005 Jaap G Karssenberg. All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut

