# Perl VI Problem Set

## 01-palindrome.pl

Write a program named "pali.pl" to detect palindromes. It must be able
to handle changes in case.
 
    # 01-palindrome.pl "Madam in Eden Im Adam"
 
yes!
 
% pali.pl gatcctag
 
yes!
 
% pali.pl "cold spring harbor laboratory"
 
                  no!
 
## 02-palindrome.pl

Modify the program to work even if there is extraneous punctuation  (Hint:s///):
 
 % pali.pl "A man, a plan, a canal... Panama"
 
  yes!
 
## 03-sub.pl

In the Nobody.txt file substitute every occurrence of 'Nobody' with
a name given on the command line (default to "George").

## 04-fasta.pl

Find all the lines in a FASTA file that are the header (>seqName desc)
using pattern matching.

## 05-fasta-desc.pl

If a line matches the format of a FASTA header, extract the sequence
name and description using sub patterns as well as $1 and $2. 

    - Print id:"extracted seq name" desc:"extracted description"

## 06-fasta-hash.pl

Create or modify your FASTA parser to use regular expressions. Also
make sure your parser can deal with a sequence that is split over many
lines.

## 07-

The enzyme ApoI has a restriction site: R^AATTY where R and Y are degenerate
nucleotideides. See the IUPAC table to identify the nucleotide possibilities
for the R and Y.

Write a regular expression that will match occurrences of the site in
a sequence. (hint: what are you going to do about the actual cut site,
represented by the '^'?)

## 08-restriction.pl

Use the regular expression you just wrote to find all the restriction
sites in the following sequence. Be sure to think about how to handle
the newlines!

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

## 09-cut-sites.pl

Determine the site(s) of the cut in the above sequence. Print out
the sequence with "^" at the cut site.

Hints:
Use subpatterns (parentheses and $1, $2) to find the cut site within
the pattern.

    Use s///

Example: if the pattern is GACGT^CT the following sequence

    AAAAAAAAGACGTCTTTTTTTAAAAAAAAGACGTCTTTTTTT

would be cut like this:

    AAAAAAAAGACGT^CTTTTTTTAAAAAAAAGACGT^CTTTTTTT

## 10-frag-length.pl

Now that you've done your restriction digest, determine the lengths of
your fragments and sort them by length (in the same order they would
separate on an electrophoresis gel).

Hint: take a look at the split man page or think about storing your matches in an array. With one of these two approaches you should be able to convert this string:

    AAAAAAAAGACGT^CTTTTTTTAAAAAAAAGACGT^CTTTTTTT

into this array:

    ("AAAAAAAAGACGT","CTTTTTTTAAAAAAAAGACGT","CTTTTTTT")


# EXTRA CREDIT

(Choose one)

## ec-1.pl

Use the data file from rebase.neb.com
(http://rebase.neb.com/rebase/link_bionet) to fill a hash of enzymes,
their recognition patterns 

## ec-2.l

Ask a user for the designed enzyme, then cut their supplied sequence,
returning the number of fragments, the fragments in their natural
order (unsorted), and finally sorted from biggest to smallest
fragment.
