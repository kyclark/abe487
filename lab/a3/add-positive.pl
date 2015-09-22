#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV == 2) {
    die "Please provide exactly two numbers.\n";
}

my ($n1, $n2) = @ARGV;

unless ($n1 >= 0 && $n2 >= 0) {
    die "Please provide only positive numbers.\n";
}

print "$n1 + $n2 = ", $n1 + $n2, "\n";
