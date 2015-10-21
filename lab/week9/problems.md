# Perl VII Problem Set

## Install cpann, local::lib, start-pl

If you have "sudo" privileges (https://xkcd.com/149/), you can install
CPAN (http://cpan.org) modules simply by using the "cpan" or "cpanm" 
commands, e.g.:

    $ sudo cpan -i SQL::Translator

When you are on a machine where you do not have "sudo" privileges, 
you will need to install CPAN modules into your $HOME directory.  This 
is easily done with the "CPAN Minus" (AKA "cpanm") program and "local::lib"
which allows you to install modules "local" for yourself.

Here is a good article that covers this topic.

    http://perlmaven.com/install-perl-modules-without-root-rights-on-linux-ubuntu-13-10

Here is how to install the needed programs on the HPC:

    $ curl -L http://cpanmin.us | perl - App::cpanminus
    $ ~/perl5/bin/cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

Now you need to expand your $PATH to include "~/perl5/bin" and let Perl
know to use the new "local::lib" for modules.  To do this, edit your 
"~/.bashrc" file, e.g.:

    export PATH=$PATH:~/perl5/bin
    eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

Now put the "start-pl" script somewhere in your $PATH, e.g.:

    $ cp start-pl ~/perl5/bin

And install the needed Perl modules:

    $ cpanm 
    $ cpanm Env
    $ cpanm IO::Prompt
    $ cpanm Template
    $ cpanm Perl6::Slurp

Now you can install any CPAN modules you need for your projects, e.g.,
if you see an error like "Can't locate autodie.pm in @INC," then do:

    $ cpanm autodie

Create a directory called "week9," and use the "start-pl" script to 
create all the following scripts, e.g.:

    start-pl 01-subs.pl "subroutine practice"

## 01-subs.pl

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

