my $n = @ARGV;

print "the number of args = ", scalar(@ARGV), "\n";

print "args = ", join(', ', @ARGV), "\n";

print "what is your name? ";

my $name = <STDIN>;

print "Hello, $name.\n";
