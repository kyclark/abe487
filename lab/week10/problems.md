# Install LWP

    $ cpanm MIME::Base64
    $ cpanm LWP

# Install Bio::Perl

    $ cpam --look Bio::Perl
    $ perl Build.PL
    $ ./Build install

Accept all defaults, esp. allowing BioPerl to install sample scripts, then
go into your ~/perl5/bin dir and have a look.

Try one:

    bp_fetch.pl net::genbank:JX295726
    >gi|401879637|gb|JX295726.1| Lucilia sericata voucher LucilNICC0392 cytochrome oxidase subunit 1 (COI) gene, partial cds; mitochondrial
    TCGCAACAATGGTTATTTTCAACTAATCATAAAGATATTGGAACTTTATATTTTATTTTT
    GGAGCTTGATCCGGAATAATTGGAACTTCTTTAAGAATTCTAATTCGAGCTGAATTAGGA
    CATCCTGGAGCTTTAATTGGAGATGATCAAATTTATAATGTAATTGTTACAGCTCATGCT
    TTTATTATAATTTTTTTTATAGTAATGCCAATTATAATTGGAGGATTTGGAAATTGATTA
    GTTCCATTAATACTAGGAGCTCCAGATATAGCATTCCCTCGAATAAATAATATAAGTTTT
    TGACTTTTACCTCCTGCATTAACTTTATTATTAGTTAGTAGTATAGTAGAAAACGGAGCT
    GGAACAGGATGAACAGTTTACCCTCCTCTATCTTCTAATATTGCTCATGGAGGAGCTTCT
    GTTGATTTAGCTATTTTCTCTCTTCATTTAGCAGGAATTTCTTCAATTTTAGGAGCTGTA
    AATTTTATTACTACAGTTATTAATATACGATCAACAGGAATTACTTTTGATCGAATACCT
    TTATTTGTTTGATCAGTAGTAATTACAGCTTTATTACTTTTATTATCATTACCAGTATTA
    GCAGGAGCTATTACAATACTTTTAACAGACCGAAATCTTAATACATCATTCTTTGACCCT
    GCAGGAGGAGGAGATCCAATTTTATACCAACATTTATTTTGATTCTTTGGACACCCT

Write a script to parse a FASTA file:

    use Bio::SeqIO;

    my $file = shift @ARGV or pod2usage('No FASTA file');

    my $seqio = Bio::SeqIO->new(
        -file   => $file,
        -format => 'fasta'
    );

    my $seq = $seqio->next_seq();

    say $seq->seq();

$gb = new Bio::DB::GenBank();
 # this returns a Seq object :
 $seq1 = $gb->get_Seq_by_id('MUSIGHBA1');
 # this also returns a Seq object :
 $seq2 = $gb->get_Seq_by_acc('AF303112');
 # this returns a SeqIO object, which can be used to get a Seq object :
 $seqio = $gb->get_Stream_by_id(["J00522","AF303112","2981014"]);
 $seq3 = $seqio->next_seq; 
