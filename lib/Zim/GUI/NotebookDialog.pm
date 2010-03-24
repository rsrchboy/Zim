package Zim::GUI::NotebookDialog;

use strict;
use File::BaseDir 0.03 qw/config_home config_files data_files/;
use Zim;
use Zim::Utils;
use Zim::GUI::Component;
use Zim::GUI::PropertiesDialog;

our $VERSION = '0.29';
our @ISA = qw/Zim::GUI::Component/;

use constant {
	COL_NAME => 0,
	COL_OPEN => 1,
};

=head1 NAME

Zim::GUI::NotebookDialog - Chooser dialog with notebooks

=head1 DESCRIPTION

FIXME descriptve text

=head1 METHODS

=over 4

=item C<show()>

Construct a new dialog and show it.
This is used when the dialog is called in an existing zim instance.

=item C<run(USE_DAEMON)>

Construct a new dialog and run it modal. Returns notebook or undef.
The boolean USE_DAEMON detemines whether we query L<Zim::GUI::Daemon>
for open notebooks or not.

Use C<show()> instead of C<run()> when gtk main loop is already running.
Typically C<run()> is used when this dialog is run as a separate process 
or when no notebook has been opened yet.

=cut

sub show {
	my $self = shift;
	$$self{use_daemon} = !$$self{app}{no_daemon};
	$self->_init;
	$$self{dialog}->signal_connect(response => \&on_response, $self);
}

sub run {
	my $self = shift;
	$$self{use_daemon} = shift;
	
	$self->_init;
	$$self{dialog}->set_modal(1);
	$$self{app}{window} ||= $$self{dialog};
	
	$SIG{USR1} = sub { $$self{dialog}->present };
	
	Glib::IO->add_watch ( fileno(STDIN), ['in', 'hup'], sub {
		my ($fileno, $condition) = @_;
		return 0 if $condition eq 'hup'; # uninstall
		my $line = <STDIN>;
		$$self{dialog}->destroy if $line =~ /^Close FORCE/;
		return 1;
	} );
	
	my $notebook;
	while (my $re = $$self{dialog}->run) {
		last unless $re eq 'ok' or $re eq 'help';
		$notebook = on_response($$self{dialog}, $re, $self);
		last if defined $notebook;
	}
	$$self{dialog}->destroy;
	return $notebook;
}

sub _init {
	my $self = shift;

	my $dialog = Gtk2::Dialog->new(
		__("Open notebook"), undef, #. dialog title
	       	[qw/destroy-with-parent no-separator/],
		'gtk-help'   => 'help',
		'gtk-cancel' => 'cancel',
		'gtk-open'   => 'ok',
	);
	#$dialog->set_type_hint('utility');
	$dialog->set_default_size(500,350);
	$dialog->set_border_width(10);
	$dialog->set_icon(
		Gtk2::Gdk::Pixbuf->new_from_file($Zim::ICON) );
			# defined in Component.pm
			# do not use parent because we could run stand-alone
			# and we do not want to use custom icon here
	$dialog->set_default_response('ok');
	$dialog->vbox->set_spacing(5);

	# show some art work
	my $path = data_files('zim', 'globe_banner_small.png');
	my $image = Gtk2::Image->new_from_file($path);
	my $align = Gtk2::Alignment->new(0,0.5,0,0);
	$align->add($image);
	$dialog->vbox->pack_start($align, 0,0,0);
	
	my $hbox = Gtk2::HBox->new(0, 12);
	$dialog->vbox->add($hbox);
	
	# list with notebooks
	my $list = Gtk2::SimpleList->new(
		# COL_NAME, COL_OPEN
		__('Notebooks') => 'text', #. list header
		'_open_' => 'bool', # hidden column
	);
	$list->set_rules_hint(1);
	$list->set_reorderable(1);
	$list->get_selection->set_mode('browse');
	$list->get_column(COL_NAME)->set_sort_column_id(COL_NAME);
	$list->get_column(COL_OPEN)->set_visible(0);
	my ($cellr) = $list->get_column(0)->get_cell_renderers;
	#$cellr->set(style => 'italic');
	#$list->get_column(0)->add_attribute($cellr, style_set => 1);
	# Not sure why we need a data_func here, would expect to be
	# able to toggle italic using the style-set property, but that
	# does not seem to work.
	$list->get_column(0)->set_cell_data_func($cellr, sub {
		my ($col, $cellr, $model, $iter) = @_;
		my ($name, $open) = $model->get($iter, COL_NAME, COL_OPEN);
		$cellr->set(style => $open ? 'italic' : 'normal');
	} );
	$list->signal_connect(
		row_activated => sub { $dialog->response('ok') });
	$$self{list} = $list;
	
	my $scrollw = Gtk2::ScrolledWindow->new;
	$scrollw->set_policy('automatic', 'automatic');
	$scrollw->set_shadow_type('in');
	$scrollw->add($list);
	$hbox->add($scrollw);
	
	# load list with data
	my %notebooks;
	for (Zim->get_notebook_list) {
		my ($name, $dir) = @$_;
		$notebooks{$name} = $dir;
		next if $name =~ /^_/; # filter out _default_
		push @{$list->{data}}, [$name, 0];
	}
	$$self{notebooks} = \%notebooks;
	$self->_check_open;
	
	# connect this one after loading data
	$$self{_ri} =
	$list->get_model->signal_connect(
		# This signal is activated after re-ordering rows by DnD
		row_inserted => sub { 
			$self->_save_list;
			$self->_select_default;
			# combo will be reset after changing the list
		} );

	# add buttons for manipulating the list
	my $vbbox = Gtk2::VButtonBox->new();
	$hbox->pack_start($vbbox, 0,0,0);
	$vbbox->set_layout('start');
	
	my @buttons = map Gtk2::Button->new_from_stock($_),
		qw/gtk-add gtk-remove/;
	splice @buttons, 1, 0, $self->new_button(
		'gtk-properties', __('Cha_nge')); #. button
	$_->set_alignment(0.0, 0.5) for @buttons;
	$vbbox->add($_) for @buttons;
	
	my $modify = sub {
		# handler for new and edit buttons
		my $new = pop @_;
		my ($i, $name, $dir);
		if ($new) {
			$i = scalar @{$list->{data}}; # index after last row
		}
		else {
			($i)  = $list->get_selected_indices;
			return unless defined $i; # no item selected
			$name = $$list{data}[$i][COL_NAME];
			$dir  = $notebooks{$name};
		}

		# prompt for properties
		($name, $dir) = $self->prompt_notebook($new, $dir);
		return unless defined $name;
		$notebooks{$name} = $dir;
		$self->_update_list($i => [$name, 0]);
	};
	$buttons[0]->signal_connect(clicked => $modify, 1); # new
	$buttons[1]->signal_connect(clicked => $modify, 0); # edit
	$buttons[2]->signal_connect(clicked => sub {        # remove
		my ($i) = $list->get_selected_indices;
		return unless defined $i; # no item selected
		$self->_update_list($i => undef);
	} );

	# default notebook dropdown
	my $hbox1 = Gtk2::HBox->new;
	$dialog->vbox->pack_start($hbox1, 0,1,0);
	$hbox1->pack_start(
		Gtk2::Label->new(__('Default notebook').':'), 0,1,0 ); #. prompt
	my $combo = Gtk2::ComboBox->new_with_model( $list->get_model );
	my $ccellr = Gtk2::CellRendererText->new;
	$combo->pack_start($ccellr, 0);
	$combo->set_attributes($ccellr, 'text', 0);
	$hbox1->pack_start($combo, 0,1,0);
	$$self{combo} = $combo;

	my $clear_button = $self->new_small_button('gtk-clear');
	$hbox1->pack_start($clear_button, 0,1,0);

	$$self{_cc} =
	$combo->signal_connect(changed => sub {		# set default
		my $i = $combo->get_active;
		my $name = ($i >= 0)
			? $list->{data}[$i][COL_NAME]
			: undef ;
		warn "# Default set to: $name\n";
		$notebooks{_default_} = $name;
		$self->_save_list;
	} );
	$clear_button->signal_connect(clicked => sub {	# clear default
		$combo->set_active(-1);
	} );

	$self->_select_default;

	$dialog->show_all;
	$list->grab_focus;
	$$self{dialog} = $dialog;
}

sub _update_list {
	# update a record in the list, save and update state
	my ($self, $i, $data) = @_; # data can be undef for remove
	my $list = $$self{list};
	my $combo = $$self{combo};

	$list->get_model->signal_handler_block($$self{_ri}); # row_inserted
	$combo->signal_handler_block($$self{_cc}); # changed
	splice @{$$list{data}}, $i, 1, $data;
	$self->_save_list;
	$self->_check_open;
	$list->select($i) if defined $data;
	$list->get_model->signal_handler_unblock($$self{_ri}); # row_inserted
	$combo->signal_handler_unblock($$self{_cc}); # changed

	$self->_select_default; # combo will be reset after changing the list
}

sub _check_open {
	# ask the daemon which notebooks are openend and mark them in the list
	my $self = shift;
	return unless $$self{use_daemon};
	my ($list, $notebooks) = @$self{'list', 'notebooks'};
	my @dirs = map $$_[1], Zim::GUI::Daemon->list;
	@dirs = map {s/\/*$//; $_} @dirs;
	@{$$list{data}} = map {
		my $name = $$_[COL_NAME];
		my $dir = Zim::FS->abs_path($$notebooks{$name}, $ENV{HOME});
		$dir =~ s/\/*$//;
		my $open = (grep {$_ eq $dir} @dirs) ? 1 : 0 ;
		[$name => $open];
	} @{$$list{data}};
}

sub _save_list {
	# write list to config file
	my $self = shift;
	my @notebooks =
		( ['_default_' => $$self{notebooks}{_default_}] );
	push @notebooks,
		map [$_ => $$self{notebooks}{$_}], # [name => dir]
		map $$_[COL_NAME], @{$$self{list}{data}};
	Zim->set_notebook_list(@notebooks);
}

sub _select_default {
	# determine default and set the dropdown accordingly
	my $self = shift;
	my $default = $$self{notebooks}{_default_};
	my $notebooks = $$self{notebooks};
	my $combo = $$self{combo};

	if ($default =~ /[\\\/]/) {
		# dir name, lookup in notebook hash
		($default) = grep {$$notebooks{$_} eq $default}
		             grep {$_ !~ /^_/} keys %$notebooks ;
	}
	elsif (! $$notebooks{$default}) {
		# name does not exist - check case insensitive
		($default) = grep {lc($_) eq lc($default)} keys %$notebooks;
	}

	$combo->signal_handler_block($$self{_cc}); # changed
	if (defined $default) {
		# find the correct row in the model and select it
		my $list = $$self{list};
		my ($i) = grep { $$list{data}[$_][COL_NAME] eq $default }
			0 .. $#{$list->{data}} ;
		$combo->set_active($i) if defined $i;
	}
	else {
		# clear selected
		$combo->set_active(-1);
	}
	$combo->signal_handler_unblock($$self{_cc}); # changed
}

sub on_response {
	my $self = pop;
	my ($dialog, $response) = @_;
	my $list = $$self{list};
	my $notebooks = $$self{notebooks};
		
	if ($response eq 'help') {
		return $self->ShowHelp(':usage:notebooks');
	}
	elsif ($response eq 'ok') {
		# Open selected notebook
		my ($i) = (@{$list->{data}} == 1)
			? (0) : ($list->get_selected_indices);
		unless (defined $i) {
			$self->error_dialog(
				__('Please select a notebook first') ); #. error
			return undef;
		}

		my $name = $$list{data}[$i][COL_NAME];
		my $path = Zim::FS->abs_path($$notebooks{$name}, $ENV{HOME});
		#unless (-d $path) {
		#	$self->error_dialog(
		#	__("No such directory: {name}", name => $path) #. error
		#	);
		#	return undef;
		#}

		if ($dialog->get_modal) {
			# probably called by run()
			return $path;
		}
		else {
			# probably called by show()
			$$self{app}->OpenNotebook($path);
			$dialog->destroy;
		}
	}
	else { $dialog->destroy }
}

=item C<prompt_notebook(NEW, DIR)>

NEW is a boolean, DIR gives the location of the notebook.

=cut

sub prompt_notebook {
	my ($self, $new, $dir, $name) = @_;
	# FIXME: add a "help" button - link to :usage:properties ?

	my ($prompt) = $self->new_prompt(
		( $new ? __('New notebook')     #. dialog title
		       : __('Edit notebook') ), #. dialog title
		[], {}, undef, undef,
		'<i>'.__("Please give at least a directory to store your pages.\nFor a new notebook this should be an empty directory.\nFor example a \"Notes\" directory in your home dir.").'</i>' 
	);
	
	$dir ||= '~/Notes';
	my $file = Zim->get_notebook_config($dir);
	my $config = (defined $file and $file->exists)
		? $file->read(undef, 'Notebook')
		: { # defaults - mainly for first usage
			name => 'Notes',
			document_root => '~/Documents',
			home => ':Home',
		} ;
	
	my $properties = Zim::GUI::PropertiesDialog->new(app => $$self{app});
	my ($nb_vbox, $nb_data) =
		$properties->get_notebook_tab($config, $dir, 1, 1);
	$nb_vbox->show_all;
	$prompt->vbox->add($nb_vbox);

	while (my $r = $prompt->run) {
		if ($r eq 'help') {
			die 'TODO';
			next;
		}
		elsif ($r eq 'ok') {
			$name = $$nb_data{name}->get_text;
			$dir = $$nb_data{dir}->get_text;
			$prompt->destroy;

			$dir = Zim::FS->abs_path($dir, $ENV{HOME});
			return undef unless $dir =~ /\S/;
			
			$file = Zim->get_notebook_config($dir);
			$properties->save_notebook_tab($nb_data, $config);
			$file->write($config, 'Notebook')
				if defined $file;
			
			$dir =~ s/\Q$ENV{HOME}\E\/*/~\//;
			unless ($name =~ /\S/) {
				$name = $dir;
				$name =~ s/.*[\/\\]//;
			}
			return ($name, $dir);
		}
		else {
			$prompt->destroy;
			return undef;
		}
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

