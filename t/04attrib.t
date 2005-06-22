# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Tie::Array::BoundedIndex;

SKIP:
{
  skip "Attribute::Handlers not installed", 2
    unless eval "require Attribute::Handlers";

  dies_ok { my @x : Bounded(foo => 42) } "Illegal arguments exception";

  my @x : Bounded(upper => 5);
  @x = (0..5);
  throws_ok { push @x, "too big" } qr/out of range/, "Push exception";
}
