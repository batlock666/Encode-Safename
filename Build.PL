use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Encode::Safename',
    license             => 'perl',
    dist_author         => q{Bert Vanderbauwhede <batlock666@gmail.com>},
    dist_version_from   => 'lib/Encode/Safename.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Encode-Safename-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
