#!/usr/bin/env perl6

use Test;
use lib $*PROGRAM.dirname.Str;
use Runner;

plan 9;

my $dir     = $*SPEC.catdir($*PROGRAM.dirname, '..', 'kmers');
my $script1 = $*SPEC.catfile($dir, 'kmer1.pl6');
my $script2 = $*SPEC.catfile($dir, 'kmer2.pl6');
my $fa1     = $*SPEC.catfile($dir, 'fasta-kmer1.pl6');
my $fa2     = $*SPEC.catfile($dir, 'fasta-kmer2.pl6');
my $fa3     = $*SPEC.catfile($dir, 'fasta-kmer3.pl6');
my $input   = $*SPEC.catfile($dir, 'input.txt');

ok $script1.IO.f, "$script1 exists";
ok $script2.IO.f, "$script2 exists";
ok $fa1.IO.f,     "$fa1 exists";
ok $fa2.IO.f,     "$fa2 exists";
ok $fa3.IO.f,     "$fa3 exists";
ok $input.IO.f,   "$input exists";

my $expect = q:to/END/.chomp;
AGCTTTTCATTCTGACTG
GCTTTTCATTCTGACTGC
CTTTTCATTCTGACTGCA
TTTTCATTCTGACTGCAA
TTTCATTCTGACTGCAAC
TTCATTCTGACTGCAACG
TCATTCTGACTGCAACGG
CATTCTGACTGCAACGGG
END

for $script1, $script2 -> $script {
    my $out1 = runner-err($script, '-k=3', 'AA');
    is $out1, "Cannot extract 3-mers from seq length 2", 
       "$script fails on too short";

    my $out2 = runner-out($script, '-k=3', 'ACTG');
    is $out2, "ACT\nCTG", "$script runs from command line";

    my $out3   = runner-out($script, '-k=18', $input);
    is $out3, $expect, "$script uses file argument";
}


