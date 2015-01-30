package Module::Build::FFI::Pascal;

use strict;
use warnings;
use Config;
use File::Glob qw( bsd_glob );
use File::Which qw( which );
use File::chdir;
use File::Copy qw( move );
use base qw( Module::Build::FFI );

=head1 NAME

Module::Build::FFI::Pascal - Build Perl extensions in Free Pascal with FFI

=head1 DESCRIPTION

L<Module::Build::FFI> variant for writing Perl extensions in Pascal wiht 
FFI (sans XS).

=head1 BASE CLASS

All methods, properties and actions are inherited from:

L<Module::Build::FFI>

=head1 PROPERTIES

=over 4

=item ffi_pascal_extra_compiler_flags

Extra compiler flags to be passed to C<fpc>.

Must be a array reference.

=item ffi_pascal_extra_linker_flags

Extra linker flags to be passed to C<ppumove>.

Must be a array reference.

=back

=cut

__PACKAGE__->add_property( ffi_pascal_extra_compiler_flags =>
  default => [],
);

__PACKAGE__->add_property( ffi_pascal_extra_linker_flags =>
  default => [],
);

=head1 BASE CLASS

=over

=item L<Module::Build::FFI>

=back

=head1 METHODS

=head2 ffi_have_compiler

 my $has_compiler = $mb->ffi_have_compiler;

Returns true if Free Pascal is available.

=cut

sub ffi_have_compiler
{
  my($self) = @_;
  
  my $fpc = which('fpc');
  my $ppumove = which('ppumove');
  
  return (!!$fpc) && (!!$ppumove);
}

=head2 ffi_build_dynamic_lib

 my $dll_path = $mb->ffi_build_dynamic_lib($src_dir, $name, $target_dir);
 my $dll_path = $mb->ffi_build_dynamic_lib($src_dir, $name);

Compiles the Pascal source in the C<$src_dir> and link it into a dynamic
library with base name of C<$name.$Config{dlexe}>.  If C<$target_dir> is
specified then the dynamic library will be delivered into that directory.

=cut

sub ffi_build_dynamic_lib
{
  my($self, $src_dir, $name, $target_dir) = @_;

  do {
    local $CWD = $src_dir;
    print "cd $CWD\n";
  
    $target_dir = $src_dir unless defined $target_dir;
    my @sources = bsd_glob("*.pas");
  
    return unless @sources;
  
    my $fpc = which('fpc');
    my $ppumove = which('ppumove');

    my @compiler_flags;
    my @linker_flags;

    # TODO: OSX should not do this for 32bit Perl
    # TODO: OSX make a universal binary if possible?
    push @compiler_flags, '-Px86_64' if $^O eq 'darwin';

    my @ppu;

    foreach my $src (@sources)
    {
      my @cmd = (
        $fpc,
        @compiler_flags,
        @{ $self->ffi_pascal_extra_compiler_flags },
        $src
      );
    
      print "@cmd\n";
      system @cmd;
      exit 2 if $?;
    
      my $ppu = $src;
      $ppu =~ s{\.pas$}{.ppu};
    
      unless(-r $ppu)
      {
        print STDERR "unable to find $ppu after compile\n";
        exit 2;
      }
    
      push @ppu, $ppu;
    }

    my @cmd;

    if($^O eq 'darwin')
    {
      my @obj = map { s/\.ppu/\.o/; $_ } @ppu;
      @cmd = (
        'ld',
        $Config{dlext} eq 'bundle' ? '-bundle' : '-dylib',
        '-o' => "libmbFFIPlatypusPascal.$Config{dlext}",
        @obj,
      );
    }
    else
    {
      @cmd = (
        $ppumove,
        @linker_flags,
        @{ $self->ffi_pascal_extra_linker_flags },
        -o => 'mbFFIPlatypusPascal',
        -e => 'ppl',
        @ppu,
      );
    }

    print "@cmd\n";
    system @cmd;
    exit 2 if $?;
  };
  
  print "cd $CWD\n";
  
  my($from) = bsd_glob("$src_dir/*mbFFIPlatypusPascal*");
  
  unless(defined $from)
  {
    print STDERR "unable to find shared library\n";
    exit 2;
  }
  
  print "chmod 0755 $from\n";
  chmod 0755, $from;
  
  my $dll = File::Spec->catfile($target_dir, "$name.$Config{dlext}");
  
  print "mv $from $dll\n";
  move($from => $dll) || do {
    print "error copying file $!";
    exit 2;
  };
  
  $dll;
}

1;

=head1 EXAMPLES

TODO

=head1 SUPPORT

If something does not work as advertised, or the way that you think it
should, or if you have a feature request, please open an issue on this
project's GitHub issue tracker:

L<https://github.com/plicease/FFI-Platypus-Lang-Pascal/issues>

=head1 CONTRIBUTING

If you have implemented a new feature or fixed a bug then you may make a
pull reequest on this project's GitHub repository:

L<https://github.com/plicease/FFI-Platypus-Lang-Pascal/issues>

Caution: if you do this too frequently I may nominate you as the new
maintainer.  Extreme caution: if you like that sort of thing.

=head1 SEE ALSO

=over 4

=item L<FFI::Platypus>

The Core Platypus documentation.

=item L<Module::Build::FFI>

General MB class for FFI / Platypus.

=back

=head1 AUTHOR

Graham Ollis E<lt>plicease@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

