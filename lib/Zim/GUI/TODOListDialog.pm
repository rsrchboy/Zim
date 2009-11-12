package Zim::GUI::TODOListDialog;

use strict;
use Zim::GUI::Component;
use Zim::Utils;

our $VERSION = '0.27';

our @ISA = qw/Zim::GUI::Component/;

use constant {
	# TreeModel columns  (!= TreeView columns)
	COL_VIS  => 0,
	COL_PRIO => 1,
	COL_DESC => 2,
	COL_DATE => 3,
	COL_PAGE => 4,
};

=head1 NAME

Zim::GUI::TODOListDialog - A TODO-list dialog for zim

=head1 DESCRIPTION

This packages defines the dialog used by the TODOList plugin.

=head1 METHODS

=over 4

=item C<new()>

Simple constructor.

=cut

# Make sure to use get_value() instead of get(), for some releases
# of gtk+/Gtk2 TreeModelSort does not support get()

my $CONFIG = {
	use_all_checkboxes => 0,
	tags => 'TODO,FIXME',
};

sub init {
	my $self = shift;
	$self->init_settings('TODOList Plugin', $CONFIG);

	## Setup dialog
	my $dialog = Gtk2::Window->new('toplevel');
	$dialog->set_title( __('TODO List').' - Zim' ); #. dialog title
	$dialog->signal_connect(delete_event => sub {
		$$self{app}->actions_set_active(TTODOList => 0); # calls hide
		return 1;
	} );
	$dialog->set_border_width(5);
	$dialog->set_default_size(600,400);
	#if (Gtk2->CHECK_VERSION(2, 6, 0)) {
	#	FIXME does not seem to work when we have no gnome theme
	#	$dialog->set_icon_name('stock_todo'); # since 2.6.0
	#}
	#else {
		$dialog->set_icon($$self{app}{window}->get_icon)
			if $$self{app}{window} ;
	#}

	my $vbox = Gtk2::VBox->new();
	$dialog->add($vbox);

	## Set up statistics label and filter entry
	my $hbox = Gtk2::HBox->new();
	$vbox->pack_start($hbox, 0,1,0);
	
	my $l = Gtk2::Label->new(__('Filter').': '); #. prompt
	$hbox->pack_start($l, 0,0,0);

	my $entry = Gtk2::Entry->new;
	my $filter_b = $self->new_button('gtk-find', __('_Filter')); #. Button label
	my $clear_b = Gtk2::Button->new_from_stock('gtk-clear');
	$hbox->pack_start($_, 0,1,0) for $entry, $filter_b, $clear_b;

	$entry->signal_connect('activate' => sub { $filter_b->clicked });
	$filter_b->signal_connect('clicked' => sub { $self->filter() });
	$clear_b->signal_connect('clicked' => sub {
		$entry->set_text('');
		$self->filter();
	} );
	$$self{filter_entry} = $entry;

	my $stat_label = Gtk2::Label->new(' 'x20);
	$$self{stat_label} = $stat_label;
	$hbox->pack_end($stat_label, 0,0,0);

	## Set up TreeView, Model and Columns
	my $swindow = Gtk2::ScrolledWindow->new();
	$swindow->set_policy('automatic', 'automatic');
	$swindow->set_shadow_type('in');
	$vbox->add($swindow);
	
	my $treemodel = Gtk2::TreeStore->new( map "Glib::$_",
		# COL_VIS, COL_PRIO, COL_DESC, COL_DATE, COL_PAGE
		qw/Boolean Int       String    String    String/);
	my $filtermodel= Gtk2::TreeModelFilter->new($treemodel);
	$filtermodel->set_visible_column(0);
		# make the model filter on this bool
	my $sortmodel = Gtk2::TreeModelSort->new_with_model($filtermodel);
		# make it sortable again
	$sortmodel->set_sort_column_id(&COL_PRIO => 'descending');
		# by default sort on highest priority

	my $treeview = Gtk2::TreeView->new($sortmodel);
	my $r = Gtk2::CellRendererText->new;
	for (
		[__('Prio'), COL_PRIO], #. column TODO list: priority
		[__('Task'), COL_DESC], #. column TODO list: task description
		[__('Date'), COL_DATE], #. column TODO list: due date
		[__('Page'), COL_PAGE], #. column TODO list: zim page
	) {
		my $c = Gtk2::TreeViewColumn->new_with_attributes(
			$$_[0], $r, text => $$_[1] );
		$c->set_sort_column_id($$_[1]);
		$c->set_expand($$_[1]) if $$_[1] == COL_DESC;
		$treeview->insert_column($c, -1);
	}

	$treeview->signal_connect(
		button_release_event => \&on_button_release_event);
	$treeview->signal_connect(row_activated => sub {
		my ($view, $path) = @_;
		my $name = $sortmodel->get_value(
			$sortmodel->get_iter($path), COL_PAGE );
		$$self{app}->present;
		$$self{app}->link_clicked($name);
	} );

	$swindow->add($treeview);
	$$self{widget} = $treeview;
	$$self{list} = $treemodel;
	
	## Option
	# FIXME this really belongs in the preferences menu
	# need a way to have plugin preferences there.
	my $checkbox = Gtk2::CheckButton->new_with_label(
		__('Include all open checkboxes') ); # checkbox label
	$checkbox->set_active( $$self{settings}{use_all_checkboxes} );
	$checkbox->signal_connect('toggled' => sub {
		$$self{settings}{use_all_checkboxes} = $checkbox->get_active;
		$$self{app}->SaveSettings;
	} );
	$vbox->pack_start($checkbox, 0,1,0);

	## Set up action buttons
	my ($help_b, $reload_b, $close_b) =
		map Gtk2::Button->new_from_stock($_),
			qw/gtk-help gtk-refresh gtk-close/;

	my $bbox = Gtk2::HButtonBox->new();
	$bbox->add($_) for $help_b, $reload_b, $close_b;
	$bbox->set_child_secondary($help_b, 1);
	$bbox->set_layout('end');
	$bbox->set_spacing(12);
	$vbox->pack_start($bbox, 0,1,0);

	$close_b->signal_connect(clicked =>
		sub { $$self{app}->actions_set_active(TTODOList => 0) } );
		# calls $self->hide() implicitly
	$reload_b->signal_connect(clicked =>
		sub { $self->reload } );
	$help_b->signal_connect(clicked =>
		sub { $$self{app}->ShowHelp(':usage:plugins:TODOList') } );

	$self->{dialog} = $dialog;
}

sub on_button_release_event {
	my ($slist, $event) = @_;
	return 0 if $event->type ne 'button-release';
	
	my ($x, $y) = $event->get_coords;
	my ($path, $column) = $slist->get_path_at_pos($x, $y);
	return 0 unless $path;
	
	if ($event->button == 1) { # single-click navigation
		return 0 unless $slist->get_selection->path_is_selected($path);
		$slist->row_activated($path, $column);
	}
	
	return 0;
}

=item C<show()>

Show the dialog.

=cut

sub show {
	my $self = shift;
	my $w = $self->{dialog};
	$w->move( @{$self->{position}} ) if $self->{position};
	$w->show_all;
	$w->move( @{$self->{position}} ) if $self->{position};
	$self->reload;
}

=item C<hide()>

Hide the dialog.

=cut

sub hide {
	my $self = shift;
	my $w = $self->{dialog};
	$self->{position} = [ $w->get_position ];
	$w->hide_all;
}

=item C<filter()>

Filter list based on text from the filter entry.
Matches on both the description of the item and the page name.

=cut

sub filter {
	my $self = shift;
	my $text = $$self{filter_entry}->get_text;
	if (length $text) {
		# Filter, grep rows that match
		my $regex = _filter_regex($text);
		warn "## TODOList: Filtering with regex: $regex\n";
		$$self{list}->foreach( sub {
			#print STDERR ".";
			my ($model, undef, $iter) = @_;
			my ($desc, $page) =
				$model->get_value($iter, COL_DESC, COL_PAGE);
			my $vis = (
				$desc =~ $regex or
				$page =~ $regex    );
			$model->set($iter, &COL_VIS => $vis);
			0; # keep going
		} );
	}
	else {
		# Clear, set all rows visible
		$$self{list}->foreach(
			sub { $_[0]->set($_[2], &COL_VIS => 1); 0 } );
	}
}

sub _filter_regex {
	my $string  = shift;
	my @words = split /\s+/, $string;
	my $regex = join "\\s+", map quotemeta($_), @words;
	return qr/(?i)$regex/;
}

=item C<reload()>

Reload the TODO list.

=cut

sub reload {
	my $self = shift;
	$$self{app}->SaveIfModified;
	$$self{list}->clear;

	my @query = split /,/, $$self{settings}{tags};
	push @query, '[ ]' if $$self{settings}{use_all_checkboxes};
	my $query = join '|', map quotemeta($_), grep length($_), @query;
	#warn 'Q: ', qr/$query/;

	# Search and filter in one go
	my $text = $$self{filter_entry}->get_text;
	my $regex = length($text) ? _filter_regex($text) : undef;
	$$self{app}{notebook}->search(
		{regex => qr/$query/, case => 1, word => 1},
		sub {
			$self->parse_page($_[0][0], $regex) if @_;
			while (Gtk2->events_pending) {
				Gtk2->main_iteration_do(0);
			}
		} );

	# Collect stats on priorities
	my ($total, @stats) = (0, 0);
	$$self{list}->foreach( sub {
		my $prio = $_[0]->get_value($_[2], COL_PRIO);
		$total++;
		$stats[$prio]++;
		0; # keep going
	} );
	$$self{stat_label}->set_text(
		__n("{number} item total", "{number} items total", number => $total) . #. number of tasks in TODO list
		" (".join('/',reverse(@stats)).")" );

	if ($total > 1) {
		# select first item and scroll up
		my $path = Gtk2::TreePath->new_first;
		$$self{widget}->scroll_to_cell($path, undef, 0);
	}
}

=item C<parse_page(NAME)>

Check a page for TODO items. Adds found items to the list.

=cut

sub parse_page {
	my ($self, $page, $filter) = @_;
	my $p = $$self{app}{notebook}->get_page($page);
	my $tree = $p->get_parse_tree;
	my @todo = $self->parse_tree($tree);
	for (@todo) { # [DESC, PRIO, [@DATE]]
		my ($desc, $prio, $date) = @$_;
		my $vis = $filter 
			? ($desc =~ $filter or $page =~ $filter)
			: 1 ;
		my $iter = $$self{list}->append(undef);
		$$self{list}->set($iter,
			&COL_VIS  => $vis,
			&COL_PRIO => $prio,
			&COL_DESC => $desc,
			&COL_DATE => "@$date",
			&COL_PAGE => $page,
		);
	}
}

=item C<parse_tree(TREE)>

Returns a list of TODO items for a given parse tree.

=cut

sub parse_tree {
	my ($self, $tree) = @_;
	my $tags = join '|', map quotemeta($_), 
	           grep length($_), split /,/, $$self{settings}{tags} ;
	#warn "TAGS >>$tags<<\n";

	# Pre filter to make sure headings are taken into acount as well
	my ($head, @para);
	for my $n (@$tree[2 .. $#$tree]) {
		if ($$n[0] eq 'Para') {
			if ($head) { push @{$para[-1]}, $n }
			else { push @para, $n }
		}
		elsif ($$n[0] =~ /head/) {
			if ($head) {
				# check same level to end block
				$head = undef if $$n[0] eq $head;
			}
			elsif ($tags and grep /\b($tags)\b/, @$n[2..$#$n]) {
				# start block
				$head = $$n[0];
				push @$n, "\n";
				push @para, $n;
			}
			# else ignore
		}
		# else ignore
	}

	# No turn list of paragraphs into list of TODO items
	my @todo;
	for my $n (@para) {
		my $para = _plain($n);
		#warn "Para >>>\n", $para, "<<<\n";
		if ($tags and $para =~ s/\A\s*($tags)\b:?\s*$//m) {
			# process multiline items
			# FIXME support hierarchical lists
			push @todo, grep /\w/, map {s/^\s*|\s*$//; $_} 
			            split /\n+/, $para ;
		}
		else {
			# process single line items
			for (split /\n+/, $para) {
				if ($tags and /^\s*($tags):?\s+(.*)$/) {
					# start of line
					push @todo, $2;
				}
				elsif ($tags and /^\s*([\x{2022}\-\*]\s|\[ \])/ 
				             and /\b($tags)\b/
				) {
					# list item or bullet, match anywhere
					s/\s*\b($tags)\b\s*//;
					push @todo, $_;
				}
				elsif ($$self{settings}{use_all_checkboxes} and /^\s*\[ \]/) {
					# checkbox
					push @todo, $_;
				}
			}
		}
	}

	# Filter out items flagged as DONE or with checked checkbox 
	# and determine prio and due date
	@todo = grep defined($_), map {
		$_ = '' if /(^|\s)DONE:?(\s|$)/ or /^\s*\[[*xX]\]/;
		s/^\s*\[ \]\s*//;
		my ($prio, @date) = (0);
		$prio = length($1) if s#(!+)##; # parse priority
		@date = Zim::Utils::parse_date($2)
			if s#(^|\s)(\d{1,2}/\d{1,2}(/\d{2,4})?)(\s|$)##;
		s/^\s*[\x{2022}\-\*]|\-\s*$//g; # remove bullets etc.
		s/^\s+|\s+$//g;
		($_ =~ /\S/) ? [$_, $prio, \@date] : undef;
	} grep /\S/, @todo;

	return @todo;
}

sub _plain {
	my $ref = shift;
	if    ($$ref[0] eq 'strike')   { return '' }
	elsif ($$ref[0] eq 'checkbox') {
		my $state = $$ref[1]{state};
		my $text = ($state == 1) ? '[*]' :
		           ($state == 2) ? '[x]' : '[ ]' ;
		return $text;
	}
	else {
		my $text = '';
		$text .= ref($_) ? _plain($_) : $_  # recurs
			for @$ref[2 .. $#$ref] ;
		return $text;
	}
}

1;

__END__

=back

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2007 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

