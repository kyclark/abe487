#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

my $seq = shift or die "Please provide a sequence or file.\n";

if (-e $seq) {
    open my $fh, '<', $seq;
    ($seq = join '', <$fh>) =~ s/\s//g;
}

# R = AG
# Y = CT
$seq =~ s/([AG])(AATT[CT])/$1^$2/g;
say $seq;
