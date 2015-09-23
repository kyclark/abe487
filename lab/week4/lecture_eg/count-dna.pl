use Data::Dumper;

my $dna = 'TCTGACTGCAACGGGCAATATGTCTCNTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC';
my @letters = split //, $dna;

print "the letters are = ", join(', ', @letters), "\n";

#my ($na, $nc, $nt, $ng) = (0,0,0,0);
#
#for my $l (@letters) {
#    if (lc($l) eq 'a') {
#        $na++;
#    }
#    elsif (lc($l) eq 'c') {
#        $nc++;
#    }
#}

my %count_by_letter;
for my $l (@letters) {
    $count_by_letter{lc($l)}++;
}

print Dumper(\%count_by_letter), "\n";
