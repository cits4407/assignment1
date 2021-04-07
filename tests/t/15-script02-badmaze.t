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


# script02

my $bad_script02_maze = <<EOF;
###########
          #
# # #######
# # #     #
# # #######
# #        
###########
EOF

diag "maze of size 5x3 should fail script 02 if script expects 4x4:\n\n";
diag "$bad_script02_maze";

foreach my $n (2) {
  my $res = get_script_output("../quality-check-script-0$n.sh 4 4", $bad_script02_maze);
  chomp $res;
  is($res, 'no',  "quality script $n correctly classifies 5x3 maze as not being 4x4");
}

