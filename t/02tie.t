# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 7;
use Tie::Array::BoundedIndex;

SKIP: {
  eval "use Test::Exception" or skip "Test::Exception not installed", 6;

  dies_ok { tie my @array, "Tie::Array::Bounded::Index" }
            "Croak with no bound specified";

  lives_ok { tie my @array, "Tie::Array::BoundedIndex", upper => 42 }
             "Tied array okay";

  throws_ok { tie my @array, "Tie::Array::BoundedIndex", upper => -1 }
              qr/must be integer/, "Non-integral bound fails";

  throws_ok { tie my @array, "Tie::Array::BoundedIndex", frogs => 10 }
              qr/Illegal argument/, "Illegal argument fails";

  throws_ok { tie my @array, "Tie::Array::BoundedIndex",
              lower => 2, upper => 1 }
            qr/Upper bound < lower/, "Wrong bound order fails";

  lives_ok { tie my @array, "Tie::Array::BoundedIndex", upper => 0 }
             "Upper limit can be 0";
}

my $obj = tie my @array, "Tie::Array::BoundedIndex", upper => 42;
isa_ok($obj, "Tie::Array::BoundedIndex");
