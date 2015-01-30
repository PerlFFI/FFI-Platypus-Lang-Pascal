use strict;
use warnings;
use FFI::Platypus;

my $ffi = FFI::Platypus->new;
$ffi->lang('Pascal');
$ffi->lib('./add.so');

$ffi->attach(
  ['ADD_ADD$SMALLINT$SMALLINT$$SMALLINT' => 'add'] => ['Integer','Integer'] => 'Integer'
);

print add(1,2), "\n";
