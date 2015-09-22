#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV == 2) {
    die "Please provide exactly two numbers.\n";
}

my ($i, $j) = @ARGV;

if ($i + $j == 0) {
    die "You are trying to trick me!\n";
}
else {
    printf "%.2f%%\n", $i/($i+$j) * 100;
}
