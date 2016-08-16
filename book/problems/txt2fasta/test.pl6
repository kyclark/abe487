#!/usr/bin/env perl6

use v6;
use Test;

plan 1;

my $script := './txt2fasta.pl6';
my $proc1 = run $script, :err;
my $err   = $proc1.err.slurp-rest.chomp;
ok $err ~~ /Usage/, 'No args gives usage';
