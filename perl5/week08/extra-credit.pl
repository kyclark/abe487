#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;

my $file = shift || 'rebase.txt';
open my $fh, '<', $file;

my %enzymes;
while (my $line = <$fh>) {
    if ($line =~ /^([\w\s\(\)]+)\s+\b([A-Z\^]+)$/) {
        my ($name, $val) = ($1, $2);
        $name =~ s/\s*$//;
        $enzymes{ $name } = $val;
    }
}

say STDERR Dumper(\%enzymes);
printf "There are %s enzymes.\n", scalar keys %enzymes;
