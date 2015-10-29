# Perl V Problem Set (20 points)

Create a directory called "week7."  For each problem, create a script
with the given name.

To receive credit, the scripts must compile and produce the expected
output.  Programs that take command-line arguments will be tested
with different arguments than given here, so try your programs with
different input.

Points off for failing to "use autodie" when doing IO (input/output) 
or for useing GLOBAL_SYMBOLS over $proper_scalars.

## 01-cities.pl (3 points)

Create a hash of cities and states (capitals, cities where you lived,
etc.) using the "all at once" method.

    # "All at once":
    my %hash = ( 
        key1 => 'value1', 
        key2 => 'value2', 
        key3 => 'value3',
    ); 

Add "use Data::Dumper" and then print out the structure like so:

  say Dumper(\%hash);

Then print out the cities in alphabetical order with their cardinal 
positions.

Expected output:

    [catalina@~/work/abe487/lab/week7]$ perl 01-hash.pl
    $VAR1 = {
              'Tucson' => 'AZ',
              'Boston' => 'MA',
              'Jackson' => 'MS',
              'Dixon' => 'NM',
              'Denton' => 'TX',
              'Cincinnati' => 'OH'
            };

    1: Boston, MA
    2: Cincinnati, OH
    3: Denton, TX
    4: Dixon, NM
    5: Jackson, MS
    6: Tucson, AZ

NB: 

1) If you lived in a city like "St. Louis," you cannot leave off the 
   quotation marks around the key.

2) There is a big difference if you leave out the backslash when called 
   "Dumper" because the hash gets flattened into a list and you lose the 
   key/value structure.

3) Notice that the order of the keys hash is likely different from
   how you declared it and how it prints with Data::Dumper.

## 02-fasta-hash.pl (3 points)

Take a command-line argument of a FASTA file, default to
"Perl_V.genesAndSeq.txt".  Open the file, and create a hash with the
sequence ID for your key and the sequence for your value.  Report the
names of the sequences and their lengths sorted by sequence length.

    [catalina@~/work/abe487/lab/week7]$ perl 02-fasta-hash.pl
    Bden|BDEG_00353: 194
    Bden|BDEG_03796: 301
    Bden|BDEG_00317: 371
    Bden|BDEG_06990: 376
    Bden|BDEG_02250: 408
    [catalina@~/work/abe487/lab/week7]$ perl 02-fasta-hash.pl test.fa
    bar: 50
    baz: 102
    foo: 102

## 03-common-words.pl (4 points)

Take two file names from the command line and report the words that
are found in common.  Be sure to remove non-characters with something 
like this:

    $word =~ s/[^A-Za-z0-9]//g;

Expected output:

    $ perl 03-common-words.pl green-eggs.txt fox-in-socks.txt
    that
    fox
    here
    try
    say
    be
    not
    do
    box
    if
    a
    in
    thank
    i
    on
    the
    with
    you
    see
    and
    they
    like
    so
    or
    Found 24 words in common.

## 04-kmer-count.pl (10 points)

Take a sequence from the command line and possibly a "length" argument
(default 3).  If the "sequence" argument is an existing file, read the
contents of the file.  

Using a printf format of "%-15s %10s\n" to report:

- the length of the sequence
- mer size
- the number of possible kmers 
- the number of kmers found
- the number of kmers found only once (singletons)
- the top 10 (or fewer) most common kmers (if any)

NB: The number of possible kmers is (n - k + 1) where 
    n = length of sequence 
    k = kmer size

Expected output:

    $ perl 04-kmer-count.pl
    Please provide a sequence.

    $ touch empty
    $ perl 02-kmer-count.pl empty
    Zero-length sequence.

    $ perl 04-kmer-count.pl A
    Cannot get any 3 mers from a sequence of length 1

    $ perl 04-kmer-count.pl AAA
    Sequence length          3
    Mer size                 3
    Number of kmers          1
    Unique kmers             1
    Num. singletons          1

    $ perl 04-kmer-count.pl TTTGATACTCCTATTAAGTAA 2
    Sequence length         21
    Mer size                 2
    Number of kmers         20
    Unique kmers            12
    Num. singletons          7
    Most abundant
    TA: 4
    TT: 3
    AT: 2
    CT: 2
    AA: 2

    $ perl 04-kmer-count.pl mouse.fa 8
    Sequence length      42162
    Mer size                 8
    Number of kmers      42155
    Unique kmers         27330
    Num. singletons      17858
    Most abundant
    TATTTTTT: 14
    CGGAAGAG: 13
    ATTTTTTT: 13
    ATCGGAAG: 13
    GGAAGAGC: 12
    AAAAATAT: 12
    TCGGAAGA: 12
    GATCGGAA: 12
    AAAAGAAA: 12
    AGATCGGA: 11
