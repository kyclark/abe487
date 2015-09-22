#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

my $max = shift || 2;
my @strings;

for my $i (1..$max) {
    print "Enter string $i: ";
    chomp(my $str = <STDIN>);
    push @strings, $str;
}

my $same = 1;
my $last = '';
for my $s (@strings) {
    $last ||= $s;
    if ($s ne $last) {
        $same = 0;
    }

    last unless $same;
}

printf "%s\n", $same ? 'same' : 'different';
