#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;

my $file = shift || 'Perl_V.genesAndSeq.txt';

open my $fh, '<', $file;

my ($id, %genes);
while (my $line = <$fh>) {
    chomp($line);

    if (substr($line, 0, 1) eq '>') {
        $id = substr($line, 1);
    }
    elsif ($id) {
        $genes{ $id } .= $line;
    }
}

for my $gene ( 
    sort { length($genes{$a}) <=> length($genes{$b}) }
    keys %genes
) {
    printf "%s: %s\n", $gene, length($genes{ $gene });
}
