#!/usr/bin/env perl

use common::sense;
use autodie;
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

    my $program  = $args{'program'} or pod2usage('Missing program');
    my $argument = $args{'argument'} or pod2usage('Missing argument');

    if ($program eq 'hello') {
        hello($argument);
    }
    elsif ($program eq 'rc') {
        rc($argument);
    }
    else {
        pod2usage("I only know how to do 'hello' and 'rc'");
    }
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'program=s',
        'argument=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

# --------------------------------------------------
sub hello {
    say "Hello, ", shift;
}

# --------------------------------------------------
sub rc {
    my $seq = shift;
    $seq    = reverse($seq);
    $seq    =~ tr/atcgATCG/tagcTAGC/;
    say $seq;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

01-subs.pl - a script

=head1 SYNOPSIS

  01-subs.pl -p hello -a Tucson

  01-subs.pl -p rc -a GAGAGAGAGAGTTTTTTTTT

Options:

  --program   The thing to do
  --argument  The argument to the thing
  --help      Show brief help and exit
  --man       Show full documentation

=head1 DESCRIPTION

Either prints "Hello, <argument>" or the reverse complement of 
<argument>.

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
