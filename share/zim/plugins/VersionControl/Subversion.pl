use strict;

=head1 NAME

Svn support

=head1 VERSION

0.27

=head1 DESCRIPTION

Support for SVN repository.
See also L<Zim::FS::Subversion>

=head1 AUTHOR

Lubo Molent <lubomir.molent at gmail.com>
Jaap Karssenberg <pardus@cpan.org>

Copyright (c) 2007 Lubo Molent. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

my $app = Zim::GUI->current;

my $actions = __actions( q{
SvnCommit	gtk-apply	SVN commit	.	Commit notebook to SVN repository
SvnUpdate	gtk-refresh	SVN update	.	Update notebook from SVN repository
SvnCleanup	gtk-clear	SVN cleanup	.	Cleanup SVN working copy
} );

$app->add_actions($actions);

$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='ToolsMenu'>
			<separator/>
			<menuitem action='SvnCommit'/>
			<menuitem action='SvnUpdate'/>
			<menuitem action='SvnCleanup'/>
			<separator/>
		</menu>
	</menubar>
</ui> } );

$app->signal_connect(page_loaded => \&check_page_is_recent);

return 1;


## Signal handler

sub check_page_is_recent {
	# Check for new revision in SVN repository on page load
	# Do not die here but fail silently
	my $app = shift;
	my $page = $$app{page};
	my $dir = $$app{notebook}{vcs};
	return 0 unless $dir;

	# Get file path
	my $path = ($$page{source} and $$page{source}->can('path'))
		? $$page{source}->path : undef ;
		# TODO TODO needs proper interface
	return 0 unless defined $path;

	# Get URL and local revision
	my $url = undef;
	my $local_revision = 0;
	for (split /\n/, $dir->svn('info', $path)) {
		if    (s/^URL:\s+//)              { $url = $_            }
		elsif (s/^Last Changed Rev:\s+//) { $local_revision = $_ }
	}
	return 0 unless defined $url and $local_revision != 0;

	# Get revision in the repository
	my $revision = 0;
	for (split /\n/, $dir->svn('info', $url)) {
		if (s/^Last Changed Rev:\s+//) { $revision = $_ }
	}
	return 0 if $revision == 0;

	if ($local_revision < $revision) {
		warn "Local version: $local_revision, remote version: $revision\n";
		$app->error_dialog(
			__("This page was updated in the repository.\nPlease update your working copy (Tools -> SVN update).")); #. SVN warning
	}
}


## Menu items

sub SvnCommit { $_[0]->SaveVersion() }

sub SvnUpdate {
	my ($app, $dir) = ($_[0], $_[0]{notebook}{vcs});
	eval { $dir->svn('update') };
	if ($@) {
		$app->error_dialog(
			__("Failed update working copy.")."\n\n".$@, $@); #. Error in SVN update
	}
	else {
		$app->RBIndex();
		$app->Reload();
	}
}

sub SvnCleanup {
	my ($app, $dir) = ($_[0], $_[0]{notebook}{vcs});
	eval { $dir->svn('cleanup') };
	if ($@) {
		$app->error_dialog(
			__("Failed to cleanup SVN working copy.")."\n\n".$@, $@); # Error in SVN cleanup
	}
	else { $app->RBIndex() }
}

1;
