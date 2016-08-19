#!/usr/bin/env perl6

use Bio::SeqIO;

sub MAIN (Str $file!, Int :$k=10) {
    die "Not a file ($file)" unless $file.IO.f;

    my $seqIO = Bio::SeqIO.new(format => 'fasta', file => $file);

    while (my $seq = $seqIO.next-Seq) {
        put $seq.seq;
        put join "\n", get-kmers($k, $seq.seq);
    }
}

sub get-kmers(Int $k, Str $str) {
    my $n = $str.chars - $k + 1;
    map { $str.substr($_, $k) }, 0..^$n;
}
