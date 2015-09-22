#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV == 2) {
    die "Please provide exactly two numbers.\n";
}

my ($n1, $n2) = @ARGV;

print "$n1 + $n2 = ", $n1 + $n2, "\n";
