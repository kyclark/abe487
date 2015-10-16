#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;

my $sequence = shift or die "Please provide a sequence.\n";
my $mer_size = shift || 3;

if (-f $sequence) {
    open my $fh, '<', $sequence;
    my $tmp = join '', <$fh>;
    $sequence = $tmp;
}

my $slen   = length($sequence) or die "Zero-length sequence.\n";
my $nkmers = $slen - $mer_size + 1;

if ($nkmers < 1) {
    die "Cannot get any $mer_size mers from a sequence of length $slen\n";
}

my %freq;
for (my $i = 0; $i < $nkmers; $i++) {
    $freq{ substr($sequence, $i, $mer_size) }++;
}

my @common = 
    sort { $freq{ $b } <=> $freq{ $a } } 
    grep { $freq{ $_ } > 1 } 
    keys %freq;

my $nsingle = scalar(keys %freq) - scalar(@common);

my $fmt = "%-15s %10s\n";
printf $fmt, "Sequence length", $slen;
printf $fmt, "Mer size", $mer_size;
printf $fmt, "Number of kmers", $nkmers;
printf $fmt, "Unique kmers", scalar(keys %freq);
printf $fmt, "Num. singletons", $nsingle;

if ($nsingle < $nkmers) {
    say "Most abundant";
    my $i = 0;
    for my $kmer (@common) {
        printf "%s: %s\n", $kmer, $freq{ $kmer };
        last if ++$i == 10;
    }
}
