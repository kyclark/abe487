#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

@ARGV or die "Please provide a list of numbers.\n";

my (@odds, @evens);
for my $n (@ARGV) {
    if ($n % 2 == 0) {
        push @evens, $n;
    }
    else {
        push @odds, $n;
    }
}

say "sum evens = ", add(@evens);
say "sum odds = ", add(@odds);

sub add {
    my $t = 0;
    map { $t += $_ } @_;
    return $t;
}
