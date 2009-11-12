use strict;
use File::Spec;
use Zim::Utils;
use Zim::Store::Files;

=head1 NAME

PrintToBrowser

=head1 VERSION

0.24

=head1 DESCRIPTION

Allows zim to "print" to the browser.
Inteded as temporary fix until real printing support is implemented.

=head1 AUTHOR

Jaap Karssenberg (Pardus) E<lt>pardus@cpan.orgE<gt>

Copyright (c) 2006 Jaap G Karssenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

my $app = Zim::GUI->current;

my $actions = __actions( q{
TmpPrint	gtk-print	Print to Browser	<Ctrl>P	Print to browser
} );

$app->add_actions($actions);

$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='FileMenu'>
			<placeholder name='PrintActions'>
				<menuitem action='TmpPrint'/>
			</placeholder>
		</menu>
	</menubar>
</ui> } );

return 1;


sub TmpPrint {
	warn "No real printing, tmp solution\n";
	eval "use Zim::Template"; die $@ if $@;

	$app->SaveIfModified;

	# Export page to html
	my $file = Zim::FS->tmp_file("PrintToBrowser.html");

	my $exporter = Zim::Store::Files->new(dir => File::Spec->tmpdir);
	my $template = Zim::Formats->lookup_template('html', 'Print');
	return $app->error_dialog("Could not find template for PrintToBrowser")
		unless defined $template;
	$exporter->{_template} = Zim::Template->new($template);
	#warn "TEMPLATE: $$exporter{_template}\n";
	my ($rep, $page) = @{$app}{'notebook', 'page'};
	my $tmp = Zim::Page->new($exporter, $page->name);
	$tmp->set_source($file);
	$tmp->set_format('html');
	$tmp->clone($page, media => 'none');
	warn "# Exported to $file\n";

	# Exec Browser
	$app->open_url($file->uri);
}
