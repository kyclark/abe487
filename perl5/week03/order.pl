#!/usr/bin/env perl

use strict;
use warnings;

unless (@ARGV == 2) {
    die "Please provide exactly two strings.\n";
}

my ($s1, $s2) = @ARGV;

if ($s1 lt $s2) {
    print "Right order.\n";
}
else {
    print "Wrong order.\n";
}
