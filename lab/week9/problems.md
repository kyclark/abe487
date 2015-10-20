# Perl VII Problem Set

Create a directory called "week9" for the following scripts.

## 01-rc.pl

Create a subroutine that reverse complements a sequence.  This
subroutine should take a nucleotide sequence as a parameter and return
the reverse complement.
 
Here's the pseudo code:
 
-- BEGIN PSEUDOCODE --
 
subroutine reverse_complement {
 
  get the parameter nucleotide string
 
  reverse complement the nucleotide string
 
  return the complemented nucleotide string
 
}
 
-- END PSEUDOCODE --
 
Write a program that takes in a nucleotide string as an argument, calls the reverse_complement subroutine, and then prints the reverse complement sequence to STDOUT.
 
-- BEGIN SAMPLE RUN --
 
./reverse_complement.pl GAGAGAGAGAGTTTTTTTTT
AAAAAAAAACTCTCTCTCTC
 
-- END SAMPLE RUN --

## 02-reformat-fasta.pl

Create a subroutine that reformats your FASTA file such that the
sequence is reformatted so that it contains certain number of
nucleotides per line. 
 
For example:
 
reformat_seq ($seq , 60 );
 
## sequence before
>seq 1
GAATTCAAGTTCTTGTGCGCACACAAATCCAATAAAAACTATTGTGCACACAGACGCGACTTCGCGGTCTCGCTTGTTCTTGTTGTATTCGTATTTTCATTTCTCGTTCTGTTTCTACTT
AACAATGTGGTGATAATATAAAAAATAAAGCAATTCAAAAGTGTATGACTTAATTAATGAGCGATTTTTTTTTTGAAATCAAATTTTTGGAACATTTTTTTTAAATTCAAATTTTGGCGA
AAATTCAATATCGGTTCTACTATCCATAATATAATTCATCAGGAATACATCTTCAAAGGCAAACGGTGACAACAAAATTCAGGCAATTCAGGCAAATACCGAATGACCAGCTTGGTTATC
 
## sequence after
>seq 1
GAATTCAAGTTCTTGTGCGCACACAAATCCAATAAAAACTATTGTGCACACAGACGCGAC
TTCGCGGTCTCGCTTGTTCTTGTTGTATTCGTATTTTCATTTCTCGTTCTGTTTCTACTT
AACAATGTGGTGATAATATAAAAAATAAAGCAATTCAAAAGTGTATGACTTAATTAATGA
GCGATTTTTTTTTTGAAATCAAATTTTTGGAACATTTTTTTTAAATTCAAATTTTGGCGA
AAATTCAATATCGGTTCTACTATCCATAATATAATTCATCAGGAATACATCTTCAAAGGC
AAACGGTGACAACAAAATTCAGGCAATTCAGGCAAATACCGAATGACCAGCTTGGTTATC

## 03-

Create a subroutine in which you pass in a FASTA file name and in
which you return an array of the id followed by sequence. Your
returned values will be formatted as follows: 

(id1, seq1, id2, seq2, id3, seq3, id4, seq4)

my @seq_records = fastaParser ($fasta_file_name);


How will you handle new lines in your sequences (sequences that have
multiple lines of sequence per record).

