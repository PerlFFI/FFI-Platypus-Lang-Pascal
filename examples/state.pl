use strict;
use warnings;
use File::Basename qw(dirname);
use FFI::Platypus;

my $ffi = FFI::Platypus->new;
$ffi->lang('Pascal');
$ffi->lib(dirname(__FILE__) . '/libstate.so');

$ffi->attach(SetLastIdentifier => ['Integer']);
$ffi->attach(GetNextIdentifier => [] => 'Integer');

print GetNextIdentifier(), "\n";
print GetNextIdentifier(), "\n";

SetLastIdentifier(32766);
print GetNextIdentifier(), "\n";
print GetNextIdentifier(), "\n";

