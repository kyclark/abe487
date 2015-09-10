my %turtles = (
    Michalengo => 'Orange',
    Donatello  => 'Purple',
    Leonardo   => 'Blue',
    Raphael    => 'Red',
);

print join(', ', sort keys %turtles), "\n";
print join(', ', sort values %turtles), "\n";

my %ordinal = (
    1 => 'first',
    2 => 'second',
    3 => 'third',
    10 => 'tenth',
);

print join(', ', sort { $b <=> $a } keys %ordinal), "\n";
