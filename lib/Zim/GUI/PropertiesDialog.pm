package Zim::GUI::PropertiesDialog;

use strict;
use Gtk2;
use Zim::Utils;
use Zim::GUI::Component;

our $VERSION = '0.26';
our @ISA = qw/Zim::GUI::Component/;

=head1 NAME

Zim::GUI::PropertiesDialog - dialog for zim

=head1 DESCRIPTION

This module contains the preferences dialog for zim.
It is autoloaded when needed.

=head1 METHODS

=over 4

=item C<show()>

Present the dialog.

=cut

sub show {
	my $self = shift;
	my $notebook = $$self{app}{notebook};
	
	my $dialog = Gtk2::Dialog->new(
		__("Properties"), $$self{app}{window}, #. dialog title
	       	[qw/destroy-with-parent no-separator/],
		'gtk-help'   => 'help',
		'gtk-cancel' => 'cancel',
		'gtk-ok'     => 'ok',
	);
	$dialog->set_resizable(0);
	
	my $tabs = Gtk2::Notebook->new;
	$dialog->vbox->add($tabs);
	
	## Notebook tab
	my $nb_config = $$notebook{config};
	my $dir = $$notebook{dir};
	my $config_rw = $$notebook{config_file}->writable;
	my ($nb_vbox, $nb_data) =
		$self->get_notebook_tab($nb_config, $dir, 0, $config_rw);
	$tabs->append_page($nb_vbox, __('Notebook')); #. tab label
	my $page_vbox = $self->get_page_tab;
	$tabs->append_page($page_vbox, __('Page')); #. tab label

	## Show it all
	$dialog->show_all;
	while ($_ = $dialog->run) {
		if ($_ eq 'help') {
			$$self{app}->ShowHelp(':usage:properties');
			next;
		}
		last unless $_ eq 'ok';
		
		$self->save_notebook_tab($nb_data, $nb_config);
		$notebook->save;
		$notebook->signal_emit('config_changed');
		last;
	}
	$dialog->destroy;
}

=item C<get_notebook_tab(CONFIG, DIR, DIR_EDITABLE)>

Returns a widget and a hash. The widget is the notebook tab for the
properties dialog. The hash is needed to save values later.
CONFIG is the config hash of a notebook.

DIR needs to be given separatly since it is not in the config.
DIR_EDITABLE determines if DIR will be a label or an entry.

=item C<save_notebook_tab(DATA, CONFIG, NOTEBOOK)>

Save values set by the user to the notebook config.
DATA is the hash returned byt C<get_notebook_tab()>.
CONFIG is the config hash of a notebook.

=cut


sub get_notebook_tab {
	# Don't trust $$self{app} to exist, we can be called from
	# NotebookDialog without the whole app running
	my ($self, $config, $dir, $dir_rw, $config_rw) = @_;
	my $vbox = Gtk2::VBox->new(0,5);
	$vbox->set_border_width(5);
	
	my @fields = qw/dir name home icon document_root/;
	my %data = (
		dir           => [__('Directory'),     'dir'    ], #. input
		name          => [__('Name'),          'string' ], #. input
		home          => [__('Home Page'),     'page'   ], #. input
		icon          => [__('Icon'),          'file'   ], #. input
		document_root => [__('Document Root'), 'dir'    ], #. input
	);
	push @{$data{$_}}, $$config{$_} for @fields; # set values
	$data{dir}[-1] = $dir;

	my ($table, $entries) = $self->new_form(\@fields, \%data);
	$_->set_sensitive($config_rw) for @$entries;
	$$entries[0]->set_sensitive($dir_rw && $config_rw);

	my $slowfs_box = Gtk2::CheckButton->new(
		__('Slow file system') ); #. check box
	$slowfs_box->set_active($$config{slow_fs});
	$slowfs_box->set_sensitive($config_rw);
	$table->attach_defaults($slowfs_box, 0,2, 5,6);
	
	my $version_box = Gtk2::CheckButton->new(
		__('Auto-save version on close') ); #. check box
	$version_box->set_active($$config{autosave_version});
	$version_box->set_sensitive($config_rw);
	$table->attach_defaults($version_box, 0,2, 6,7);

	$vbox->pack_start($table,0,1,0);

	my %widgets = (map {($fields[$_] => $$entries[$_])} 0 .. $#fields);
	$widgets{slow_fs} = $slowfs_box;
	$widgets{autosave_version} = $version_box;

	# if we change the dir, reload config data if possible
	$$entries[0]->signal_connect(changed => sub {
		my $dir = $$entries[0]->get_text;
		$dir = Zim::FS->abs_path($dir, $ENV{HOME});
		return unless -d $dir and Zim->is_notebook($dir);
		my $config = Zim->get_notebook_config($dir)->read(undef, 'Notebook');
		for (@fields) {
			next if $_ eq 'dir' or $_ eq 'slow_fs';
			$widgets{$_}->set_text($$config{$_});
		}
		$widgets{slow_fs}->set_active($$config{slow_fs});
	} ) if $dir_rw;

	return $vbox, \%widgets;
}

sub save_notebook_tab {
	# Don't trust $$self{app} to exist, we can be called from
	# NotebookDialog without the whole app running
	my ($self, $widgets, $config) = @_;
	
	my $dir = $$widgets{dir}->get_text;
	delete $$widgets{dir};

	for my $k (qw/slow_fs autosave_version/) {
		my $checkbox = delete $$widgets{$k};
		$$config{$k} = $checkbox->get_active || 0;
	}

	for my $k (keys %$widgets) {
		my $string = $$widgets{$k}->get_text;
		$string = Zim::FS->rel_path($string, $dir) || $string
			if $k eq 'icon';
		$$config{$k} = $string;
	}
}

=item C<get_page_tab()>

Returns a widget to fill the tab with page properties.

=cut

sub get_page_tab {
	my $self = shift;
	my $vbox = Gtk2::VBox->new;
	$vbox->set_border_width(5);
	return $vbox unless $$self{app}{page};

	my $table = Gtk2::Table->new(3, 2);
	$table->set_border_width(5);
	$table->set_row_spacings(5);
	$table->set_col_spacings(12);
	$vbox->pack_start($table, 0,0,0);

	my @fields = qw/Content-Type Creation-Date Modification-Date/;
		# Wiki-Format is not very interesting here
	my @strings = (
	  __('Source Format'),     #. label for page property Content-Type
	  __('Creation Date'),     #. label for page property Creation-Date
	  __('Modification Date'), #. label for page property Modification-Date
	);

	my $p = $$self{app}{page}{properties};
	for my $i (0 .. $#fields) {
		my $label = Gtk2::Label->new($strings[$i].': ');
		$label->set_alignment(0, 0.5);
		$table->attach_defaults($label, 0,1, $i,$i+1);
		my $value = Gtk2::Label->new($$p{$fields[$i]});
		$value->set_alignment(0, 0.5);
		$table->attach_defaults($value, 1,2, $i,$i+1);
	}

	return $vbox;
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

