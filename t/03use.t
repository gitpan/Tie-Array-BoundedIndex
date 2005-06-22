# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 26;
use Test::Exception;
use Tie::Array::BoundedIndex;

my $RANGE_EXCEP = qr/out of range/;
my @array;
tie @array, 'Tie::Array::BoundedIndex', upper => 5;

lives_ok { $array[0] = 42 } "Store works";

is($array[0], 42, "Fetch works");

throws_ok { $array[6] = "dog" } $RANGE_EXCEP,
  "Bounds exception";

is_deeply(\@array, [ 42 ], "Array contents correct");

lives_ok { push @array, 17 } "Push works";

is($array[1], 17, "Second array element correct");

lives_ok { push @array, 2, 3 } "Push multiple elements works";

lives_ok { $array[-1] = 4 } "Negative index works";

is_deeply(\@array, [ 42, 17, 2, 4 ], "Array contents correct");

lives_ok { splice(@array, 4, 0, qw(apple banana)) } "Splice works";

is_deeply(\@array, [ 42, 17, 2, 4, 'apple', 'banana' ],
	  "Array contents correct");

throws_ok { push @array, "excessive" } $RANGE_EXCEP,
  "Push bounds exception";

is(scalar @array, 6, "Size of array correct");

throws_ok { splice(@array, 6, 1, "still excessive") } $RANGE_EXCEP,
  "Splice bounds exception";

tie @array, "Tie::Array::BoundedIndex", lower => 3, upper => 6;

throws_ok { $array[1] = "too small" } $RANGE_EXCEP,
  "Lower bound check failure";

lives_ok { @array[3..6] = 3..6 } "Slice assignment works";

throws_ok { push @array, "too big" } $RANGE_EXCEP,
  "Push bounds exception";

throws_ok { unshift @array, "too much" } $RANGE_EXCEP,
  "Unshift bounds exception";

is(shift(@array), 3, "shift works");

is_deeply([ @array[3..5] ], [ 4..6 ], "Array contents correct");

is_deeply([ splice(@array, 3, 3) ], [ 4..6 ], "Splice result correct");

throws_ok { splice(@array, 3, 1, 3..7) } $RANGE_EXCEP,
  "Splice bounds exception";

is(0, scalar(@array), "Array emptied");

is(undef, shift(@array), "Shift on empty array correct");

tie @array, "Tie::Array::BoundedIndex", upper => 0;

lives_ok { $array[0] = 42 } "Zero bound array store okay";

throws_ok { $array[1] = 17 } $RANGE_EXCEP, "Zero bounds array exception";
