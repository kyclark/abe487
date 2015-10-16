#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dumper;

unless (@ARGV == 2) {
    die "Please provide two files.\n";
}

my %words1 = read_file(shift);
my %words2 = read_file(shift);

my $n = 0;
for my $word (sort keys %words1) {
    if (exists $words2{ $word }) {
        say $word;
        $n++;
    }
}

printf "Found %s word%s in common.\n", $n, $n == 1 ? '' : 's';

sub read_file {
    my $file = shift;
    open my $fh, '<', $file;

    my %words;
    while (my $line = <$fh>) {
        for my $word (split(/\s+/, $line)) {
            $word =~ s/[^A-Za-z0-9]//g;
            $words{ lc($word) }++;
        }
    }

    return %words;
}
