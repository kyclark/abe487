#!/usr/bin/env perl

use strict;
use feature 'say';
use Data::Dumper;
use Bio::DB::GenBank;

my $id  = shift || '195052';
my $gb  = Bio::DB::GenBank->new;
my $seq = $gb->get_Seq_by_id($id);
say Dumper($seq);
