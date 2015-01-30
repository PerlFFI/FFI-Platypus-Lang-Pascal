use strict;
use warnings;
use Test::More;
use FFI::CheckLib qw( find_lib );
use FFI::Platypus;

my $libtest = find_lib lib => 'test', libpath => 'libtest';
plan skip_all => 'test requires Free Pascal'
  unless $libtest;

plan tests => 2;

my $ffi = FFI::Platypus->new;
$ffi->lang('Pascal');
$ffi->lib($libtest);

$ffi->attach( add => ['Integer', 'Integer'] => 'Integer');

is add(1,2), 3, 'c_int_sum(1,2) = 3';

