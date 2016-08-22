#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

my $fh;
if (my $file = shift) {
    open $fh, '<', $file;
}
else {
    $fh = \*STDIN;
}

chomp(my $in = (join '', <$fh>));
if ($in) {
    say join "\n", sort { length($a) <=> length($b) } split(/\^/, $in);
}
