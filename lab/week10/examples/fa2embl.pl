#!/usr/bin/env perl

use strict;
use File::Basename;
use Bio::SeqIO;

@ARGV or die sprintf("Usage: %s fasta.in\n", basename($0));

my $out = Bio::SeqIO->new(-format => 'EMBL');

for my $file (@ARGV) {
    my $in = Bio::SeqIO->new(-file => $file, -format => 'Fasta');
    while ( my $seq = $in->next_seq() ) {
        $out->write_seq($seq); 
    } 
}
