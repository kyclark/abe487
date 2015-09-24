#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

unless (@ARGV == 2) {
    die "Pleave provide 2 numbers.\n";
}

my ($n1, $n2) = @ARGV;

unless ($n1 >= 0 && $n2 >= 0) {
    die "Numbers must be positive.\n";
}

if ($n2 == 0) {
    die "Denominator cannot be zero.\n";
}

say "$n1 / $n2 = ", $n1/$n2;
