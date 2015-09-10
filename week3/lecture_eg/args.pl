#!/usr/bin/env perl

use strict;
use feature 'say';

unless (@ARGV) {
    die "Where are my arguments?\n";
}

say "The args are ", join(', ', @ARGV);
say "There are ", scalar(@ARGV), " arguments";

my $first = shift;
say "The first arg is '$first'";
say "The args are now ", join(', ', @ARGV);

report(qw[these are some arguments]);

sub report {
    my ($first, $second, @rest, $last) = @_;
    say "first ($first)";
    say "second ($second)";
    say "rest ", join(', ', @rest);
    say "last ($last)";
}
