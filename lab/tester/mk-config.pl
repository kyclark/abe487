#!/usr/bin/env perl

use strict;
use feature 'say';
use FindBin '$Bin';

my @tests = (
    { 
        script => '01-mod.pl', 
        conditions => [
            {
                stderr => ['Please provide a list of numbers.'],
            },
            {
                args   => [ '1 2 3 4 5 6 7' ],
                stdout => ['evens = 2, 4, 6'],
            },
            {
                args   => [ '1 3 5 7' ],
                stdout => ['evens = '],
            },
        ],
    },
    { 
        script => '02-mod-sort-sum.pl',
        conditions => [
            {
                stderr => ['Please provide a list of numbers.'],
            },
            {
                args   => [ '1 2 3 4 5 6 7' ],
                stdout => ['sum evens = 12', 'sum odds = 16']
            },
        ],
    },
    { 
        script => '03-sort.pl',
        conditions => [
            {
                stderr => ['Please provide a list of numbers.'],
            },
            {
                args   => [ '98 2 36 74 27 33' ],
                stdout => [
                    'default sort = 2, 27, 33, 36, 74, 98',
                    'numerical sort = 2, 27, 33, 36, 74, 98',
                    'reverse numerical sort = 98, 74, 36, 33, 27, 2',
                ],
            },
        ],
    },
    { 
        script => '04-array-ops.pl',
        conditions => [
            {
                stdout => [
                    'array = 101, 2, 15, 22, 95, 33, 2, 27, 72, 15, 52',
                    'popped = 52, array = 101, 2, 15, 22, 95, 33, 2, 27, 72, 15',
                    'shifted = 101, array = 2, 15, 22, 95, 33, 2, 27, 72, 15',
                    'after push, array = 2, 15, 22, 95, 33, 2, 27, 72, 15, 12',
                    'after unshift, array = 4, 2, 15, 22, 95, 33, 2, 27, 72, 15, 12',
                ],
            },
        ],
    },
    { 
        script => '05-string-sort.pl',
        conditions => [
            { 
                stderr => ['Please provide a list of sequences.'],
            },
            {
                args   => ['ATGCCCGGCCCGGC GCGTGCTAGCAATACGATAAACCGG ATATATATCGAT ATGGGCCC'],
                stdout => [
                    'sorted = ATATATATCGAT, ATGCCCGGCCCGGC, ATGGGCCC, GCGTGCTAGCAATACGATAAACCGG',
                    'reverse = GCGTGCTAGCAATACGATAAACCGG, ATGGGCCC, ATGCCCGGCCCGGC, ATATATATCGAT',
                ],
            },
        ],
    },
    { 
        script => '06-string-sort-len.pl',
        conditions => [
            { 
                stderr => ['Please provide a list of sequences.'],
            },
            {
                args   => ['AACT TACCTAG TTACAG'],
                stdout => [
                    'sorted = AACT, TTACAG, TACCTAG',
                    'reverse = TACCTAG, TTACAG, AACT',
                ],
            },
        ],
    },
    { 
        script => '07-gc.pl',
        conditions => [
            { 
                stderr => ['Please provide a sequence.'],
            },
            {
                args   => ['ATGGGCCC atgcccggcccggc'],
                stdout => [
                    '-------',
                    'Seq   : ATGGGCCC',
                    'Length: 8',
                    '#GC   : 6',
                    '%GC   : 75',
                    '-------',
                    'Seq   : atgcccggcccggc',
                    'Length: 14',
                    '#GC   : 12',
                    '%GC   : 85.7142857142857',
                ],
            },
        ],
    },
    { 
        script => '08-snps.pl',
        conditions => [
            { 
                stderr => ['Please provide two sequences.'],
            },
            {
                args   => ['AACT ATCGA'],
                stderr => ['Please ensure the sequences are the same length.'],
            },
            {
                args   => ['AACT AACT'],
                stdout => ['Found 0 SNPs.'],
            },
            {
                args   => ['AACT AACG'],
                stdout => [
                    'Pos 4: T => G',
                    'Found 1 SNP.',
                ],
            },
            {
                args   => ['AACT AATC'],
                stdout => [
                    'Pos 3: C => T',
                    'Pos 4: T => C',
                    'Found 2 SNPs.',
                ],
            },
        ],
    },
    { 
        script => '09-extra-credit.pl',
        conditions => [
            { 
                stderr => ['Please provide two sequences.'],
            },
            {
                args   => ['AACT AATC'],
                stdout => [
                    'A A C T',
                    '| | * *',
                    'A A T C',
                ],
            },
        ],
    },
);

#say join("\n", '---', 'tests:');
for my $test (@tests) {
    for my $c (@{ $test->{'conditions'} }) {
        #say "  - script: ", $test->{'script'};

        say join "\n", '^^', 'script: ' . $test->{'script'};

        for my $key (qw[ args stderr stdout ]) {
            next unless defined $c->{$key};
            say join("\n", map { qq[$key: $_] } @{ $c->{ $key } });

            #say "    $key:";
            #say join("\n", map { qq[      - "$_"] } @{ $c->{ $key } });

            #my @vals = @{ $c->{ $key } };
            #if (@vals > 1) {
            #    say "  $key: |";
            #    say join("\n", map { "    $_" } @vals)
            #}
            #else {
            #    say "  $key: ", join('', @vals);
            #}
        }
    }
}
