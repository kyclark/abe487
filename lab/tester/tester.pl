#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dumper;
use Getopt::Long;
use File::Spec::Functions;
use Pod::Usage;
use Test::Script::Run qw'is_script_output';
use Test::More 'no_plan';

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

    unless ($args{'dir'}) {
        pod2usage('Missing input directory');
    }

    unless (-d $args{'dir'}) {
        pod2usage("Bad input directory ($args{'dir'})");
    }

    unless ($args{'tests'}) {
        pod2usage('Missing test file');
    }

    unless (-s $args{'tests'}) {
        pod2usage("Bad test file ($args{'tests'})");
    }

    test($args{'tests'}, $args{'dir'});
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'tests=s',
        'dir=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

# --------------------------------------------------
sub read_tests {
    my $file = shift;

    my @tests;
    open my $fh, '<', $file;
    local $/ = '^^';
    while (my $section = <$fh>) {
        chomp($section);
        next unless $section;

        my %rec;
        for my $line (split(/\n/, $section)) {
            next unless $line;
            if ($line =~ /^(\w+)\s*:\s*(.+)$/) {
                my ($key, $value) = ($1, $2);

                if ($key =~ /^std/) {
                    push @{ $rec{ $key } }, $value;
                }
                else {
                    $rec{ $key } = $value;
                }
            }
        }

        push @tests, \%rec;
    }

    close $fh;

    return @tests;
}

# --------------------------------------------------
sub test {
    my ($test_file, $in_dir) = @_;

    my @tests = read_tests($test_file);

    chdir($in_dir);

    for my $test (@tests) {
        my $path = $test->{'script'};
        my $args = [];
        if ($test->{'args'}) {
            $test->{'args'} =~ s/^"|"$//g;
            $args = [ split(/\s+/, $test->{'args'}) ];
        }

        if (-e $path) {
            is_script_output(
                $path,
                $args,
                $test->{'stdout'} // [],
                $test->{'stderr'} // [],
            );
        }
        else {
            say "Skipping $path (does not exist)";
        }
    }

    done_testing();
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

tester.pl - a script

=head1 SYNOPSIS

  tester.pl -t tests.txt -d /path/to/scripts

Options:

  --tests  Text file of tests
  --dir    Directory containing Perl scripts to test
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Reads tests from an input file and applies them to the script in the 
input directory.

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
