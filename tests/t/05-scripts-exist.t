use strict;
use warnings;
 
use Test::More;
use IPC::Open2;
use Data::Dumper;
use File::Temp qw/ tempfile tempdir /;

# use a BEGIN block so we print our plan before any modules loaded
BEGIN { plan tests => 10 }

foreach my $n (1..5) {
  ok( -e "../quality-check-script-0$n.sh", "quality script $n exists");
}

foreach my $n (1..5) {
  ok( -x "../quality-check-script-0$n.sh", "quality script $n executable");
}

