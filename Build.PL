use Module::Build;
# See perldoc Module::Build for details of how this works

Module::Build->new
    ( module_name     => 'Tie::Array::BoundedIndex',
      license         => 'perl',
      dist_version_from => 'lib/Tie/Array/BoundedIndex.pm',
    )->create_build_script;
