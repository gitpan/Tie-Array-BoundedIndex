# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 6;
use Test::Exception;
use Tie::Array::BoundedIndex;

dies_ok { tie my @array, "Tie::Array::Bounded::Index" }
        "Croak with no bound specified";

my $obj;
lives_ok { $obj = tie my @array, "Tie::Array::BoundedIndex", upper => 42 }
         "Tied array okay";

isa_ok($obj, "Tie::Array::BoundedIndex");

throws_ok { tie my @array, "Tie::Array::BoundedIndex", upper => -1 }
          qr/must be integer/, "Non-integral bound fails";

throws_ok { tie my @array, "Tie::Array::BoundedIndex", frogs => 10 }
          qr/Illegal argument/, "Illegal argument fails";

throws_ok { tie my @array, "Tie::Array::BoundedIndex",
            lower => 2, upper => 1 }
          qr/Upper bound < lower/, "Wrong bound order fails";