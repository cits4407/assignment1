use strict;
use warnings;
 
use Test::More;
use IPC::Open2;
use Data::Dumper;
use File::Temp qw/ tempfile tempdir /;

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
BEGIN { plan tests => 1 }


# script05

my $bad_script05_maze = <<EOF;
###########
          #
# #########
# #       #
# # #######
# #       
###########
EOF

diag "maze with no route from entry to exit should fail script 05:\n\n";
diag "$bad_script05_maze";

foreach my $n (5) {
  my $res = get_script_output("../quality-check-script-0$n.sh", $bad_script05_maze);
  chomp $res;
  is($res, 'no',  "quality script $n correctly classifies bad maze with no route from entry to exit");
}



