#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use List::Util 'max';
use Data::Dumper;
use Text::TabularDisplay;
use Getopt::Long 'GetOptions';

my %args = (format => 'text');
GetOptions(\%args, 'format:s');

my $pathway_file = 'kegg_to_path';
unless (-e $pathway_file) {
    die "Cannot find pathway file ($pathway_file).\n";
}

my %core    = find_pathways($pathway_file, 'core');
my %var     = find_pathways($pathway_file, 'variable');
my %all     = (%core, %var);
my $longest = max(map { length($_) } keys %all);
my $tab     = Text::TabularDisplay->new(qw'Pathway Core Vary');

my @out;
for my $pname (sort keys %all) {
    $tab->add(
        $pname, 
        map { sprintf('%5.2f%%', $_) }
        $core{$pname} || 0, $var{$pname} || 0
    );

    push @out, sprintf "%-${longest}s core %5.2f%% var %5.2f%%", 
        $pname, $core{$pname} || 0, $var{$pname} || 0;
}

if ($args{'format'} eq 'table') {
    say $tab->render;
}
else {
    say join "\n", @out;
}

# --------------------------------------------------
sub find_pathways {
    my ($pathway_file, $kegg_file) = @_;

    open my $fh, '<', $kegg_file;
    my %kegg_ids;
    my $num_total_reads = 0;
    while (my $line = <$fh>) {
        chomp($line);
        my ($kegg_id, $num_reads) = split /\t/, $line;
        $kegg_ids{ $kegg_id } = $num_reads;
        $num_total_reads += $num_reads;
    }

    open my $map_fh, '<', $pathway_file;
    my %pathways;
    while (my $line = <$map_fh>) {
        chomp($line);
        my ($kegg_id, $pathway) = split(/\t/, $line);
        if ($kegg_ids{ $kegg_id}) {
            $pathway =~ s/^map\d+_//;
            $pathways{ $pathway } += $kegg_ids{ $kegg_id };
        }
    }

    my %pathways_pct;
    while (my ($pname, $pcount) = each %pathways) {
        $pathways_pct{ $pname } = ($pcount / $num_total_reads) * 100;
    }

    return %pathways_pct;
}
