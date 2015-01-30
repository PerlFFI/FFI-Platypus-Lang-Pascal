use strict;
use warnings;
use Test::More;
use FFI::CheckLib qw( find_lib );
use FFI::Platypus;

my $libtest = find_lib lib => 'test', libpath => 'libtest';
plan skip_all => 'test requires Free Pascal'
  unless $libtest;

plan tests => 10;

my $ffi = FFI::Platypus->new;
$ffi->lang('Pascal');
$ffi->lib($libtest);

$ffi->attach( ['Add.Add(SmallInt,SmallInt):SmallInt'=>'add'] => ['Integer', 'Integer'] => 'Integer');

is add(1,2), 3, 'add(1,2) = 3';

$ffi->attach( ['Add.Add2' => 'add2'] => ['Integer', 'Integer'] => 'Integer' );

is add2(1,2), 3, 'add2(1,2) = 3';

my $ptrre = qr{^[0-9]+$};

my @ok = (
  'Add.NoArgs',
  'Add.NoArgs()',
  'Add.OneArg',
  'Add.OneArg(SmallInt)',
  'Add.F1(SmallInt)',
  'Add.F1(Real)',
);

like $ffi->find_symbol($_), $ptrre, $_ for @ok;

my @ambig = qw(
  Add.Add
  Add.F1
);

foreach my $ambig (@ambig)
{
  eval { $ffi->find_symbol($ambig) };
  isnt $@, '', "ambig $ambig";
  note $@ if $@;
}
