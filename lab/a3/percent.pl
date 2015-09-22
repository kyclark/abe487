#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

unless (@ARGV == 2) {
    die "Please provide exactly two numbers.\n";
}

my ($i, $j) = @ARGV;

if ($i + $j == 0) {
    die "You are trying to trick me!\n";
}
else {
    say $i/($i+$j) * 100, '%';
}
