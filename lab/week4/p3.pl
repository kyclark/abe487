#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

open my $fh, '<', 'Perl_III.fasta.txt';

while (my $line = <$fh>) {
    #if (index($line, '>') == 0) {
    #if ($line =~ /^>/) {

    chomp($line);

    if (substr($line, 0, 1) eq '>') {
        say "$line (revcomp)";
    }
    else {
        $line = reverse $line;
        $line =~ tr/ACGTacgt/TGCAtgca/;
        say $line;
    }
}
