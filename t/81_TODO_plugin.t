use Test::More;
use lib './t';
use env;

eval "
use Gtk2 '-init';
use Zim;
use Zim::GUI::TODOListDialog;
";
if ($@) {
	plan skip_all => 'No DISPLAY ?';
	exit;
}
else {
	plan tests => 3;
}

# Make sure to use get_value() instead of get(), for some releases
# of gtk+/Gtk2 TreeModelSort does not support get()

my $root = File::Spec->rel2abs( File::Spec->catdir(qw/t notebook/) );

my $tree = ['Page', {},
	['head1', {}, 'TODOList 1'],
	[ 'Para', {},
		"Some sentence containing the word TODO in the middle\n" .
		"foo\nTODO: fix item 1\nbar\nTODO item 2\n" .
		"* fix item 3 - TODO\n"
	],
	[ 'Para', {},
		"TODO:\n" .
		"* fix item 4\n" .
		"* fix item 5\n" .
		"* fix item 6\n" 
	],
	[ 'Para', {},
		"TODO: important item !\n" .
		"TODO: very important item !!\n"
	],
	['Verbatim', {}, 'TODO: this is an example in verbatim']
];

my @list = (
	['fix item 1', 0, []],
	['item 2', 0, []],
	['fix item 3', 0, []],
	['fix item 4', 0, []],
	['fix item 5', 0, []],
	['fix item 6', 0, []],
	['important item', 1, []],
	['very important item', 2, []],
);

my @todo = Zim::GUI::TODOListDialog::parse_tree(
		{settings => {tags => 'TODO,FIXME'}}, $tree);

#use Data::Dumper; print Dumper \@todo;
is_deeply(\@todo, \@list, 'Parsing TODO items works');

my $app = Mock::Object->new( # Mock object for Zim::GUI
	notebook => Zim->new(dir => $root),
	SaveIfModified => sub { 1 },
);
my $dialog = Zim::GUI::TODOListDialog->new(app => $app);
$dialog->reload;

my @data;
$$dialog{list}->foreach( sub {
	my ($model, undef, $iter) = @_;
	push @data, [ $model->get_value($iter) ];
	0; # keep going
} );
#$Data::Dumper::Indent = 0;
#use Data::Dumper; print Dumper \@data;

is_deeply(
	\@data,
	[
		[1,2,'test 123 test','',':TODOList:bar'],
		[1,1,'foo','',':TODOList:bar'],
		[1,1,'bar','',':TODOList:bar'],
		[1,0,'baz','',':TODOList:bar'],
		[1,3,'yep','2009-07-30',':TODOList:bar'],
		[1,3,'fix 1','',':TODOList:foo'],
		[1,2,'fix 2','2008-03-24',':TODOList:foo'],
		[1,1,'fix 3','',':TODOList:foo'],
		[1,1,'another fix  reported 24.3.09','2009-07-30',':TODOList:foo'],
	],
	'Real list contents correct'
);

@data = ();
$$dialog{filter_entry}->set_text('foo');
$$dialog{filter_entry}->activate;
# get filtered and sorted model here
$$dialog{widget}->get_model->foreach( sub {
	my ($model, undef, $iter) = @_;
	push @data, [ $model->get_value($iter) ];
	0; # keep going
} );
#$Data::Dumper::Indent = 0;
#use Data::Dumper; print Dumper \@data;

is_deeply(
	\@data,
	[
		[1,3,'fix 1','',':TODOList:foo'],
		[1,2,'fix 2','2008-03-24',':TODOList:foo'],
		[1,1,'foo','',':TODOList:bar'],
		[1,1,'fix 3','',':TODOList:foo'],
		[1,1,'another fix  reported 24.3.09','2009-07-30',':TODOList:foo']
	],
	'Real list contents correct with filter'
);

