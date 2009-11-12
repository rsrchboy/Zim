
use strict;
use Zim::GUI;
use Zim::Formats::Wiki;

my $app = Zim::GUI->current;

my $actions = __actions( q{
SortSelection	gtk-sort-descending	Sort Selecion	.	Sort selection
} );

$app->add_actions($actions);

$app->add_ui( q{
<ui>
	<menubar name='MenuBar'>
		<menu action='ToolsMenu'>
			<placeholder name='PluginActions'>
				<menuitem action='SortSelection'/>
			</placeholder>
		</menu>
	</menubar>
	<toolbar name='ToolBar'>
		<placeholder name='Tools'>
			<toolitem action='SortSelection'/>
		</placeholder>
	</toolbar>
</ui> } );

return 1;


sub SortSelection {
	my $textbuffer = $app->PageView->{buffer};
	my ($start, $end) = $textbuffer->get_selection_bounds;
	return unless $end and $end != $start;
	my $parsetree = $textbuffer->get_parse_tree($start, $end);

	# In order to sort the content we need to convert the parse tree
	# to wiki text because we can not walk the tree by line easily.
	my $page = $app->{page};
	my $buffer = buffer();
	Zim::Formats::Wiki->save_tree($buffer->open('w'), $parsetree, $page);
	my $wikitext = $buffer->read();
	$wikitext =~ s/^Content-Type.*?\n\n//s; # get rid of headers

	# Do the actual sorting - case insensitive
	my @lines = split /\n/, $wikitext;
	@lines = sort {lc($a) cmp lc($b)} @lines;
	$wikitext = join "\n", @lines;

	# Convert back to a parse tree
	$buffer = buffer(\$wikitext);
	$parsetree = Zim::Formats::Wiki->load_tree($buffer->open('r'), $page);
	
	# And replace the current selection
	my $offset = $start->get_offset;
	$textbuffer->delete_selection(1, 1);
	my $iter = $textbuffer->get_iter_at_offset($offset);
	$textbuffer->insert_blocks($iter, $parsetree);
}
