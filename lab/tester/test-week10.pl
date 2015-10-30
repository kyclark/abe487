#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Cwd 'cwd';
use Data::Dumper;
use Getopt::Long;
use File::Basename;
use File::Find::Rule;
use File::Path 'remove_tree';
use File::Spec::Functions;
use Pod::Usage;
use Test::Script::Run qw'run_script run_ok run_not_ok is_script_output';
use Test::More; 

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 


    my $dir = $args{'dir'} or pod2usage('Missing input directory');

    unless (-d $dir) {
        pod2usage("Bad input directory ($dir)");
    }

    my $data_dir = catdir(cwd(), 'data', 'week10');

    unless (-d $data_dir) {
        pod2usage("Can't find data dir ($data_dir)");
    }

    plan(tests => 25);

    #
    # FASTA splitter
    #
    {
        my $t1      = catfile($dir, '01-fasta-splitter.pl');
        my $t1_dir  = catdir($dir, 'split');
        my @t1_args = ('-n', '10', '-o', $t1_dir, 
                      "$data_dir/test.fa", "$data_dir/test2.fa");

        if (-d $t1_dir) {
            remove_tree($t1_dir);
        }

        run_not_ok($t1);

        run_ok($t1, \@t1_args);

        ok(-d $t1_dir, "$t1_dir was created");

        my %t1_files = (
            'test.fa.1'  => [ 2384, 10 ],
            'test.fa.2'  => [ 2085, 10 ],
            'test.fa.3'  => [ 813, 4 ],
            'test2.fa.1' => [ 2992, 10 ],
            'test2.fa.2' => [ 41, 1 ],
        );

        for my $file (sort keys %t1_files) {
            my $path = catfile($t1_dir, $file);
            ok(-e $path, "$file exists");

            my ($size, $nseqs) = @{ $t1_files{ $file } };
            is(-s $path, $size, "size = $size");

            open my $fh, '<', $path;
            my $nfseqs = grep { /^>/ } <$fh>;
            is($nseqs, $nfseqs, "nseqs = $nseqs");
        }
    }
     
    #
    # FASTA search
    #
    {
        my $t2 = catfile($dir, '02-fasta-search.pl');
        run_not_ok($t2);

        my $t2_out = 'Z_.fa';
        if (-e $t2_out) {
            unlink $t2_out;
        }

        run_ok($t2, [catfile($data_dir, 'uniprot.fa'), 'Z_']), 

        ok(-e $t2_out, "outfile ($t2_out) exists)");
        is(-s $t2_out, 4761, "outfile is correct size");

        open my $fh, '<', $t2_out;
        my $nseqs = grep { /^>/ } <$fh>;
        is($nseqs, 23, "nseqs = 23");
    }

    #
    # Find CDS
    #
    {
        my $t3 = catfile($dir, '03-find-cds.pl');

        run_not_ok($t3);
        my @stdout = (
        'U49845 has 3 CDS',
        '1: SSIYNGISTSGLDLNNGTIADMRQLGIVESYKLKRAVVSSASEAAEVLLRVDNIIRARPRTANRQHM',
        '2: MTQLQISLLLTATISLLHLVVATPYEAYPIGKQYPPVARVNESFTFQISNDTYKSSVDKTAQITYNCFDLPSWLSFDSSSRTFSGEPSSDLLSDANTTLYFNVILEGTDSADSTSLNNTYQFVVTNRPSISLSSDFNLLALLKNYGYTNGKNALKLDPNEVFNVTFDRSMFTNEESIVSYYGRSQLYNAPLPNWLFFDSGELKFTGTAPVINSAIAPETSYSFVIIATDIEGFSAVEVEFELVIGAHQLTTSIQNSLIINVTDTGNVSYDLPLNYVYLDDDPISSDKLGSINLLDAPDWVALDNATISGSVPDELLGKNSNPANFSVSIYDTYGDVIYFNFEVVSTTDLFAISSLPNINATRGEWFSYYFLPSQFTDYVNTNVSLEFTNSSQDHDWVKFQSSNLTLAGEVPKNFDKLSLGLKANQGSQSQELYFNIIGMDSKITHSNHSANATSTRSSHHSTSTSSYTSSTYTAKISSTSAAATSSAPAALPAANKTSSHNKKAVAIACGVAIPLGVILVALICFLIFWRRRRENPDDENLPHAISGPDLNNPANKPNQENATPLNNPFDDDASSYDDTSIARRLAALNTLKLDNHSATESDISSVDEKRDSLSGMNTYNDQFQSQSKEELLAKPPVQPPESPFFDPQNRSSSVYMDSEPAVNKSWRYTGNLSPVSDIVRDSYGSQKTVDTEKLFDLEAPEKEKRTSRDVTMSSLDPWNSNISPSPVRKSVTPSPYNVTKHRNRHLQNIQDSQSGKNGITPTTMSTSSSDDFVPVKDGENFCWVHSMEPDRRPSKKRLVDFSNKSNVNVGQVKDIHGRIPEML',
        '3: MNRWVEKWLRVYLKCYINLILFYRNVYPPQSFDYTTYQSFNLPQFVPINRHPALIDYIEELILDVLSKLTHVYRFSICIINKKNDLCIEKYVLDFSELQHVDKDDQIITETEVFDEFRSSLNSLIMHLEKLPKVNDDTITFEAVINAIELELGHKLDRNRRVDSLEEKAEIERDSNWVKCQEDENLPDNNGFQPPKIKLTSLVGSDVGPLIIHQFSEKLISGDDKILNGVYSQYEEGESIFGSLF',
        'NM_001298872 has 1 CDS',
        '1: MDNFGLGGSDLSKGQIFQVLVRLSVASLITYYSVKWMMNQMDPTSKNKKKAKVLAEEQLKRLAEQEGFKLRGQEFSDYELMIASHLVVPADITVSWADIAGLDSVIQELRESVVLPIQHKDLFKHSKLWQAPKGVLLHGPPGCGKTLIAKATAKEAGMRFINLDVAILTDKWYGESQKLTSAVFSLASRIEPCIIFIDEIDSFLRSRNMNDHEATAMMKTQFMMLWDGLSTNANSTVIVMGATNRPQDLDKAIVRRMPAQFHIGLPSETQRKDILKLILQSEEVSQDVDLNRLSKLTNGFSGSDLREMCRNASVYRMRQLITSRDPSATALDRNNVRITMDDLLGSHLKIKESKMHTSSLFLENRIELD'
        );

        is_script_output(
            $t3,
            [catfile($data_dir, 'ncbi-sample-rec.gb'), 
             catfile($data_dir, 'sequence.gb')],
            \@stdout,
        );
    }
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'dir=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

test-week10.pl - test ABE487 week 10 Perl

=head1 SYNOPSIS

  test-week10.pl -d /path/to/scripts

Options:

  --dir    Directory containing Perl scripts to test
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Tests week10.

=head1 SEE ALSO

Test::More.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
