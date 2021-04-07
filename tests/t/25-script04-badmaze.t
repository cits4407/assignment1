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


# script04

my $bad_script04_maze = <<EOF;
###########
           
# # #######
# # #     #
# # #######
# #       
### #######
EOF

diag "maze with extra entries/exits should fail script 04:\n\n";
diag "$bad_script04_maze";

foreach my $n (4) {
  my $res = get_script_output("../quality-check-script-0$n.sh", $bad_script04_maze);
  chomp $res;
  is($res, 'no',  "quality script $n correctly classifies bad maze with extra entries/exits");
}


