#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;

my $file = shift or die "Please provide a file.\n";

open my $fh, '<', $file;

my %freq;
while (my $line = <$fh>) {
    for my $word (split(/\s+/, $line)) {
        $word =~ s/[^A-Za-z0-9]//g;
        $freq{ lc($word) }++;
    }
}

my %common;
while (my ($word, $count) = each %freq) {
    next if $word =~ /^(the|a|an|and)$/;
    if ($count > 1) {
        $common{ $word } = $count;
    }
}

say "Number of non-singletons: ", scalar(keys %common);
my @sorted = sort { $common{ $b } <=> $common{ $a } } keys %common;

say "Top 10 words:";
my $i = 0;
for my $sorted (@sorted) {
    printf "%-10s: %s\n", $sorted, $common{ $sorted };
    last if ++$i > 10;
}
