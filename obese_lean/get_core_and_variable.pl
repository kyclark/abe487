#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

# % head -3 SRR029686.uproc 
# K02014,1131 
# K01190,687 
# K05349,640

@ARGV or die "No input files.\n";

my (%kegg_to_file, %kegg_to_reads);
for my $file (@ARGV) {
    open my $fh, '<', $file;

    while (my $line = <$fh>) {
        chomp($line);
        my ($kegg_id, $nmatches) = split(/,/, $line);
        next unless $nmatches >= 50;
        $kegg_to_file{ $kegg_id }++;
        $kegg_to_reads{ $kegg_id } += $nmatches;
    }
}

my $nfiles = scalar(@ARGV);

open my $core_fh, '>', 'core';
open my $var_fh,  '>', 'variable';

say $core_fh join "\n", 
    map  { join("\t", $_, $kegg_to_reads{$_}) }
    grep { $kegg_to_file{$_} == $nfiles } sort keys %kegg_to_file;

say $var_fh  join "\n", 
    map  { join("\t", $_, $kegg_to_reads{$_}) }
    grep { $kegg_to_file{$_} <  $nfiles } sort keys %kegg_to_file;
