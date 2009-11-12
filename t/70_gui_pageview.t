use Test::More;
use lib './t';
use env;

eval "
use Gtk2 '-init';
use Zim::GUI;
use Zim::GUI::PageView;
";
if ($@) {
	plan skip_all => 'No DISPLAY ?';
	exit;
}
else {
	plan tests => 10;
}

my $app = Mock::Object->new( # Mock object for Zim::GUI
	ISA => 'Zim::GUI::Component',
	ui => Gtk2::UIManager->new,
	statuss => Mock::Object->new,
	page => Mock::Object->new(
		resolve_file => sub { return 'resolved_'.$_[1] },
		relative_path => sub { return 'relative_'.$_[1] },
		parse_link => sub { return ('file', $_[1]) },
	),
);

my $pview = Zim::GUI::PageView->new(app => $app);
$$pview{app}{settings} = {
	use_autoselect => 1,
	follow_new_link => 0,
};

$pview->_init_buffer;
$$pview{buffer}->insert_at_cursor('foobar');
$pview->ApplyFormat('bold');
pcontains(['bold', {}, 'foobar'], 'ApplyFormat 1');

$pview->ApplyFormat('italic');
pcontains(['italic', {}, 'foobar'], 'ApplyFormat 2');

$pview->Undo; # undo apply italic
$pview->Undo; # undo delete tag
pcontains(['bold', {}, 'foobar'], 'Undo 1');
$pview->Redo; # redo delete tag
$pview->Redo; # redo apply italic
pcontains(['italic', {}, 'foobar'], 'Redo 1');

#$$pview{buffer}->place_cursor( $$pview{buffer}->get_iter_at_offset(0) );
#$pview->Delete for 1 .. 3;
#pcontains(['italic', {}, 'bar'], 'Delete 1');
#$pview->Undo for 1 .. 3;
#pcontains(['italic', {}, 'foobar'], 'Undo 2');
#$pview->Redo for 1 .. 3;
#pcontains(['italic', {}, 'bar'], 'Redo 2');

$pview->_init_buffer;
$$pview{buffer}->insert_at_cursor('foobar');
$pview->Link;
pcontains(['link', {to => 'foobar'}, 'foobar'], 'Link');

$$pview{buffer}->place_cursor( $$pview{buffer}->get_iter_at_offset(0) );
$pview->Delete for 1 .. 3;
pcontains(['link', {to => 'bar'}, 'bar'], 'Delete 2');
#$pview->Undo for 1 .. 3;
#pcontains(['link', {to => 'foobar'}, 'foobar'], 'Undo 3');
#$pview->Redo for 1 .. 3;
#pcontains(['link', {to => 'bar'}, 'bar'], 'Redo 3');

$pview->_init_buffer;
$pview->InsertLink('Foo', '', 'NO_ASK');
pcontains(['link',
	{to => 'relative_resolved_Foo'},
	'relative_resolved_Foo'], 'InsertLink 1');

$pview->_init_buffer;
$pview->InsertLink('Foo', 'Bar', 'NO_ASK');
pcontains(['link', {to => 'relative_resolved_Foo'}, 'Bar'], 'InsertLink 2');

$pview->_init_buffer;
$pview->InsertImage('./foo.jpg', 'NO_ASK');
pcontains(['image', {
		file => 'resolved_./foo.jpg',
		src  => './foo.jpg',
	}],
	'InsertImage 1');

$pview->_init_buffer;
$pview->InsertImage('./foo.jpg?width=20', 'NO_ASK');
pcontains(['image', {
		file => 'resolved_./foo.jpg',
		src  => './foo.jpg',
		width => 20
	}],
	'InsertImage 2');

# TODO InsertFromFile

# TODO AttachFile

exit;

sub pcontains {
	my ($snippet, $text) = @_;
	my $tree = $$pview{buffer}->get_parse_tree;
	#use Data::Dumper; warn Dumper $tree;
	contains($tree, $snippet, $text);
}

sub contains {
	# TODO deeper check?
	no warnings;
	my ($tree, $snippet, $text) = @_;
	my $type = $$snippet[0];
	my @candidates = grep {$$_[0] eq $type} @$tree[2 .. $#$tree];
	#use Data::Dumper; warn Dumper $candidates[0];
	is_deeply($candidates[0], $snippet, $text);
}

