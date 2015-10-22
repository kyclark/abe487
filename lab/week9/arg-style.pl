#!/usr/bin/env perl

use strict;
use feature 'say';

say 'pos1  = ', decorate_pos('[', 'foo', ']');
say 'pos2  = ', decorate_pos('', 'foo', '');
say 'name2 = ', decorate_named(str => 'foo', left => '(', right => ')');
say 'name1 = ', decorate_named(str => 'foo');

sub decorate_pos {
    my ($left, $str, $right) = @_;
    $left  ||= '>>>';
    $right ||= '<<<';
    return join(' ', $left, $str, $right);
}

sub decorate_named {
    my %args = @_;
    $args{'left'}  ||= '>>>';
    $args{'right'} ||= '<<<';
    return join(' ', $args{'left'}, $args{'str'}, $args{'right'});
}
