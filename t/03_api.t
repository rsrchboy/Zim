require Test::Simple;
require 't/env.pm';
use strict;

my %API = (
	read_pages => {
		modules => [qw/Zim Zim::Selection/],
		methods => [qw/
			list_pages
			resolve_name resolve_page get_page
		/],
		#get_selection search
	},
	write_pages => {
		modules => [qw/Zim Zim::Store Zim::Store::Files/],
		methods => [qw/copy_page move_page delete_page/],
	},
	documents => {
		modules => [qw/Zim Zim::Store Zim::Store::Files/],
		methods => [qw/document_root document_dir resolve_file store_file relative_path/],
	},
	documents_page => {
		modules => [qw/Zim::Page/],
		methods => [qw/document_dir resolve_file store_file relative_path/],
	},
	versioned_dir => {
		modules => [qw/Zim::FS::Bazaar Zim::FS::Subversion/],
		methods => [qw/init commit revert status list_versions cat_version diff annotate/],
	},
);

open LIST, 'MANIFEST' or die $!;
while (<LIST>) {
	chomp;
	s#^lib/## or next;
	s#\.\w+##;
	s#/#::#g;
	push @{$API{read_pages}{modules}}, $_
		if m#^Zim::Store#;
}
close LIST;

my $t = 0;
$t += scalar @{$_->{modules}} for values %API;
Test::Simple->import(tests => $t);

for my $api (keys %API) {
	my @m = @{$API{$api}{methods}};
	for my $mod (@{$API{$api}{modules}}) {
		eval "require $mod"; die $@ if $@;
		my $report = '';
		for my $m (@m) {
			$report .= "#\tFailed $m\(\)\n" unless $mod->can($m);
		}
		warn "# $mod fails '$api' API\n", $report if length $report;
		ok($report eq '', "$mod supports '$api' API");
	}
}

