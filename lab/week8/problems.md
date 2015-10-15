# Perl Week 8 Problem Set

Create a directory named "week8" for these scripts.

## 01-palindrome.pl

Write a program to detect palindromes. It must be able
to handle changes in case.

    $ perl 01-palindrome.pl
    Please provide a word or phrase. 
    $ perl 01-palindrome.pl foo
    No
    $ perl 01-palindrome.pl "Madam in Eden Im Adam"
    Yes
    $ perl 01-palindrome.pl gatcctag
    Yes
    $ perl 01-palindrome.pl "A man, a plan, a canal... Panama"
    Yes
 
## 02-nobody.pl

At the bottom of your script, put "__DATA__" and then insert the
contents of the "nobody.txt" file.  Read from the special "DATA"
filehandle (a global symbol) as you would from a normal filehandle,
but you do not have to "open" it first.  (Handy!) Substitute every
occurrence of "Nobody" with a name given on the command line (default
to "George").

E.g., your script will look like this:

    #!/usr/bin/env perl

    use strict;
    use warnings;

    while (my $line = <DATA>) {
        # ...
    }

    __DATA__
    Nobody by Shel Silverstein
    Nobody loves me,
    Nobody cares,

Expected output:

    [catalina@~/work/abe487/lab/week8]$ perl 02-nobody.pl
    George by Shel Silverstein
    George loves me,
    George cares,
    [output elided]

    [catalina@~/work/abe487/lab/week8]$ perl 02-nobody.pl Harry
    Harry by Shel Silverstein
    Harry loves me,
    Harry cares,
    [output elided]

## 03-fasta.pl

Find all the lines in a FASTA file that are the header (>seqName desc)
using pattern matching.  Print out a count and the header (less the
">") use the printf template "%6d: %s\n".  At the end, print a summary 
of how many were found.

    $ perl 03-fasta.pl
    Please provide a FASTA file.
    $ perl 03-fasta.pl one.fa
    1: foo
    Found 1 sequence.
    $ perl 03-fasta.pl test.fa
    1: foo
    2: bar
    3: baz
    Found 3 sequences.

## 04-restriction.pl

The enzyme ApoI has a restriction site: R^AATTY where R and Y are
degenerate nucleotideides. See the IUPAC table
(http://www.bioinformatics.org/sms/iupac.html) to identify the
nucleotide possibilities for the R and Y.

Write a regular expression that will match occurrences of this site 

    $ cat seq.txt
    GAATTCAAGTTCTTGTGCGCACACAAATCCAATAAAAACTATTGTGCACACAGACGCGAC
    TTCGCGGTCTCGCTTGTTCTTGTTGTATTCGTATTTTCATTTCTCGTTCTGTTTCTACTT
    AACAATGTGGTGATAATATAAAAAATAAAGCAATTCAAAAGTGTATGACTTAATTAATGA
    GCGATTTTTTTTTTGAAATCAAATTTTTGGAACATTTTTTTTAAATTCAAATTTTGGCGA
    AAATTCAATATCGGTTCTACTATCCATAATATAATTCATCAGGAATACATCTTCAAAGGC
    AAACGGTGACAACAAAATTCAGGCAATTCAGGCAAATACCGAATGACCAGCTTGGTTATC
    AATTCTAGAATTTGTTTTTTGGTTTTTATTTATCATTGTAAATAAGACAAACATTTGTTC
    CTAGTAAAGAATGTAACACCAGAAGTCACGTAAAATGGTGTCCCCATTGTTTAAACGGTT
    GTTGGGACCAATGGAGTTCGTGGTAACAGTACATCTTTCCCCTTGAATTTGCCATTCAAA
    ATTTGCGGTGGAATACCTAACAAATCCAGTGAATTTAAGAATTGCGATGGGTAATTGACA
    TGAATTCCAAGGTCAAATGCTAAGAGATAGTTTAATTTATGTTTGAGACAATCAATTCCC
    CAATTTTTCTAAGACTTCAATCAATCTCTTAGAATCCGCCTCTGGAGGTGCACTCAGCCG
    CACGTCGGGCTCACCAAATATGTTGGGGTTGTCGGTGAACTCGAATAGAAATTATTGTCG
    CCTCCATCTTCATGGCCGTGAAATCGGCTCGCTGACGGGCTTCTCGCGCTGGATTTTTTC
    ACTATTTTTGAATACATCATTAACGCAATATATATATATATATATTTAT
    $ perl 04-restriction.pl
    Please provide a sequence or file.
    $ perl 04-restriction.pl seq.txt
    G^AATTCAAGTTCTTGTGCGCACACAAATCCAATAAAAACTATTGTGCACACAGACGCGACTTCGCGGTCTCGCTTGTTCTTGTTGTATTCGTATTTTCATTTCTCGTTCTGTTTCTACTTAACAATGTGGTGATAATATAAAAAATAAAGCAATTCAAAAGTGTATGACTTAATTAATGAGCGATTTTTTTTTTGAAATCA^AATTTTTGGAACATTTTTTTTA^AATTCA^AATTTTGGCGAA^AATTCAATATCGGTTCTACTATCCATAATATAATTCATCAGGAATACATCTTCAAAGGCAAACGGTGACAACAA^AATTCAGGCAATTCAGGCAAATACCGAATGACCAGCTTGGTTATCAATTCTAG^AATTTGTTTTTTGGTTTTTATTTATCATTGTAAATAAGACAAACATTTGTTCCTAGTAAAGAATGTAACACCAGAAGTCACGTAAAATGGTGTCCCCATTGTTTAAACGGTTGTTGGGACCAATGGAGTTCGTGGTAACAGTACATCTTTCCCCTTG^AATTTGCCATTCAA^AATTTGCGGTGGAATACCTAACAAATCCAGTG^AATTTAAGAATTGCGATGGGTAATTGACATG^AATTCCAAGGTCAAATGCTAAGAGATAGTTTAATTTATGTTTGAGACAATCAATTCCCCAATTTTTCTAAGACTTCAATCAATCTCTTAGAATCCGCCTCTGGAGGTGCACTCAGCCGCACGTCGGGCTCACCAAATATGTTGGGGTTGTCGGTGAACTCGAATAGAAATTATTGTCGCCTCCATCTTCATGGCCGTGAAATCGGCTCGCTGACGGGCTTCTCGCGCTGGATTTTTTCACTATTTTTGAATACATCATTAACGCAATATATATATATATATATTTAT

## 05-sort-frags.pl

Write a Perl script that uses <> to read STDIN such that you can pipe 
the output of the previous program into it and then sort the cut
fragments by length (in the same order they would separate on an 
electrophoresis gel).

Hint: take a look at the split man page or think about storing your
matches in an array. With one of these two approaches you should be
able to convert this string:

    AAAAAAAAGACGT^CTTTTTTTAAAAAAAAGACGT^CTTTTTTT

into this array:

    ("AAAAAAAAGACGT","CTTTTTTTAAAAAAAAGACGT","CTTTTTTT")

    $ perl 04-restriction.pl seq.txt | ./05-sort-frags.pl
    G
    AATTCA
    AATTTTGGCGAA
    AATTTGCCATTCAA
    AATTTTTGGAACATTTTTTTTA
    AATTTAAGAATTGCGATGGGTAATTGACATG
    AATTTGCGGTGGAATACCTAACAAATCCAGTG
    AATTCAGGCAATTCAGGCAAATACCGAATGACCAGCTTGGTTATCAATTCTAG
    AATTCAATATCGGTTCTACTATCCATAATATAATTCATCAGGAATACATCTTCAAAGGCAAACGGTGACAACAA
    AATTTGTTTTTTGGTTTTTATTTATCATTGTAAATAAGACAAACATTTGTTCCTAGTAAAGAATGTAACACCAGAAGTCACGTAAAATGGTGTCCCCATTGTTTAAACGGTTGTTGGGACCAATGGAGTTCGTGGTAACAGTACATCTTTCCCCTTG
    AATTCAAGTTCTTGTGCGCACACAAATCCAATAAAAACTATTGTGCACACAGACGCGACTTCGCGGTCTCGCTTGTTCTTGTTGTATTCGTATTTTCATTTCTCGTTCTGTTTCTACTTAACAATGTGGTGATAATATAAAAAATAAAGCAATTCAAAAGTGTATGACTTAATTAATGAGCGATTTTTTTTTTGAAATCA
    AATTCCAAGGTCAAATGCTAAGAGATAGTTTAATTTATGTTTGAGACAATCAATTCCCCAATTTTTCTAAGACTTCAATCAATCTCTTAGAATCCGCCTCTGGAGGTGCACTCAGCCGCACGTCGGGCTCACCAAATATGTTGGGGTTGTCGGTGAACTCGAATAGAAATTATTGTCGCCTCCATCTTCATGGCCGTGAAATCGGCTCGCTGACGGGCTTCTCGCGCTGGATTTTTTCACTATTTTTGAATACATCATTAACGCAATATATATATATATATATTTAT

# extra-credit.pl

Download "The Restriction Enzyme Database" from 
http://rebase.neb.com/rebase/link_bionet. Parse the data fill a hash of enzymes and their patterns.
Print the hash to STDERR with Data::Dumper, and report the number of enzymes to STDOUT.

    $ perl extra-credit.pl 2>err
    There are 3718 enzymes.
    $ head err
    $VAR1 = {
              'Acs1421I (SalI)' => 'GTCGAC',
              'BstTS5I (BbvII)' => 'GAAGACNN^',
              'Bce170I (PstI)' => 'CTGCAG',
              'Uba1323I (MboI)' => 'GATC',
              'Ecl136II (SacI)' => 'GAG^CTC',
              'Eco26I (HgiJII)' => 'GRGCYC',
              'PaeHI (HgiJII)' => 'GRGCY^C',
              'Tsp301I (AvaII)' => 'GGWCC',
              'DsaI' => 'C^CRYGG',

# Testing

To test, clone Ken's Github (not into your own Git checkout, though):

    $ git clone git@github.com:kyclark/abe487.git kyclark

Go into the "lab/tester" directory and run with the "week8.conf" and your 
"week8" directory.  If you run this locally, you will need to install 
the CPAN module "Test::Script::Run":

    $ sudo cpan -i Test::Script::Run

Test output should look like this:

    $ ./tester.pl -t week8.conf -d ../week8/
    ok 1 - 01-palindrome.pl
    ok 2 - 01-palindrome.pl foo
    ok 3 - 01-palindrome.pl "Madam in Eden Im Adam"
    ok 4 - 01-palindrome.pl gatcctag
    ok 5 - 01-palindrome.pl "A man, a plan, a canal... Panama"
    ok 6 - 02-nobody.pl John
    ok 7 - 03-fasta.pl
    ok 8 - 03-fasta.pl one.fa
    ok 9 - 03-fasta.pl test.fa
    ok 10 - 04-restriction.pl
    ok 11 - 04-restriction.pl seq.txt
    ok 12 - 05-sort-frags.pl restrictions.txt
    1..12
    The plan was already output at /usr/local/lib/perl5/5.22.0/Test/Builder.pm line 2510.
    1..12
