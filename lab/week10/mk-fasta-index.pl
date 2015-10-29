#!/usr/bin/env perl

use strict;
use feature 'say';
use File::Basename;
use Bio::Index::Fasta; 

unless (@ARGV >= 2) {
    die sprintf("Usage: %s index-name fasta [fasta...]\n", basename($0));
}

my $index_name  = shift;
my $index       = Bio::Index::Fasta->new(
    -filename   => $index_name,
    -write_flag => 1,
);

$index->make_index(@ARGV);
