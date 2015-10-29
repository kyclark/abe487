#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use feature 'say';

my $fasta = shift or 
            die "Please provide a FASTA-formatted multiple alignment file\n";

my @seqs = parse($fasta);

unless (@seqs == 2) {
    die "Please provide only two sequences.\n";
}

my @lengths = sort { $a <=> $b } map { length($_) } @seqs;

if ($lengths[0] != $lengths[1]) {
    die "These are different lengths, must not be aligned.\n";
}
my ($s1, $s2) = @seqs;

my $num_snps = 0;
for (my $i = 0; $i < length($s1); $i++) {
    my $base1 = substr($s1, $i, 1);
    my $base2 = substr($s2, $i, 1);

    next if $base1 eq '-' || $base2 eq '-';

    if ($base1 ne $base2) {
        printf "Pos %s: %s => %s\n", $i + 1, $base1, $base2;
        $num_snps++;
    }
}

printf "Found %s SNP%s.\n", $num_snps, $num_snps == 1 ? '' : 's';
printf "Similar: %.2f%%\n", 100 * ($num_snps / $lengths[0]);

# --------------------------------------------------
sub parse {
    my $file = shift or return;

    open my $fh, '<', $fasta;
    local $/ = '>';

    my @seqs;
    while (my $rec = <$fh>) {
        chomp($rec);
        next unless $rec;
        my ($id, @s) = split /\n/, $rec;
        push @seqs, join('', @s);
    }

    close $fh;

    return @seqs;
}
