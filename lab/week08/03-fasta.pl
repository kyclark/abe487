#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

my $file = shift or die "Please provide a FASTA file.\n";
open my $fh, '<', $file;

my $i = 0;
while (<$fh>) {
    if (/^>(.+)/) {
        say ++$i, ": ", $1;
    }
}

printf "Found %s sequence%s.\n", $i, $i == 1 ? '' : 's';
