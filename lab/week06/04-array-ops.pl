#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

my @nums = (101, 2, 15, 22, 95, 33, 2, 27, 72, 15, 52);

say "array = ", join(', ', @nums);

my $popped = pop @nums;

say "popped = $popped, array = ", join(', ', @nums);

my $shifted = shift @nums;

say "shifted = $shifted, array = ", join(', ', @nums);

push @nums, 12;

say "after push, array = ", join(', ', @nums);

unshift @nums, 4;

say "after unshift, array = ", join(', ', @nums);
