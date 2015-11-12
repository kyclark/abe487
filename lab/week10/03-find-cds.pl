#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Bio::SeqIO;
use File::Basename;
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

    @ARGV or die sprintf("Usage: %s GenBank\n", basename($0));

    for my $file (@ARGV) {
        my $seqio = Bio::SeqIO->new(
            -file   => $file, 
            -format => 'genbank'
        );

        while (my $seq = $seqio->next_seq) {
            my @cds;
            for my $feature ($seq->get_SeqFeatures) {          
                if ($feature->primary_tag eq 'CDS') {
                    push @cds, $feature->get_tag_values('translation');
                }
            }

            printf "%s has %s CDS\n", $seq->accession, scalar(@cds);
            next unless @cds;
            my $i = 0;
            say join "\n", map { ++$i . ": " . $_ } @cds;
        }
    }
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

03-find-cds.pl - Find CDS regions from Genbank record

=head1 SYNOPSIS

  03-find-cds.pl rec.gb [rec2.gb ...]

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Extract the coding domain sequence (CDS) from Genbank records.

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
