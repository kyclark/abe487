#!/usr/bin/env perl6

unless (1 <= @*ARGS.elems <= 2) {
    printf "Usage: %s GREETING [NAME]\n", $*SPEC.basename($*PROGRAM-NAME);
    exit 1;
}

my ($greeting, $name) = @*ARGS;

put "$greeting, {$name // 'Stranger'}!";
