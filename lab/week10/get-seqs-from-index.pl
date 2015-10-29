#!/usr/bin/env perl

use strict;
use feature 'say';
use File::Basename;
use Bio::Index::Fasta; 

unless (@ARGV >= 2) {
    die sprintf("Usage: %s index-name seqid [seqid...]\n", basename($0));
}

my $index_name = shift;
my $index      = Bio::Index::Fasta->new($index_name);
my $i = 0;
for my $id (@ARGV) {
    my $seq = $index->fetch($id);    
    printf "%3d: %s (%s)\n", ++$i, $seq->id, $seq->length;
}
