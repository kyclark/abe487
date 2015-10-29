# Week 10

These problems all use BioPerl modules, so start off by installing those.

## Install LWP

Sometimes BioPerl makes queries over the Internet (e.g., to NCBI/Genbank) 
for data, so it will need the LWP (libwww-perl) module:

    $ cpanm MIME::Base64
    $ cpanm LWP

## Install Bio::Perl

BioPerl has many useful scripts that you will want installed.  It is 
easiest to "build" BioPerl from the source code to make this happen.
The command "cpanm --look" downloads the module, unpacks it, and 
then creates a new shell inside the distribution directory.  When you 
are finished, press ctrl-D to exit the shell.  If for some reason you
are not in the newly create distribution directory, cd to there.

    $ cpanm --look Bio::Perl
    $ perl Build.PL
    $ ./Build install

After running "perl Build.PL," accept all defaults, esp. allowing
BioPerl to install sample scripts, then go into your "~/perl5/bin" dir
and have a look.

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

# Problems

## 01-fasta-splitter.pl

Use "Bio::SeqIO" to write a script that splits FASTA files into
smaller files with a maxium number of sequences (default 500) into a
given output directory (default the current working directory).

Modules/functions you might find useful:

* File::Spec::Functions 'catfile'
* File::Basename 'basename'
* File::Path 'make_path'

Exected output:

    $ ./01-fasta-splitter.pl -h
    Usage:
          01-fasta-splitter.pl -n 20 -o ~/split file1.fa [file2.fa ...]

        Options (defaults in parentheses):

          --number  The maxmimum number of sequences per file (500)
          --out_dir Output directory (cwd)
          --help    Show brief help and exit
          --man     Show full documentation

    $ ./01-fasta-splitter.pl -n 10 -o ~/split test.fa test2.fa
        1: test.fa
          -> /home/u20/kyclark/split/test.fa.1
          -> /home/u20/kyclark/split/test.fa.2
          -> /home/u20/kyclark/split/test.fa.3
        2: test2.fa
          -> /home/u20/kyclark/split/test2.fa.1
          -> /home/u20/kyclark/split/test2.fa.2
    Done.

## 02-fasta-search.pl

Download/gunzip "uniprot_sprot" using the Unix command "wget":

    $ wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
    $ gunzip uniprot_sprot.fasta.gz

Remember: wget is not a crime (cf. Aaron Schwartz)

NB: You probably found on the "obese/lean" project that you cannot add
large files to Github.  To will prevent Git from adding files matching
the patterns you determine, create a ".gitignore" file in your
"week10" directory like this:

    $ cat .gitignore
    uniprot*

Use "Bio::SeqIO" and "Bio::DB::Fasta" to write a Perl script to
retrieve all IDs from a FASTA file matching a given pattern using
a regular expression match.

For later scripts, you will need to search for "HDAC" in 
"uniprot_sprot.fasta."  You will probably want to use the 
"get_all_primary_ids" method from "Bio::DB::Fasta."  
(Check out the BioPerl Deobfuscator for more information.)

Print the sequences for these proteins, in FASTA format, to a 
file like "<pattern>.fa."  You will need to get rid of any non-word
characters from the pattern before using it as a filename (hint:
use a regular expression with the s// command).

    $ ./02-fasta-search.pl -h
    Usage:
          02-fasta-search.pl file.fa pattern

        Options:

          --help   Show brief help and exit
          --man    Show full documentation

    $ ./02-fasta-search.pl uniprot_sprot.fasta HDAC
    Searching 'uniprot_sprot.fasta' for 'HDAC'
    Found 44 ids
    See results in 'HDAC.fa'

    $ ./02-fasta-search.pl uniprot_sprot.fasta 'HDAC[0-5]'
    Searching 'uniprot_sprot.fasta' for 'HDAC[0-5]'
    Found 28 ids
    See results in 'HDAC05.fa'

    $ ./02-fasta-search.pl uniprot_sprot.fasta blarg
    Searching 'uniprot_sprot.fasta' for 'blarg'
    Found 0 ids

NB: Be patient the first time this runs as it has to create the needed
indexes for searching.

## 03-find-cds.pl

Download a GenBank record, e.g.:

    http://www.ncbi.nlm.nih.gov/nuccore/NM_001286260.1

Or use the "sequence.gb" record from my "data" directory.

Use "Bio::SeqIO" to write Perl script that prints out the coding
regions (coding domain sequences, CDS) of the sequences from Genbank
records.  The script should be able to handle multiple input files, 
multiple sequences per file, and multiple CDSs per sequence.

NB: Always think about solving for 0, 1, or infinity.

    $ ./03-find-cds.pl -h
    Usage:
          03-find-cds.pl rec.gb [rec2.gb ...]

        Options:

          --help   Show brief help and exit
          --man    Show full documentation

    $ ./03-find-cds.pl sequence.gb ncbi-sample-rec.gb
    NM_001298872 has 1 CDS
    1: MDNFGLGGSDLSKGQIFQVLVRLSVASLITYYSVKWMMNQMDPTSKNKKKAKVLAEEQLKRLAEQEGFKLRGQEFSDYELMIASHLVVPADITVSWADIAGLDSVIQELRESVVLPIQHKDLFKHSKLWQAPKGVLLHGPPGCGKTLIAKATAKEAGMRFINLDVAILTDKWYGESQKLTSAVFSLASRIEPCIIFIDEIDSFLRSRNMNDHEATAMMKTQFMMLWDGLSTNANSTVIVMGATNRPQDLDKAIVRRMPAQFHIGLPSETQRKDILKLILQSEEVSQDVDLNRLSKLTNGFSGSDLREMCRNASVYRMRQLITSRDPSATALDRNNVRITMDDLLGSHLKIKESKMHTSSLFLENRIELD
    U49845 has 3 CDS
    1: SSIYNGISTSGLDLNNGTIADMRQLGIVESYKLKRAVVSSASEAAEVLLRVDNIIRARPRTANRQHM
    2: MTQLQISLLLTATISLLHLVVATPYEAYPIGKQYPPVARVNESFTFQISNDTYKSSVDKTAQITYNCFDLPSWLSFDSSSRTFSGEPSSDLLSDANTTLYFNVILEGTDSADSTSLNNTYQFVVTNRPSISLSSDFNLLALLKNYGYTNGKNALKLDPNEVFNVTFDRSMFTNEESIVSYYGRSQLYNAPLPNWLFFDSGELKFTGTAPVINSAIAPETSYSFVIIATDIEGFSAVEVEFELVIGAHQLTTSIQNSLIINVTDTGNVSYDLPLNYVYLDDDPISSDKLGSINLLDAPDWVALDNATISGSVPDELLGKNSNPANFSVSIYDTYGDVIYFNFEVVSTTDLFAISSLPNINATRGEWFSYYFLPSQFTDYVNTNVSLEFTNSSQDHDWVKFQSSNLTLAGEVPKNFDKLSLGLKANQGSQSQELYFNIIGMDSKITHSNHSANATSTRSSHHSTSTSSYTSSTYTAKISSTSAAATSSAPAALPAANKTSSHNKKAVAIACGVAIPLGVILVALICFLIFWRRRRENPDDENLPHAISGPDLNNPANKPNQENATPLNNPFDDDASSYDDTSIARRLAALNTLKLDNHSATESDISSVDEKRDSLSGMNTYNDQFQSQSKEELLAKPPVQPPESPFFDPQNRSSSVYMDSEPAVNKSWRYTGNLSPVSDIVRDSYGSQKTVDTEKLFDLEAPEKEKRTSRDVTMSSLDPWNSNISPSPVRKSVTPSPYNVTKHRNRHLQNIQDSQSGKNGITPTTMSTSSSDDFVPVKDGENFCWVHSMEPDRRPSKKRLVDFSNKSNVNVGQVKDIHGRIPEML
    3: MNRWVEKWLRVYLKCYINLILFYRNVYPPQSFDYTTYQSFNLPQFVPINRHPALIDYIEELILDVLSKLTHVYRFSICIINKKNDLCIEKYVLDFSELQHVDKDDQIITETEVFDEFRSSLNSLIMHLEKLPKVNDDTITFEAVINAIELELGHKLDRNRRVDSLEEKAEIERDSNWVKCQEDENLPDNNGFQPPKIKLTSLVGSDVGPLIIHQFSEKLISGDDKILNGVYSQYEEGESIFGSLF

    $ ./03-find-cds.pl mult.gb
    U49845 has 3 CDS
    1: SSIYNGISTSGLDLNNGTIADMRQLGIVESYKLKRAVVSSASEAAEVLLRVDNIIRARPRTANRQHM
    2: MTQLQISLLLTATISLLHLVVATPYEAYPIGKQYPPVARVNESFTFQISNDTYKSSVDKTAQITYNCFDLPSWLSFDSSSRTFSGEPSSDLLSDANTTLYFNVILEGTDSADSTSLNNTYQFVVTNRPSISLSSDFNLLALLKNYGYTNGKNALKLDPNEVFNVTFDRSMFTNEESIVSYYGRSQLYNAPLPNWLFFDSGELKFTGTAPVINSAIAPETSYSFVIIATDIEGFSAVEVEFELVIGAHQLTTSIQNSLIINVTDTGNVSYDLPLNYVYLDDDPISSDKLGSINLLDAPDWVALDNATISGSVPDELLGKNSNPANFSVSIYDTYGDVIYFNFEVVSTTDLFAISSLPNINATRGEWFSYYFLPSQFTDYVNTNVSLEFTNSSQDHDWVKFQSSNLTLAGEVPKNFDKLSLGLKANQGSQSQELYFNIIGMDSKITHSNHSANATSTRSSHHSTSTSSYTSSTYTAKISSTSAAATSSAPAALPAANKTSSHNKKAVAIACGVAIPLGVILVALICFLIFWRRRRENPDDENLPHAISGPDLNNPANKPNQENATPLNNPFDDDASSYDDTSIARRLAALNTLKLDNHSATESDISSVDEKRDSLSGMNTYNDQFQSQSKEELLAKPPVQPPESPFFDPQNRSSSVYMDSEPAVNKSWRYTGNLSPVSDIVRDSYGSQKTVDTEKLFDLEAPEKEKRTSRDVTMSSLDPWNSNISPSPVRKSVTPSPYNVTKHRNRHLQNIQDSQSGKNGITPTTMSTSSSDDFVPVKDGENFCWVHSMEPDRRPSKKRLVDFSNKSNVNVGQVKDIHGRIPEML
    3: MNRWVEKWLRVYLKCYINLILFYRNVYPPQSFDYTTYQSFNLPQFVPINRHPALIDYIEELILDVLSKLTHVYRFSICIINKKNDLCIEKYVLDFSELQHVDKDDQIITETEVFDEFRSSLNSLIMHLEKLPKVNDDTITFEAVINAIELELGHKLDRNRRVDSLEEKAEIERDSNWVKCQEDENLPDNNGFQPPKIKLTSLVGSDVGPLIIHQFSEKLISGDDKILNGVYSQYEEGESIFGSLF
    NM_001298872 has 1 CDS
    1: MDNFGLGGSDLSKGQIFQVLVRLSVASLITYYSVKWMMNQMDPTSKNKKKAKVLAEEQLKRLAEQEGFKLRGQEFSDYELMIASHLVVPADITVSWADIAGLDSVIQELRESVVLPIQHKDLFKHSKLWQAPKGVLLHGPPGCGKTLIAKATAKEAGMRFINLDVAILTDKWYGESQKLTSAVFSLASRIEPCIIFIDEIDSFLRSRNMNDHEATAMMKTQFMMLWDGLSTNANSTVIVMGATNRPQDLDKAIVRRMPAQFHIGLPSETQRKDILKLILQSEEVSQDVDLNRLSKLTNGFSGSDLREMCRNASVYRMRQLITSRDPSATALDRNNVRITMDDLLGSHLKIKESKMHTSSLFLENRIELD

How would you write a parser for a Genbank file?  Here is mine:

    http://cpansearch.perl.org/src/KCLARK/Bio-GenBankParser-0.05/lib/Bio/GenBankParser.pm
