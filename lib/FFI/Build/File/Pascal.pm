package FFI::Build::File::Pascal;

use strict;
use warnings;
use 5.008004;
use base qw( FFI::Build::File::Base );
use File::Which ();
use Carp ();
use Path::Tiny ();
use File::chdir;
use FFI::CheckLib qw( find_lib_or_die );
use File::Copy qw( copy );

# ABSTRACT:
# VERSION

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

=cut

sub new
{
  my($class, $content, %config) = @_;

  my @fpc_flags;
  if(defined $config{fpc_flags})
  {
    if(ref $config{fpc_flags} eq 'ARRAY')
    {
      push @fpc_flags, @{ delete $config{fpc_flags} };
    }
    elsif(ref $config{fpc_flags} eq '')
    {
      push @fpc_flags, delete $config{fpc_flags};
    }
    else
    {
      Carp::croak("Unsupported fpc_flags");
    }
  }

  my $self = $class->SUPER::new($content, %config);

  $self->{fpc_flags} = \@fpc_flags;

  $self;
}

=head1 METHODS

=head2 build_item

=cut

sub build_item
{
  my($self) = @_;

  my $pas = Path::Tiny->new($self->path);

  local $CWD = $self->path->parent;
  print "+cd $CWD\n";

  my @cmd = ($self->fpc, $self->fpc_flags, $pas->basename);
  print "+@cmd\n";
  system @cmd;
  exit 2 if $?;

  my($dl) = find_lib_or_die(
    lib => '*',
    libpath => [$CWD],
    systempath => [],
  );

  Carp::croak("unable to find lib for $pas") unless $dl;

  if($self->build)
  {
    my $lib = $self->build->file;

    my $dir = Path::Tiny->new($lib)->parent;
    unless(-d $dir)
    {
      print "+mkdir $dir\n";
      $dir->mkpath;
    }

    $dl = Path::Tiny->new($dl)->relative($CWD);
    print "+cp $dl $lib\n";
    copy($dl, $lib) or die "Copy failed $!";

    print "+cd -\n";

    return $lib;
  }
  else
  {
    require FFI::Build::File::Library;
    print "+cd -\n";
    return FFI::Build::File::Library->new([$dl]);
  }
}

=head2 fpc

=cut

sub fpc
{
  my $fpc = File::Which::which('fpc');
  die "Free Pascal compiler not found" unless defined $fpc;
  $fpc;
}

=head2 fpc_flags

=cut

sub fpc_flags
{
  my($self) = @_;
  @{ $self->{fpc_flags} };
}

=head2 default_suffix

=cut

sub default_suffix
{
  return '.pas';
}

=head2 default_encoding

=cut

sub default_encoding
{
  return ':utf8';
}

=head2 accept_suffix

=cut

sub accept_suffix
{
  (qr/\.(pas|pp)$/)
}

1;
