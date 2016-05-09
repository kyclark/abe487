#!/usr/bin/env perl

use common::sense;
use autodie;
use Bio::SearchIO;
use Getopt::Long;
use Pod::Usage;
use Readonly;

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

    my $blast_out = shift(@ARGV) or pod2usage();
    my $min       = 1e-50;
    my $searchio  = Bio::SearchIO->new( 
        -format   => 'blast',
        -file     => $blast_out,
    );

    say join "\t", qw[query hit evalue];
    while (my $result = $searchio->next_result ) {
        while (my $hit = $result->next_hit) {
            while (my $hsp = $hit->next_hsp) {
                say "sig = ", $hsp->significance;
                if ($hsp->significance <= $min) {
                    say join "\t", 
                        $hsp->query_string, $hsp->hit_string, $hsp->evalue;
                }
            }
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

01-bio-searchio.pl - parse BLAST output

=head1 SYNOPSIS

  01-bio-searchio.pl blast.out

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Parses BLAST output reporting the query string, hit string, and evalue
for every HSP (high-scoring pair).

=head1 SEE ALSO

Bio::SearchIO.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
