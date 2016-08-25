#!/usr/bin/env perl6

subset Dir of Str where *.IO.d;

sub MAIN (Dir :$in-dir!, Str :$out-dir!) {
    mkdir $out-dir unless $out-dir.IO.d;

    for dir($in-dir) -> $file {
        put $file;
    }
}
