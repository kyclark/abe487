#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

unless (@ARGV == 2) { 
    die "Please provide two sequences.\n";
}

my ($s1, $s2) = @ARGV;

unless (length($s1) == length($s2)) {
    die "Please ensure the sequences are the same length.\n";
}

my $n = 0;
my (@top, @middle, @bottom);
for (my $i = 0; $i < length($s1); $i++) {
    my $base1 = substr($s1, $i, 1);
    my $base2 = substr($s2, $i, 1);

    push @top   , $base1;
    push @middle, $base1 eq $base2 ? '|' : '*';
    push @bottom, $base2;
}

for my $arr (\@top, \@middle, \@bottom) {
    say join ' ', @$arr;
}
