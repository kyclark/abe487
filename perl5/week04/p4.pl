#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

my $file = shift || 'Perl_III.fastq.txt';

open my $fh, '<', $file;

say "Counting '$file'";

my ($num_lines, $num_chars) = (0, 0);

while (my $line = <$fh>) {
    $num_lines++;
    $num_chars += length($line);
}

say "lines = $num_lines, chars = $num_chars, avg = ", $num_chars/$num_lines;
