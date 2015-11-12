#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Cwd 'cwd';
use Bio::SeqIO;
use File::Spec::Functions;
use File::Basename;
use File::Path 'make_path';
use Getopt::Long;
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
    } 

    @ARGV or pod2usage('No files');

    my $max     = $args{'number'};
    my $out_dir = $args{'out_dir'};

    unless (-d $out_dir) {
        make_path($out_dir);
    }

    my $file_num = 0;
    for my $file (@ARGV) {
        my $basename = basename($file);
        my $reader   = Bio::SeqIO->new(
            -file    => $file, 
            -format  => 'Fasta',
        );

        printf "%s: %s\n", ++$file_num, $basename;

        my $writer;
        my ($seq_num, $split_num) = (0, 0);
        while (my $seq = $reader->next_seq) {
            $seq_num++;
            if ($seq_num >= $max || !$writer) {
                $split_num++;
                $seq_num = 0;
                my $f = catfile($out_dir, "$basename.$split_num");
                $writer = Bio::SeqIO->new(
                    -format => 'Fasta', 
                    -file   => ">$f"
                );

                say "-> $f";
            }

            $writer->write_seq($seq);
        } 
    }

    say "Done.";
}

# --------------------------------------------------
sub get_args {
    my %args = (
        number  => 500,    
        out_dir => cwd(),
    );

    GetOptions(
        \%args,
        'number:s',
        'out_dir:s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

01-fasta-splitter.pl - split FASTA files

=head1 SYNOPSIS

  01-fasta-splitter.pl -n 20 -o ~/split file1.fa [file2.fa ...]

Options (defaults in parentheses):

  --number  The maxmimum number of sequences per file (500)
  --out_dir Output directory (cwd)
  --help    Show brief help and exit
  --man     Show full documentation

=head1 DESCRIPTION

FASTA files.  Sometimes they're too large.  Make'em smaller!

=head1 SEE ALSO

Bio::SeqIO.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Hurwitz Lab

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
