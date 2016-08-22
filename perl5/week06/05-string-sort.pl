#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

my @list = @ARGV or die "Please provide a list of sequences.\n";

say "sorted = ", join(', ', sort @list);
say "reverse = ", join(', ', reverse sort @list);
