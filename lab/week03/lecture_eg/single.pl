#my $name = 'Carl';
#
#print q(don't take my cake, $name), "\n";
#print qq(he said, "don't take my cake, $name."), "\n";

my $string = qq(apple    banana\tpie);
my @list = split(/\s+/, $string);
print join(', ', @list), "\n";
