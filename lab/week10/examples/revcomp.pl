#!/usr/bin/env perl

use strict;
use feature 'say';
use Bio::SeqIO;
use File::Basename;

@ARGV or die sprintf("Usage: %s fasta\n", basename($0));

my $file  = shift or die "No FASTA file\n";
my $num   = shift || 3;
my $seqio = Bio::SeqIO->new(
    -file   => $file,
    -format => "fasta" 
);

while (my $seq = $seqio->next_seq()) {
    say join "\n", 
        '>' . join(' ', $seq->id, $seq->desc, '[RC]'), 
        $seq->revcom->seq;
}
