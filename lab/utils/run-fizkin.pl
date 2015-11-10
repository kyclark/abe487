#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Algorithm::Numerical::Sample 'sample';
use Bio::SeqIO;
use Data::Dump 'dump';
use File::Basename qw'dirname basename';
use File::Copy;
use File::Find::Rule;
use File::Path 'make_path';
use File::RandomLine;
use File::Spec::Functions;
use File::Temp 'tempfile';
use Getopt::Long;
use List::MoreUtils qw'uniq';
use List::Util 'max';
use Math::Combinatorics 'combine';
use Pod::Usage;
use Readonly;
use Statistics::Descriptive::Discrete;
use Time::HiRes qw( gettimeofday tv_interval );
use Time::Interval qw( parseInterval );

my $DEBUG = 0;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }

    unless ($args{'in_dir'}) {
        pod2usage('No input directory');
    }

    unless ($args{'out_dir'}) {
        pod2usage('No output directory');
    }

    unless (-d $args{'in_dir'}) {
        pod2usage("Bad input dir ($args{'in_dir'})");
    }

    unless (-d $args{'out_dir'}) {
        make_path($args{'out_dir'});    
    }

    if ($args{'debug'}) {
        $DEBUG = 1;
    }

    run(\%args);
}

# --------------------------------------------------
sub debug {
    if ($DEBUG && @_) {
        say @_;
    }
}

# --------------------------------------------------
sub get_args {
    my %args = (
        debug       => 0,
        files       => '',
        hash_size   => '100M',
        kmer_size   => 20,
        max_samples => 15,
        max_seqs    => 300_000,
        mode_min    => 1,    
        num_threads => 12,
    );

    GetOptions(
        \%args,
        'in_dir=s',
        'out_dir=s',
        'debug',
        'files:s',
        'hash_size:s',
        'kmer_size:i',
        'max_samples:i',
        'max_seqs:i',
        'mode_min:i',
        'num_threads:i',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

# --------------------------------------------------
sub sys_exec {
    my @args = @_;

    debug("exec = ", join(' ', @args));

    unless (system(@args) == 0) {
        die sprintf("Cannot execute %s: %s", join(' ', @args), $?);
    }

    return 1;
}

# --------------------------------------------------
sub run {
    my $args = shift;

    say "Subsetting";
    subset_files($args);

    say "Indexing";
    jellyfish_index($args);

    say "Kmerize";
    kmerize($args);

    say "Pairwise comp";
    pairwise_cmp($args);

    say "Matrix";
    make_matrix($args);

    `perl sna.pl`;
}

# --------------------------------------------------
sub jellyfish_index {
    my $args       = shift;
    my @file_names = @{ $args->{'file_names'} } or die "No file names.\n";
    my $mer_size   = $args->{'kmer_size'};
    my $hash_size  = $args->{'hash_size'};
    my $threads    = $args->{'num_threads'};
    my $subset_dir = catdir($args->{'out_dir'}, 'subset');
    my $jf_idx_dir = catdir($args->{'out_dir'}, 'jf');

    unless (-d $subset_dir) {
        die "Bad subset dir($subset_dir)\n";
    }

    unless (-d $jf_idx_dir) {
        make_path($jf_idx_dir);
    }

    my $longest = $args->{'longest_file_name'};
    my $file_num = 0;
    for my $file_name (@file_names) {
        printf "%5d: %-${longest}s ", ++$file_num, $file_name;

        my $fasta_file = catfile($subset_dir, $file_name);
        my $jf_file    = catfile($jf_idx_dir, $file_name);

        for my $file ($fasta_file, $jf_file) {
            die "Bad file ($file)\n" unless -e $file;
        }

        if (-e $jf_file) {
            say "index exists";
        }
        else {
            say "indexing, ";
            my $timer = timer_calc();
            sys_exec('jellyfish', 'count', 
                '-m', $mer_size, 
                '-s', $hash_size,
                '-t', $threads,
                '-o', $jf_file,
                $fasta_file
            );
            say "finished in ", $timer->();
        }
    }
}

# --------------------------------------------------
sub kmerize {
    my $args       = shift;
    my @file_names = @{ $args->{'file_names'} } or die "No file names.\n";
    my $mer_size   = $args->{'kmer_size'};
    my $subset_dir = catdir($args->{'out_dir'}, 'subset');
    my $kmer_dir   = catdir($args->{'out_dir'}, 'kmer');

    unless (-d $kmer_dir) {
        make_path($kmer_dir);
    }

    my $longest = $args->{'longest_file_name'};
    my $file_num = 0;
    FILE:
    for my $file_name (@file_names) {
        printf "%5d: %-${longest}s ", ++$file_num, $file_name;

        my $fasta_file = catfile($subset_dir, $file_name);
        my $kmer_file  = catfile($kmer_dir,   $file_name . '.kmer');
        my $loc_file   = catfile($kmer_dir,   $file_name . '.loc');

        if (-e $kmer_file && -e $loc_file) {
            say "kmer/loc files exist";
            next FILE;
        }

        say "kmerizing";

        unless (-e $fasta_file) {
            die "Cannot find FASTA file '$fasta_file'\n";
        }

        my $fa = Bio::SeqIO->new(-file => $fasta_file);

        open my $kmer_fh, '>', $kmer_file;
        open my $loc_fh,  '>', $loc_file;
        
        my $i = 0;
        while (my $seq = $fa->next_seq) {
            my $sequence = $seq->seq;
            my $num_kmers = length($sequence) + 1 - $mer_size;

            if ($num_kmers > 0) {
                for my $pos (0 .. $num_kmers - 1) {
                    say $kmer_fh join("\n",
                        '>' . $i++,
                        substr($sequence, $pos, $mer_size)
                    );
                }
            }

            print $loc_fh join("\t", $seq->id, $num_kmers), "\n"; 
        }
    }
}

# --------------------------------------------------
sub make_matrix {
    my $args       = shift;
    my @combos     = @{ $args->{'mode_combos'} } 
                     or die "No mode combination names.\n";
    my $mode_dir   = catdir($args->{'out_dir'}, 'mode');
    my $matrix_dir = catdir($args->{'out_dir'}, 'matrix');

    unless (-d $mode_dir) {
        die "Bad mode dir ($mode_dir)";
    }

    unless (-d $matrix_dir) {
        make_path($matrix_dir);
    }

    my %matrix;
    for my $pair (@combos) {
        my ($s1, $s2) = @$pair;
        my $file = catfile($mode_dir, $s1, $s2);
        my $n    = 0;

        if (-s $file) {
            open my $fh, '<', $file;
            chomp($n = <$fh> // '');
            close $fh;
        }

        my $sample1 = basename(dirname($file));
        my $sample2 = basename($file);

        for ($sample1, $sample2) {
            $_ =~ s/\.\w+$//; # remove file extension
        }

        $matrix{ $sample1 }{ $sample2 } += $n || 0;
    }

#    my $num_samples = scalar(keys %matrix);
#    for my $sample (keys %matrix) {
#        if ($num_samples != values $matrix{ $sample }) {
#            say "Deleting $sample";
#            delete $matrix{ $sample };
#        }
#    }

    my @keys     = keys %matrix;
    my @all_keys = sort(uniq(@keys, map { keys %{ $matrix{ $_ } } } @keys));

    debug("matrix = ", dump(\%matrix));

    open my $fh, '>', catfile($matrix_dir, 'matrix.tab');

    say $fh join "\t", '', @all_keys;
    for my $sample1 (@all_keys) {
        my @vals = map { $matrix{ $sample1 }{ $_ } || 0 } @all_keys;

        say $fh join "\t", 
            $sample1, 
            map { sprintf('%.2f', $_ > 0 ? log($_) : 0) } @vals,
            #map { sprintf('%.2f', $_ > 0 ? log($_) : 1) } @vals,
        ;
    }
}

# --------------------------------------------------
sub pairwise_cmp {
    my $args          = shift;
    my @file_names    = @{ $args->{'file_names'} } or die "No file names.\n";
    my $mode_min      = $args->{'mode_min'};
    my $jf_idx_dir    = catdir( $args->{'out_dir'}, 'jf' );
    my $kmer_dir      = catdir( $args->{'out_dir'}, 'kmer' );
    my $read_mode_dir = catdir( $args->{'out_dir'}, 'read_mode' );
    my $mode_dir      = catdir( $args->{'out_dir'}, 'mode' );
    my $tmp_dir       = catdir( $args->{'out_dir'}, 'tmp' );

    unless (-d $jf_idx_dir) {
        die "Bad Jellyfish index dir ($jf_idx_dir)";
    }

    unless (-d $kmer_dir) {
        die "Bad kmer dir ($kmer_dir)";
    }

    for my $dir ($tmp_dir, $mode_dir, $read_mode_dir) {
        make_path($dir) unless -d $dir;
    }

    if (scalar(@file_names) < 1) {
        say "Not enough files to perform pairwise comparison.";
        return;
    }

    my @combos;
    for my $pair (combine(2, @file_names)) {
        my ($s1, $s2) = @$pair;
        push @combos, [$s1, $s2], [$s2, $s1];
    }

    $args->{'mode_combos'} = \@combos;

    printf "Will perform %s comparisons\n", scalar(@combos);

    my $combo_num = 0;
    COMBO:
    for my $pair (@combos) {
        my ($base_jf_file, $base_kmer_file) = @$pair;

        my $jf_index        = catfile($jf_idx_dir, $base_jf_file);
        my $kmer_file       = catfile($kmer_dir, $base_kmer_file . '.kmer');
        my $loc_file        = catfile($kmer_dir, $base_kmer_file . '.loc');
        my $sample_mode_dir = catdir($mode_dir, $base_jf_file);
        my $sample_read_dir = catdir($read_mode_dir, $base_jf_file);
        my $mode_file       = catfile($sample_mode_dir, $base_kmer_file);
        my $read_mode_file  = catfile($sample_read_dir, $base_kmer_file);

        for my $dir ($sample_mode_dir, $sample_read_dir) {
            make_path($dir) unless -d $dir;
        }

        my $longest = $args->{'longest_file_name'};
        printf "%5d: %-${longest}s -> %-${longest}s ", 
            ++$combo_num, $base_kmer_file, $base_jf_file;

        if (-s $mode_file) {
            say "mode file exists";
            next COMBO;
        }

        my ($tmp_fh, $jf_query_out_file) = tempfile(DIR => $tmp_dir);
        close $tmp_fh;

        my $timer = timer_calc();

        sys_exec('jellyfish', 'query', '-s', $kmer_file, 
            '-o', $jf_query_out_file, $jf_index);

        open my $loc_fh ,      '<', $loc_file;
        open my $mode_fh,      '>', $mode_file;
        open my $read_mode_fh, '>', $read_mode_file;
        open my $jf_fh,        '<', $jf_query_out_file;

        my $mode_count = 0;
        while (my $loc = <$loc_fh>) {
            chomp($loc);
            my ($read_id, $n_kmers) = split /\t/, $loc;

            my @counts;
            for my $val (take($n_kmers, $jf_fh)) {
                next if !$val;
                my ($kmer_seq, $count) = split /\s+/, $val;
                push @counts, $count if defined $count && $count =~ /^\d+$/;
            }

            my $mode = mode(@counts) // 0;
            if ($mode >= $mode_min) {
                print $read_mode_fh join("\t", $read_id, $mode), "\n";
                $mode_count++;
            }
        }

        say $mode_fh $mode_count;

        say "finished in ", $timer->();

        unlink $jf_query_out_file;
    }
}

# --------------------------------------------------
sub subset_files {
    my $args        = shift;
    my $max_seqs    = $args->{'max_seqs'};
    my $max_samples = $args->{'max_samples'};
    my $in_dir      = $args->{'in_dir'};

    my @files;
    if (my $files_arg = $args->{'files'}) {
        my @names = split(/\s*,\s*/, $files_arg);

        if (my @bad = grep { !-e catfile($in_dir, $_) } @names) {
            die sprintf("Bad input files (%s)\n", join(', ', @bad));
        }
        else {
            @files = @names;
        }
    }
    else {
        @files = map { basename($_) } File::Find::Rule->file()->in($in_dir);
    }

    debug("files = ", join(', ', @files));

    printf "Found %s files in %s\n", scalar(@files), $args->{'in_dir'};

    if (scalar(@files) > $max_samples) {
        say "Subsetting to $max_samples files";
        @files = sample(-set => \@files, -sample_size => $max_samples);
    }

    $args->{'file_names'}        = [ sort @files ];
    $args->{'longest_file_name'} = max(map { length($_) } @files);

    my $subset_dir = catdir($args->{'out_dir'}, 'subset');

    unless (-d $subset_dir) {
        make_path($subset_dir);
    }

    my $longest = $args->{'longest_file_name'};
    my $file_num = 0;
    FILE:
    for my $file (@files) {
        my $basename    = basename($file);
        my $subset_file = catfile($subset_dir, $basename);

        printf "%5d: %-${longest}s ", ++$file_num, $basename;

        if (-e $subset_file) {
            say "subset file exists";
            next FILE;
        }
          
        my ($tmp_fh, $tmp_filename) = tempfile();
        my $fa = Bio::SeqIO->new(-file => $file);
        my $count = 0;
        while (my $seq = $fa->next_seq) {
            $count++;
            say $tmp_fh $seq->id;
        }
        close $tmp_fh;

        print "$count seqs, ";

        if ($count < $max_seqs) {
            say "copying to subset file";
            copy($file, $subset_file); 
        }
        else {
            say "randomly sampling, ";

            my $timer = timer_calc();
            my $random = File::RandomLine->new(
                $tmp_filename, 
                { algorithm => 'uniform' }
            ); 

            my %take;
            while (scalar(keys %take) < $max_seqs) {
                my $id = $random->next;
                $take{ $id }++;
            }

            my $in = Bio::SeqIO->new(-file => $file);
            my $out= Bio::SeqIO->new( 
                -format => 'Fasta', 
                -file => ">$subset_file"
            );

            while (my $seq = $in->next_seq) {
                $out->write_seq($seq) if exists $take{ $seq->id };
            }

            say "finished in ", $timer->();
        }

        unlink($tmp_filename);
    }

    return 1;
}

# --------------------------------------------------
sub mode {
    my @vals = @_ or return;
    my $mode = 0;

    if (scalar @vals == 1) {
        $mode = shift @vals;
    }
    else {
        my @distinct = uniq(@vals);

        if (scalar @distinct == 1) {
            $mode = shift @distinct;
        }
        else {
            my $stats = Statistics::Descriptive::Discrete->new;
            $stats->add_data(@vals);
            return $stats->mode();

#            if (my $mean = int($stats->mean())) {
#                my $two_stds = 2 * (int $stats->standard_deviation());
#                my $min      = $mean - $two_stds;
#                my $max      = $mean + $two_stds;
#
#                if (my @filtered = grep { $_ >= $min && $_ <= $max } @vals) {
#                    my $stats2 = Statistics::Descriptive::Discrete->new;
#                    $stats2->add_data(@filtered);
#                    $mode = int($stats2->mode());
#                }
#            }
#            else {
#                return 0;
#            }
        }
    }

    return $mode;
}

# ----------------------------------------------------
sub take {
    my ($n, $fh) = @_;

    my @return;
    for (my $i = 0; $i < $n; $i++) {
        my $line = <$fh>;
        last if !defined $line;
        chomp($line);
        push @return, $line;
    }

    @return;
}

# --------------------------------------------------
sub timer_calc {
    my $start = shift || [ gettimeofday() ];

    return sub {
        my %args    = ( scalar @_ > 1 ) ? @_ : ( end => shift(@_) );
        my $end     = $args{'end'}    || [ gettimeofday() ];
        my $format  = $args{'format'} || 'pretty';
        my $seconds = tv_interval( $start, $end );

        if ( $format eq 'seconds' ) {
            return $seconds;
        }
        else {
            return $seconds > 60
                ? parseInterval(
                    seconds => int($seconds),
                    Small   => 1,
                )
                : sprintf("%s second%s", $seconds, $seconds == 1 ? '' : 's')
            ;
        }
    }
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

run-fizkin - run fizkin

=head1 SYNOPSIS

  run-fizkin -i input-dir -o output-dir

Required arguments:

  --input_dir   Input directory (FASTA)
  --output_dir  Output directory (FASTA)

Options (defaults in parentheses):
 
  --kmer_size    Kmer size (20)
  --mode_min     Minimum mode to take a sequence (1)
  --num_threads  Number of threads to use for Jellyfish (12)
  --hash_size    Size of hash for Jellyfish (100M)
  --max_seqs     Maximum number of sequences per input file (300,000)
  --max_samples  Maximum number of samples (15)
  --files        Comma-separated list of input files
                 (random subset of --max_samples from --input_dir)

  --debug        Print extra things
  --help         Show brief help and exit
  --man          Show full documentation

=head1 DESCRIPTION

Runs a pairwise k-mer analysis on the input files.

=head1 SEE ALSO

Fizkin.

=head1 AUTHORS

Bonnie Hurwitz E<lt>bhurwitz@email.arizona.eduE<gt>,
Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Hurwitz Lab

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
