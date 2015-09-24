#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

while (my $num = <DATA>) {
    chomp($num);
    if ($num % 2 == 0) {
        say "$num is even";
    }
    else {
        my $fac = 1;
        for (my $i = 1; $i <= $num; $i++) {
            $fac *= $i;
        }

        say "$num! = $fac";
    }
}

__DATA__
22
5
1
2
13
32
72
24
