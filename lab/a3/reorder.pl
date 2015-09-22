#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

@ARGV or die "No arguments.\n";

say join ', ', sort @ARGV;
