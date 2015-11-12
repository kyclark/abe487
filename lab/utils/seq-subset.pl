#!/usr/bin/env perl

$| = 1;

use strict;
use feature 'say';
use autodie;
use Bio::SeqIO;
use Cwd 'cwd';
use File::Copy 'copy';
use File::Basename 'basename';
use File::Path 'make_path';
use File::RandomLine;
use File::Spec::Functions 'catfile';
use File::Temp 'tempfile';
use Getopt::Long;
use List::Util 'min';
use Pod::Usage;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    @ARGV or pod2usage("Need input files");

    my $number   = $args{'number'} || 100_000;
    my $out_dir  = $args{'dir'}    || cwd();
    my $in_fmt   = $args{'input'}  || 'Fasta';
    my $out_fmt  = $args{'output'} || 'Fasta';
    my $file_num = 0;

    unless (-d $out_dir) {
        make_path($out_dir);
    }

    FILE:
    for my $file (@ARGV) {
        my $basename    = basename($file);
        my $subset_file = catfile($out_dir, $basename . '.sub');

        printf "%5d: %s", ++$file_num, $basename;

        my ($tmp_fh, $tmp_filename) = tempfile();
        my $seqio = Bio::SeqIO->new(-file => $file, -format => $in_fmt);
        my $count = 0;
        while (my $seq = $seqio->next_seq) {
            $count++;
            say $tmp_fh $seq->id;
        }
        close $tmp_fh;

        if ($count < $number) {
            say " ($count < $number, so copying)";
            copy $file, $subset_file;
            next FILE;
        }
        else {
            say '';
        }

        my $random = File::RandomLine->new(
            $tmp_filename, 
            { algorithm => 'uniform' }
        ); 

        my %take;
        my $taken = 0;
        my $min = min($number, $count);
        while ($taken < $min) {
            my $id = $random->next;
            $take{ $id }++;
            $taken = scalar(keys %take);
        }

        my $in = Bio::SeqIO->new(-file => $file, -format => $in_fmt);
        my $out= Bio::SeqIO->new( 
            -format => $out_fmt,
            -file => ">$subset_file"
        );

        my $i = 0;
        while (my $seq = $in->next_seq) {
            $out->write_seq($seq) if exists $take{ $seq->id };
        }
    }

    say "Done.";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'number:i',
        'dir:s',
        'input:s',
        'output:s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

seq-subset.pl - sample FASTA files

=head1 SYNOPSIS

  seq-subset.pl -n 150000 -d out-dir file1.seq [file2.fa ...]

Options (defaults in parentheses):

  -n|--number   The number of sequences to take (100,000)
  -d|--dir      The output directory (current working dir)
  -i|--input    Sequence file format of input (FASTA)
  -o|--output   Sequence file format of output (FASTA)

  --help        Show brief help and exit
  --man         Show full documentation

=head1 DESCRIPTION

Randomly samples sequences from one or more sequence files.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@gmail.comE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Hurwitz Lab

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
