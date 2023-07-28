use strict;
use warnings;
use File::Basename qw(dirname);
use FFI::Platypus;

my $ffi = FFI::Platypus->new;
$ffi->lang('Pascal');
$ffi->lib(dirname(__FILE__) . '/libarrays.so');

$ffi->attach(PrintStaticArr => ['Integer[3]']);
$ffi->attach(PrintDynamicArr => ['Integer[]', 'Integer']);

PrintStaticArr([1, 2, 3]);
PrintDynamicArr([1, 2, 3, 4], 4);

