use strict;
use warnings;
 
use Test::More;
use IPC::Open2;
use Data::Dumper;
use File::Temp qw/ tempfile tempdir /;

# all scripts should recognize a good maze when they see it

# get_script_output
#
# args: 
# - scriptfile
# - string to send to stdin
sub get_script_output {
  my $scriptfile = shift;
  my $str        = shift;
  my ($tmp_fh, $tmp_filename) = tempfile();
  my $pid = open(WRITEME, "| $scriptfile > $tmp_filename") or die "Couldn't fork: $!\n";
  print WRITEME $str;
  close(WRITEME) or die "Couldn't close: $!\n";
  open my $res_hdl, '<', $tmp_filename or die "Can't open file $!";
  my $res = do { local $/; <$res_hdl> };
  return $res;
}


# use a BEGIN block so we print our plan before any modules loaded
BEGIN { plan tests => 5 }

# good maze

diag "\nall scripts should pass good maze\n";

my $good_maze = <<EOF;
###########
          #
# # #######
# #       #
# # #######
# #        
###########
EOF

foreach my $n (1, 3, 4, 5) {
  my $res = get_script_output("../quality-check-script-0$n.sh", $good_maze);
  chomp $res;
  diag "good 5x3 maze should pass script 0$n:\n\n";
  diag "$good_maze";
  is($res, 'yes',  "quality script $n correctly classifies 5x3 good maze");
}

foreach my $n (2) {
  my $res = get_script_output("../quality-check-script-0$n.sh 5 3", $good_maze);
  chomp $res;
  is($res, 'yes',  "quality script $n correctly classifies 5x3 good maze");
}




