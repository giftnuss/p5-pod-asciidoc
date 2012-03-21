use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Pod::Asciidoc',
    license             => 'perl',
    dist_author         => 'Sebastian Knapp <rock@ccls-online.de>',
    dist_version        => '0.01',
    requires => {
        'perl' => '5.6.2',
        'Pod::Parser' => '0'
    },
    build_requires => {
        'Test::More' => 0,
	'IO::String' => 0,
    },
    add_to_cleanup      => [ 'Pod-Asciidoc-*' ],
    create_makefile_pl  => 'traditional',
    meta_add => {
        resources => {
            repository => 'git://github.com/giftnuss/p5-pod-asciidoc.git',
            homepage => 'http://github.com/giftnuss/p5-pod-asciidoc/tree/master'
        }
    }
);

$builder->create_build_script();
