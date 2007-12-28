# -*- perl -*-

use strict;
use warnings;
use Test::More tests => 2;
use Tie::Array::BoundedIndex;

SKIP:
{
  eval "require $_ and $_->import" or skip "$_ not installed", 2
    for qw(Attribute::Handlers Test::Exception);

  dies_ok { my @x : Bounded(foo => 42) } "Illegal arguments exception";

  my @x : Bounded(upper => 5);
  @x = (0..5);
  throws_ok { push @x, "too big" } qr/out of range/, "Push exception";
}
