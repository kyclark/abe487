#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';

my $input = shift or die "Please provide a word or phrase.\n";
my $text  = uc $input;
$text     =~ s/[^a-zA-Z0-9]//g;

printf "%s\n", ($text eq reverse($text)) ? "Yes" : "No";
