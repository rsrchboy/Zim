use inc::Module::Install;

name     'Zim';
all_from 'lib/Zim.pm';
#author   q{Chris Weyl <cweyl@alumni.drew.edu>};
license  'perl';

requires 'Moose';
requires 'Readonly';
requires 
        'perl'           => '5.8.0',
        'Gtk2'           => '1.040',
        # Older doesn't support Gtk2::UIManager I think
        'POSIX'          => 0,
        'IO::File'       => 0,
        'File::Spec'     => 0,
        'File::Copy'     => 0,
        'File::BaseDir'  => 0.03,
        'File::MimeInfo' => '0.12',
        'File::DesktopEntry' => 0.03,
        'Encode'         => 0,
    ;

recommends 
        'Gtk2::TrayIcon' => 0,
            # This recommendation is removed on the
            # fly when gtk+ >= 2.10 is detected because
            # in that case we can use Gtk2::StatusIcon
        'Gtk2::Spell'    => 0,
    ;

build_requires 'File::Path';

test_requires 'Test::More';

author_tests;
auto_install;
auto_provides;

WriteAll;
