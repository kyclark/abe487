my $file = 'jabberwocky.txt';

if (-x $file) {
    print "Are you sure you want to overwrite '$file'?\n";
}
