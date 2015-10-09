#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

my @nums   = @ARGV or die "Please provide a list of numbers.\n";
my @sorted = sort @nums;
say "default sort = ", join(', ', @sorted);

my @nsort = sort { $a <=> $b } @nums;

say "numerical sort = ", join(', ', @nsort);

my @rnsort = sort { $b <=> $a } @nums;

say "reverse numerical sort = ", join(', ', @rnsort);
