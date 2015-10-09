#!/usr/bin/env perl6

main();

sub main {
    unless (@*ARGS) {
        note("Usage: $*PROGRAM-NAME <numbers>\n");
        exit;
    }

    parse(@*ARGS);

    @*ARGS.classify(* %% 2).values.map: { say @$_.join(' + '), ' = ', [+] $_ };
}

sub parse (@numbers) {
    for [* %% 2, * !%% 2] -> $cond {
        tell(@numbers.grep($cond));
    }
}

sub tell (@numbers) {
    if (@numbers.elems > 0) {
        say @numbers.join(' + '), ' = ', ([+] @numbers);
    }
}
