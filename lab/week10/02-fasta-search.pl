#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Bio::DB::Fasta;
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

    pod2usage() unless @ARGV == 2;

    my ($file, $pattern) = @ARGV;

    printf "Searching '%s' for '%s'\n", basename($file), $pattern;

    my $db  = Bio::DB::Fasta->new($file);
    my @ids = grep { /$pattern/i } $db->get_all_primary_ids;
    my $n   = @ids;

    printf "Found %s id%s\n", $n, $n == 1 ? '' : 's';

    if ($n > 0) {
        (my $filename = $pattern) =~ s/\W//g;
        $filename ||= 'out';
        $filename .= '.fa';

        my $writer = Bio::SeqIO->new(-format => 'Fasta', -file => ">$filename");
        for my $id (@ids) {
            if (my $seq = $db->get_Seq_by_id($id)) {
                $writer->write_seq($seq);
            }
        }

        say "See results in '$filename'";
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

02-fasta-search.pl - search FASTA file for sequences IDs matching a pattern

=head1 SYNOPSIS

  02-fasta-search.pl file.fa pattern

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Searches a FASTA file for sequence IDs matching a pattern.

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
