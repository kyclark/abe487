# Perl IV Problem Set

Create a directory called "week5."  For each problem, create a script
with the given name.

## 01-mod.pl

Print out the even numbers from @ARGV (use modulus operator).

Expected output:

$ perl 01-mod.pl
Please provide a list of numbers.

$ perl 01-mod.pl 101 2 15 22 95 33 2 27 72 15 52
evens = 2, 22, 2, 72, 52

## 02-mod-sort-sum.pl

Sum the odd and even numbers given on the command line. 

Expected output:

$ perl 02-mod-sort-sum.pl
Please provide a list of numbers.

$ perl 02-mod-sort-sum.pl 1 2 3 4 5 6 7 8 9
sum evens = 20
sum odds = 25

## 03-sort.pl

Using the sort() function with numbers

- Sort the command line arguments with the default sort function and 
  store the result in a new sorted array.
- Print out the array. Are they sorted numerically?
- Customize the sort function to sort the numbers numerically, 
  and store the new sorted array.
- Print out the array. Are they sorted numerically?
- Reverse the numeric sort (hint, switch $a and $b), and 
  store the new sorted array.
- Print out the array. Are they sorted numerically, biggest to smallest?

Expected output:

$ perl 03-sort.pl
Please provide a list of numbers.

$ perl 03-sort.pl 98 2 36 74 27 33
default sort = 2, 27, 33, 36, 74, 98
numerical sort = 2, 27, 33, 36, 74, 98
reverse numercial sort = 98, 74, 36, 33, 27, 2

## 04-array-ops.pl

Using pop, push, shift, unshift 

- Use the list (101, 2, 15, 22, 95, 33, 2, 27, 72, 15, 52)
- Print the array joined on commas
- Use pop on this array. Store the result of pop in a variable.
  Print the contents of this variable. Print the array. How is the
  array different from before the use of pop?
- Use shift on the original array. Store the result of shift in a
  variable. Print the contents of this variable. Print the array.
  How is the array different from before the use of shift?
- Use push on the original array with the number 12. Print the
  array. How is the array different from before the use of push?
- Use unshift on the original array with the number 4. Print the
  array. How is the array different from before the use of
  unshift?

Expected output:

$ perl 04-array-ops.pl
array = 101, 2, 15, 22, 95, 33, 2, 27, 72, 15, 52
popped = 52, array = 101, 2, 15, 22, 95, 33, 2, 27, 72, 15
shifted = 101, array = 2, 15, 22, 95, 33, 2, 27, 72, 15
after push, array = 2, 15, 22, 95, 33, 2, 27, 72, 15, 12
after unshift, array = 4, 2, 15, 22, 95, 33, 2, 27, 72, 15, 12

## 05-string-sort.pl
Sorting strings, use this list: 

- Print the list in sorted order, largest to smallest.
- Print the list in reverse order 

Expected output:

$ perl 05-string-sort.pl
Please provide a list of sequences.

$ perl 05-string-sort.pl ATGCCCGGCCCGGC GCGTGCTAGCAATACGATAAACCGG ATATATATCGAT ATGGGCCC
sorted = ATATATATCGAT, ATGCCCGGCCCGGC, ATGGGCCC, GCGTGCTAGCAATACGATAAACCGG
reverse = GCGTGCTAGCAATACGATAAACCGG, ATGGGCCC, ATGCCCGGCCCGGC, ATATATATCGAT

## 06-string-sort-len.pl

Modify 05-string-sort.pl to print the list sorted by length of 
the strings.

Expected output:

$ perl 06-string-sort-len.pl
Please provide a list of sequences.

$ perl 06-string-sort-len.pl AACT TACCTAG TTACAG
sorted = AACT, TTACAG, TACCTAG
reverse = TACCTAG, TTACAG, AACT

## 07-gc.pl

- Take sequences from the command line
- Print the length of the sequence
- Print a count of the number of C's and G's
- Print the calculated GC content as a percent.
- Should be case-insensitive (to handled masked sequence)

Expected output:

$ perl 06-gc.pl
Please provide a sequence.

$ perl 07-gc.pl GCGTGCTAGCAATACGATAAACCGG
-------
Seq   : GCGTGCTAGCAATACGATAAACCGG
Length: 25
#GC   : 13
%GC   : 52

$ perl 07-gc.pl GCGTGCTagcaatacgatAAACCGG
-------
Seq   : GCGTGCTagcaatacgatAAACCGG
Length: 25
#GC   : 13
%GC   : 52

$ perl 07-gc.pl ATGGGCCC atgcccggcccggc
-------
Seq   : ATGGGCCC
Length: 8
#GC   : 6
%GC   : 75
-------
Seq   : atgcccggcccggc
Length: 14
#GC   : 12
%GC   : 85.7142857142857

## 07-snps.pl

- Take (only) two sequence from the command line 
- Make sure they are equal in length
- Find the single-nucleotide variations (SNPs), reporting the position
  (in starting from position "1" not zero!) and the change from the 
  first to the second sequence

$ perl 08-snps.pl
Please provide two sequences.

$ perl 08-snps.pl AACT ATCGA
Please ensure the sequences are the same length.

$ perl 08-snps.pl AACT AACT
Found 0 SNPs.

$ perl 08-snps.pl AACT AACG
Pos 4: T => G
Found 1 SNP.

$ perl 08-snps.pl AACT AATC
Pos 3: C => T
Pos 4: T => C
Found 2 SNPs.
