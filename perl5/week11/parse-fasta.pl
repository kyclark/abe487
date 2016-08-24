#!/usr/bin/env perl

use strict;
use feature 'say';
use File::Basename;
use Bio::SeqIO;

@ARGV or die sprintf("Usage: %s FASTA [num_seqs]\n", basename($0));

my $file  = shift or die "No FASTA file\n";
my $num   = shift || 3;
my $seqio = Bio::SeqIO->new(
    -file   => $file,
    -format => "fasta" 
);

while ($num > 0) {
    my $seq = $seqio->next_seq();
    say join "\n", '>' . $seq->id, $seq->seq();
    $num--;
}
