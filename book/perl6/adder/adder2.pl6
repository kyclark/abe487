#!/usr/bin/env perl6

sub MAIN (Numeric $a!, Numeric $b!) { put $a + $b }

sub USAGE {
    note sprintf "  %s <Numeric> <Numeric>", $*SPEC.basename($*PROGRAM-NAME);
}
