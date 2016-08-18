#!/usr/bin/env perl6

sub MAIN (Int $a!, Int $b!) { put $a + $b }

sub USAGE {
    printf "  %s <Int> <Int>\n", $*SPEC.basename($*PROGRAM-NAME);
}
