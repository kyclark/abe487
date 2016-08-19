#!/usr/bin/env perl6

sub MAIN (Str $input!, Int :$k=10) {
    my $seq = $input.IO.f ?? $input.IO.slurp.chomp !! $input;
    my $n   = $seq.chars - $k + 1;

    if $n < 1 {
        note "Cannot extract {$k}-mers from seq length {$seq.chars}";
        exit;
    } 

    for 0..^$n -> $i {
        put $seq.substr($i, $k);
    }
}
