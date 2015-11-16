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

    pod2usage() unless @ARGV == 2;

    my ($file, $pattern) = @ARGV;

    printf "Searching '%s' for '%s'\n", basename($file), $pattern;

    (my $out_file = $pattern) =~ s/\W//g;
    $out_file ||= 'out';
    $out_file .= '.fa';

    my $in  = Bio::SeqIO->new(-file => $file, -format => 'Fasta');
    my $out = Bio::SeqIO->new(-format => 'Fasta', -file => ">$out_file");

    my $nfound = 0;
    while (my $seq = $in->next_seq) {
        if ($seq->id =~ /$pattern/i) {
            $nfound++;
            $out->write_seq($seq);
        }
    }

    printf "Found %s id%s\n", $nfound, $nfound == 1 ? '' : 's';

    if ($nfound == 0) {
        unlink $out_file;
    }
    else {
        say "See results in '$out_file'";
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
