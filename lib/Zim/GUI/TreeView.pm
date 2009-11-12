package Zim::GUI::TreeView;

use strict;
use vars '$AUTOLOAD';
use Gtk2;
use Gtk2::Gdk::Keysyms;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.28';
our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI::TreeView - Page index widgets

=head1 DESCRIPTION

This module contains the widgets to display the index 
of a zim notebook as a TreeView.

=head1 METHODS

Undefined methods AUTOLOAD to the L<Gtk2::TreeView> widget.

=over 4

=item C<new(app => PARENT)>

Simple constructor.

=item C<init()>

Method called by the constructor.

=cut

my ($k_left, $k_right, $k_esc) = @Gtk2::Gdk::Keysyms{qw/Left Right Escape/};

sub init { # called by new()
	my $self = shift;

	my $scroll_window = Gtk2::ScrolledWindow->new();
	$scroll_window->set_policy('never', 'automatic');
	$scroll_window->set_shadow_type('in');
	$self->{scroll_window} = $scroll_window;

	my $tree_store = Gtk2::TreeStore->new('Glib::String', 'Glib::String');
	$self->{tree_store} = $tree_store;

	my $tree_view = Gtk2::TreeView->new($tree_store);
	my $renderer = Gtk2::CellRendererText->new();
	$renderer->set_property(ellipsize => 'end');
	$renderer->signal_connect_swapped(edited => \&on_cell_edited, $self);
	$self->{renderer} = $renderer;
	my $page_column = Gtk2::TreeViewColumn->new_with_attributes(
        	'Pages', $renderer, 'text', 0); # hidden column label
	$tree_view->append_column($page_column);
	$tree_view->set_headers_visible(0);
#	$tree_view->set_reorderable(1);
	$tree_view->get_selection->set_mode('browse'); # one item selected at all times
	$tree_view->set_search_column(1);
	$tree_view->set_search_equal_func(\&on_search_equal);
	$tree_view->signal_connect(key_press_event      => \&on_key_press_event, $self);
	$tree_view->signal_connect(button_release_event => \&on_button_release_event, $self);
	$tree_view->signal_connect(row_activated        => \&on_row_activated, $self);
	$tree_view->signal_connect(popup_menu           => sub {
			my ($path) = $tree_view->get_cursor;
			$self->popup_context_menu($path);
		} );
	$scroll_window->add($tree_view);
	$self->{tree_view} = $tree_view;

	$self->{app}->signal_connect(page_loaded => sub {$self->select_page(pop, 'TMP')});
	$self->{app}->signal_connect(page_deleted => sub {$self->unlist_page(pop)});
	$self->{app}->signal_connect(page_created => sub {
		my $page = pop;
		$self->list_page($page);
		$self->select_page($page);
	} );
	$self->{app}->signal_connect(page_renamed => sub {
		my $new = pop;
		my $old = pop;
		$self->unlist_page($old);
		$self->list_page($new);
		} );

	# drag-n-drop stuff
	$tree_view->enable_model_drag_source(
		'button1-mask', ['link'],
		['text/x-zim-page-list', [], 0] );
	$tree_view->signal_connect_swapped(
		drag_data_get => \&on_drag_data_get, $self);
	$tree_view->enable_model_drag_dest(
		['link'],
		['text/x-zim-page-list', [], 0] );
	$tree_view->signal_connect_swapped(
		drag_data_received => \&on_drag_data_received, $self);
	$tree_view->signal_connect(drag_begin => sub { $$self{drag_lock} = 1 });
	$tree_view->signal_connect(drag_end => sub { $$self{drag_lock} = 0 });


	$self->{widget} = $self->{tree_view};
	$self->{top_widget} = $self->{scroll_window};
}

sub on_drag_data_get { # we are drag source
        my ($self, $context, $selection_data, $info, $time) = @_;
	return unless $info == 0; # text/x-zim-page-list

	my $rep = $self->{app}{notebook}{name};
	warn "BUG: no notebook name set!" unless length($rep);
	my @pages = map "$rep?$_", grep length($_), map {$self->path2page($_)}
		$self->{tree_view}->get_selection->get_selected_rows;
	#warn "drag data: @pages";
	my $data = $self->encode_uri_list(@pages);
	
	$selection_data->set($selection_data->target, 8, $data);
}

sub on_drag_data_received { # we are drag target
	my ($self, $context, $x, $y, $selection_data, $info, $time) = @_;
	#warn "!! drag_action:".$context->action.' ('.join(', ', $context->actions).")\n";
	return unless $info == 0; # text/x-zim-page-list

	my $data = $selection_data->data;
	my @pages = $self->decode_uri_list($data);
	return unless @pages == 1; # just to be sure
	my $page = $pages[0];
	my $tree_view = $$self{tree_view};

	my ($path, $pos) = $tree_view->get_dest_row_at_pos($x, $y);
	my $node = $self->path2page($path);
	#warn "got: $page => $pos $node\n";
	$node =~ /^(.*:)/ or return;
	my $node_ns = ($pos =~ /into/) ? $node.':' : $1;
	$page =~ /^(.*?)\?(.*:)(.+)/ or return;
	my ($rep, $ns, $basename) = ($1, $2, $3);
	if ($rep ne $$self{app}{notebook}{name} or $ns eq $node_ns) {
		# either from a different notebook
		# or in the same namespace
		# => failure
		$context->finish(0, 1, $time);
	}
	else {
		$page = $ns.$basename;
		my $model = $tree_view->get_model;
		my $orig_path = $self->page2path($page) or return;
		my $orig_iter = $model->get_iter($orig_path);
		my $ok = 0;
		if (
			$orig_path->compare($path) != 0
				# not moving a page to itself
			and ! $model->iter_has_child($orig_iter)
				# not moving subtrees for now
		) {
			#warn "Moving $page to $node_ns$basename\n";
			$ok = $self->{app}->RenamePage
				($page => $node_ns.$basename, 'UPDATE', 'UPDATE');
		}
		$context->finish($ok, 1, $time);
	}
}

sub on_search_equal { # Case insensitive match
	my ($model, $col, $key, $iter) = @_;
	my ($page) = $model->get($iter, $col);
	return ( ($page =~ /:\Q$key\E/i) ? 0 : 1 ); # reverse logic
}

sub on_key_press_event { # some extra keybindings for the treeview
	my ($tree_view, $event, $self) = @_;
	my $val = $event->keyval();
	my $key = chr($val);
#	warn "got key $key ($val) ".$event->state."\n";
	if ($val == $k_left) { # Left arrow
		my ($path) = $tree_view->get_selection->get_selected_rows;
		$tree_view->collapse_row($path) if defined $path;
	}
	elsif ($val == $k_right) { # Rigth arrow
		my ($path) = $tree_view->get_selection->get_selected_rows;
		$tree_view->expand_row($path, 0) if defined $path;
	}
	elsif ($key eq 'c' and $event->state >= 'control-mask') { # ^C
		$self->{app}->CopyLocation( $self->get_selected );
	}
	elsif ($key eq 'l' and $event->state >= 'control-mask') { # ^L
		my $page = $self->get_selected;
		$self->{app}->PageView->InsertLink($page, $page, 'NO_ASK');
	}
	elsif ($key eq '\\') { # Collapse all
		$tree_view->collapse_all;
	}
	elsif ($key eq '*') { # Expand all
		$tree_view->expand_all;
	}
	elsif ($val == $k_esc) { # Escape - close side pane
		$$self{app}->TPane(0) if $$self{app}{_pane_visible} == -1;
	}
	else { return 0 }
	return 1;
}

sub on_button_release_event {
	my ($tree_view, $event, $self) = @_;
	return 0 if $event->type ne 'button-release';
	
	my ($x, $y) = $event->get_coords;
	my ($path, $column) = $tree_view->get_path_at_pos($x, $y);
	return 0 unless $path;
	
	$self->activate_if_selected($path, $column)
		if $event->button == 1;
	$self->popup_context_menu($path, $event)
		if $event->button == 3;
	return 0;
}

sub on_row_activated { # load a page when clicked or entered
	my $self = pop;
	return if $$self{drag_lock};
		# Sometimes this signal is triggered while in a drag
		# operation. Bug in Gtk? Not sure.
	my ($tree_view, $path) = @_;
	my $page = $self->path2page($path);
	$self->{app}->load_page($page)
		unless $self->{app}{page} and $page eq $self->{app}{page}->name;
}

=item C<page2path(PAGE)>

Returns the TreePath corresponding to PAGE.

=cut

sub page2path {
	my ($self, $page) = @_;
	$page =~ s/^:+|:+$//g;
	my @page = split /:+/, $page;
	my $model = $self->{tree_view}->get_model;
	my $iter;
	my $p = '';
	while (@page) {
		$p .= ':' . shift @page;
		$iter = $model->iter_children($iter) || return;
			# returns root iter when iter is undef
		while ($model->get($iter, 1) ne $p) {
			$iter = $model->iter_next($iter) || return;
		}
	}
	return $iter ? $model->get_path($iter) : undef ;
}

=item C<path2page(PATH)>

Returns the page name corresponding to a certain TreePath.

=cut

sub path2page {
	my ($self, $path) = @_;
	my $model = $self->{tree_view}->get_model;
	my $iter = $model->get_iter($path);
	return $model->get($iter, 1);
}

=item C<activate_if_selected(PATH, COLUMN)>

Emit the "row_activated" signal if PATH was already selected.
This method is used for the single-click navigation of the TreeView.

COLUMN is an optional argument.

=cut

sub activate_if_selected { # single-click navigation
	my ($self, $path, $column) = @_;
	my $tree_view = $self->{tree_view};

	return 0 unless $tree_view->get_selection->path_is_selected($path);

	my $page = $self->path2page($path);
	$column ||= $tree_view->get_column(0);
	$tree_view->row_activated($path, $column)
		unless $self->{app}{page} and $page eq $self->{app}{page}->name;
}

=item C<popup_context_menu(PATH, EVENT)>

Show the context menu for TreePath PATH.

EVENT is an optional argument.

=cut

sub popup_context_menu {
	my ($self, $path, $event) = @_;
	my $tree_view = $self->{tree_view};
	my $page = $self->path2page($path);
	my ($button, $time) = $event
		? ($event->button, $event->time) : (0, 0) ;
	return $self->{app}->popup('PagePopup', $button, $time, $page);
}

=item C<load_index()>

Called the first time the pane is showed to fill the index tree.

Will be DEPRECATED.

=cut

sub load_index { # TODO remove this from Zim.pm and PageView.pm
	my $self = shift;
	return if $self->{_loaded};
	$self->{tree_store}->clear; # just to be sure
	$self->list_pages(':');
	$self->{_loaded} = 1;
}

=item C<list_pages(NAMESPACE)>

Wrapper around C<< Zim::Store->list_pages() >> to fill the tree.

=cut

sub list_pages {
	my ($self, $namespace, $iter) = @_; # last argument is private
	$iter ||= $self->list_page($namespace);
	# TODO check for existing children
	$namespace =~ s/:*$//;
	my $model = $self->{tree_store};
	my $notebook = $self->{app}{notebook};
	my @queue = ([$namespace, $iter]);
	my $sub = sub {
		unless (@queue) {
			warn "# Done scanning tree\n";
			$self->{app}->pop_status('TreeView');
			$self->select_page($self->{app}{page}->name) if $self->{app}{page};
			return 0;
		}
		my ($ns, $node) = @{ shift @queue };
		#warn "list_pages: $ns\n";
		my $child;
		for my $p ($notebook->list_pages($ns)) {
			#warn "\t$p\n";
			my $is_dir = ($p =~ s/:+$//);
			my $name = $p;
			$name =~ s/_/ /g;
			$child = $model->append($node);
			$model->set($child, 0 => $name, 1 => $ns.':'.$p);
				# base_name, name
			push @queue, [$ns.':'.$p, $child] if $is_dir; # recurse
		}

		# expand tree into this namespace (child is last child)
		$self->{tree_view}->expand_to_path($model->get_path($child))
			if $child and $self->{app}{settings}{expand_tree};
		
		return 1;
	} ;
	warn "# Start scanning tree\n";
	$self->{app}->push_status(
		__('Scanning tree ...'), 'TreeView'); #. status bar info
	Glib::Idle->add($sub);
}

=item C<list_page(REALNAME)>

Adds a page to the index tree.

=cut

sub list_page {
	my ($self, $page) = @_;
	$page =~ s/^:+|:+$//g;
	my @page = split /:+/, $page;
	my $model = $self->{tree_view}->get_model;
	my $iter;
	my $p = '';
	while (@page) {
		# WARNING this method assumes case-insensitive sorting
		my $name = shift @page;
		$p .= ':' . $name;
		my $child = $model->iter_children($iter);
			# returns root iter when iter is undef

		# Loop trough children to do case insensitive match.
		# Stop looping when child is sorting after the name we look for.
		while ($child and (lc $model->get($child, 1) cmp lc $p) == -1) {
			$child = $model->iter_next($child);
		}
		
		#warn "list page:\t$p\n";
		if (! $child) {
			# We reached the end of the list when looping,
			# append item
			$child = $model->append($iter);
			$name =~ s/_/ /g;
			$model->set($child, 0 => $name, 1 => $p);
				# base_name, name
		}
		elsif ((lc $model->get($child, 1) cmp lc $p) == 1) {
			# We found a child sorting after the one we are
			# looking for, insert item
			$child = $model->insert_before(undef, $child);
			$name =~ s/_/ /g;
			$model->set($child, 0 => $name, 1 => $p);
				# base_name, name
		}
		# else we found an exact match, do not set properties

		# If the page we are listing was tmp listed before by
		# select_page, we remove the flag to list it permanently
		$$self{tmp_listed} = undef if $$self{tmp_listed} eq $p;

		$iter = $child;
	}
	return $iter;
}

=item C<unlist_page(REALNAME)>

Removes a page from the index unless it has children.

=cut

sub unlist_page {
	my ($self, $page) = @_;
	my $path = $self->page2path($page) || return;
	my $model = $self->{tree_view}->get_model;
	my $iter = $model->get_iter($path);
	return if $model->iter_children($iter); # has children
	$model->remove($iter);
}

=item C<select_page(PAGE, TMP)>

Update the TreeView to display and highlight a certain page.
If TMP is true the page is temporarily added when it did not yet exist.

=cut

sub select_page {
	my ($self, $page, $tmp) = @_;
	if ($$self{tmp_listed} and $$self{tmp_listed} ne $page) {
		# Remove a previously temp listed page when changing selection.
		$self->unlist_page($$self{tmp_listed});
		$$self{tmp_listed} = undef;
	}

	my $path = $self->page2path($page);
	if (! $path && $tmp) {
		# If page does not exist (or wasn't listed for some reason)
		# we list it temporarily and select it
		$self->list_page($page);
		$$self{tmp_listed} = $page;
			# do this after list_page(), else it gets deleted
		$path = $self->page2path($page);
	}
	return unless $path;
	my $view = $self->{tree_view};
	$view->expand_to_path($path);
	$view->get_selection->select_path($path);
	$view->set_cursor($path);
	$view->scroll_to_cell($path, undef, 0); # vert. scroll
}

=item C<get_selected()>

Returns the name of the currently selected page.

=cut

sub get_selected {
	my $self = shift;
	my ($path) = $self->{tree_view}->get_selection->get_selected_rows;
	return unless $path;
	return $self->path2page($path);
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

L<Zim>

=cut

