#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

@ARGV or die "Please provide a sequence.\n";

for my $seq (@ARGV) {
    my @nuc = split //, lc $seq;
    my $gc  = scalar(grep { /[gc]/ } @nuc);

    say "-------";
    say "Seq   : $seq";
    say "Length: ", length($seq);
    say "#GC   : $gc";
    say "%GC   : ", 100 * $gc / length($seq);
}
