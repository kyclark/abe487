my %aa = (
   Alanine       => 'GCA, GCC, GCG, GCT',
   Asparagine    => 'AAC, AAT, GAC, GAT',
   Cysteine      => 'TGC, TGT',
   Aspartic_acid => 'GAC, GAT',
   Glutamic_acid => 'GAA, GAG',
   Phenylalanine => 'TTC, TTT',
   Glycine       => 'GGA, GGC, GGG, GGT',
   Histidine     => 'CAC, CAT',
   Isoleucine    => 'ATA, ATC, ATT',
   Lysine        => 'AAA, AAG',
   Leucine       => 'CTA, CTC, CTG, CTT, TTA, TTG',
   Methionine    => 'ATG',
   Asparagine    => 'AAC, AAT',
   Proline       => 'CCA, CCC, CCG, CCT',
   Glutamine     => 'CAA, CAG',
   Arginine      => 'AGA, AGG, CGA, CGC, CGG, CGT',
   Serine        => 'AGC, AGT, TCA, TCC, TCG, TCT',
   Threonine     => 'ACA, ACC, ACG, ACT',
   Valine        => 'GTA, GTC, GTG, GTT',
   Tryptophan    => 'TGG',
   X             => 'NNN',
   Tyrosine      => 'TAC, TAT',
   Glutamine     => 'CAA, CAG, GAA, GAG',
   STOP          => 'TAA, TAG, TGA',
);

my @names = sort keys %aa;
print join(", ", @names), "\n";

print "the first name = ", $names[0], "\n";
print "the last name = ", $names[-1], "\n";

print "Glutamine's codons are ", $aa{'Glutamine'}, "\n";

print "Values = \n";
print join("\n", sort values %aa), "\n";

my %codons = (
   'GCA' => 'Alanine',
   'AAC' => 'Asparagine',
   'TGC' => 'Cysteine',
   'GAC' => 'Aspartic_acid',
   'GAA' => 'Glutamic_acid',
   'TTC' => 'Phenylalanine',
   'GGA' => 'Glycine',
   'CAC' => 'Histidine',
   'ATA' => 'Isoleucine',
   'AAA' => 'Lysine',
   'CTA' => 'Leucine',
   'ATG' => 'Methionine',
   'AAC' => 'Asparagine',
   'CCA' => 'Proline',
   'CAA' => 'Glutamine',
   'AGA' => 'Arginine',
   'AGC' => 'Serine',
   'ACA' => 'Threonine',
   'GTA' => 'Valine',
   'TGG' => 'Tryptophan',
   'NNN' => 'X',
   'TAC' => 'Tyrosine',
   'CAA' => 'Glutamine',
   'TAA' => 'STOP',
);

my @codons = ( [ 'TGG', 'Tryptophan' ], [ 'NNN', 'X' ] );

my $codon = 'TGG';
print "The AA for '$codon' = ", $codons{$codon}, "\n";
