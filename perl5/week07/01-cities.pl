#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use Data::Dumper;

my %cities = (
    Jackson    => 'MS',
    Denton     => 'TX',
    Cincinnati => 'OH',
    Boston     => 'MA', 
    Dixon      => 'NM',
    Tucson     => 'AZ',
);

say Dumper(\%cities);

my $i;
for my $city (sort keys %cities) {
    printf "%s: %s, %s\n", ++$i, $city, $cities{ $city };
}
