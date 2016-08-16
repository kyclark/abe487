#!/usr/bin/env perl6

use v6;
use Test;

plan 3;

my $script := './dna.pl6';
my $proc1 = run $script, :err;
my $err   = $proc1.err.slurp-rest.chomp;
ok $err ~~ /Usage/, 'No args gives usage';

#my $fail = runner($script);

my $proc2 = run $script,
  'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC',
  :out;
my $out1  = $proc2.out.slurp-rest.chomp;

is $out1, "20 12 17 21", 'Correct count from command line';

my $proc3 = run $script, 'test.txt', :out;
my $out2  = $proc3.out.slurp-rest.chomp;

is $out2, "20 12 17 21", 'Correct count from file';

sub runner(Str $script!, *@args) {
    my $proc = run $script, @args, :out;
    $proc.out.slurp-rest.chomp;
}
