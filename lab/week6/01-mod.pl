#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

@ARGV or die "Please provide a list of numbers.\n";

say "evens = ", join(', ', grep { $_ % 2 == 0 } @ARGV);
