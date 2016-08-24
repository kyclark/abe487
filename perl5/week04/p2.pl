#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

my $in_file  = shift || 'jabberwocky.txt';
my $out_file = shift || 'screaming.txt';

open my $in_fh , '<', $in_file;
open my $out_fh, '>', $out_file;

while (my $line = <$in_fh>) {
    print $out_fh uc $line;
}

say "'$in_file' => '$out_file'";
