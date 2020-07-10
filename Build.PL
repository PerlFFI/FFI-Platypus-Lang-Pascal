BEGIN {
  unless(eval q{ use 5.008001; 1 })
  {
    print "Perl 5.008001 or better required\n";
    exit;
  }
  my %missing = map {
    eval qq{ require $_ };
    $@ ? ($_=>1) : ()
  } qw( Env File::Spec Carp );
  if(%missing)
  {
    print "Your Perl is missing core modules: @{[ sort keys %missing ]}\n";
    print "\n";
    print "Ideally if you are using the system Perl you can install the appropriate\n";
    print "package which includes the core Perl modules.  On at least some versions\n";
    print "of Fedora Linux, for example, this is the `perl-core` package.\n";
    print "\n";
    print " \% dnf install perl-core\n";
    print "\n";
    print "If you really want to install core modules from CPAN, then you can use cpanm:\n";
    print "\n";
    print " \% cpanm @{[ sort keys %missing ]}\n";
    exit;
  }
}
use strict;
use warnings;
use lib 'inc';
use lib 'lib';
use My::ModuleBuild;
use Env qw( @PATH );
use File::Spec;
use File::Which qw( which );

unless(which('fpc'))
{
  print "Unable to find Free Pascal.  Please make sure it is in the PATH.\n";
  print "You should still be able to use pre-compiled Free Pascal dynamic libs.\n";
}

my $builder = My::ModuleBuild->new(
  module_name   => 'FFI::Platypus::Lang::Pascal',
  dist_abstract => 'Documentation and tools for using Platypus with the Free Pascal '.
                   'programming language',
  dist_author   => [ 'Graham Ollis <plicease@cpan.org>' ],
  license       => 'perl',
  configure_requires => {
    'Module::Build'              => 0.38,
    'Module::Build::FFI'         => 0.19,
    'Module::Build::FFI::Pascal' => 0.49,
    'File::Which'                => 0,
  },
  build_requires => {
    'Module::Build'      => 0.38,
    'Module::Build::FFI' => 0.19,
    'Module::Build::FFI::Pascal' => 0.49,
  },
  test_requires => {
    'Test2::V0' => 0,
  },
  requires => {
    'perl',               => '5.008001',
    'FFI::Platypus'       => '0.19',
    'FFI::ExtractSymbols' => 0,
    'File::Which'         => 0,
    'Path::Tiny'          => 0,
    'File::chdir'         => 0,
    'FFI::CheckLib' => 0,
  },
  meta_merge => {
    resources  => {
      repository => "http://github.com/PerlFFI/FFI-Platypus-Lang-Pascal",
      bugtracker => "http://github.com/PerlFFI/FFI-Platypus-Lang-Pascal/issues",
      x_IRC => "irc://irc.perl.org/#native",
    },
    no_index => {
      directory => [ 'examples' ],
    },
  },
  ffi_libtest_dir => 't/ffi',
);

$builder->add_to_cleanup(
  '*.bak',
  '*.ppu',
  'examples/*.o',
  'examples/*.so',
  'examples/*.ppu',
  'examples/*.ppl',
  't/ffi/*.o',
  't/ffi/*.so',
  't/ffi/*.ppu',
  't/ffi/*.ppl',
  'FFI-Platypus-Lang-Pascal-*',
);

$builder->create_build_script;
