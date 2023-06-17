# I think I'm braindead from writing this script, I hope to never open this file again
# This literally took an hour to make, as of writing

use strict;
use warnings;

my $first_filename = '../Cheat Engine/first.pas';
my $mainunit2_filename = '../Cheat Engine/MainUnit2.pas';

sub generate_random_value {
    my @chars = ('a' .. 'z', 'A' .. 'Z');
    my $new_string = join('', map { $chars[rand @chars] } 1 .. 10);
    return $new_string;
}

# Generate a random string for renaming
my $random_string = generate_random_value();

#
# CHANGE FIRST FILE
#

# Read the contents of the Pascal script
open(my $fh_first, '<', $first_filename) or die "Could not open script file '$first_filename': $!";
my @script_lines_first = <$fh_first>;
close($fh_first);

# Modify the content by replacing the values with the generated string
for my $i (0 .. $#script_lines_first) {
    $script_lines_first[$i] =~ s/{\$else}\s*\K\S+/'$random_string/ if $script_lines_first[$i] =~ /{\$else}/i;
    $script_lines_first[$i] =~ s/\Q Engine//g;
}

# Write the modified content back to the Pascal script
open(my $fh_first_out, '>', $first_filename) or die "Could not open script file '$first_filename' for writing: $!";
print $fh_first_out @script_lines_first;
close($fh_first_out);

print "First file content modified successfully.\n";

#
# CHANGE MAINUNIT2 FILE
#

# Remove ' character from random_string
$random_string =~ tr/'//d;

# Read the contents of the Pascal script
open(my $fh_mainunit2, '<', $mainunit2_filename) or die "Could not open script file '$mainunit2_filename': $!";
my @script_lines_mainunit2 = <$fh_mainunit2>;
close($fh_mainunit2);

my $occurrence = 0;

# Modify the content by replacing the current strCheatEngine value with the new value
foreach my $line (@script_lines_mainunit2) {
    if ($line =~ /strCheatEngine\s*=\s*'([^']+)';/) {
        if ($occurrence == 1) { # Skip the first occurence
            my $current_value = $1;
            $line =~ s/\Q$current_value\E/$random_string/g;
            last;  # Assuming there is only one occurrence
        } else {
            $occurrence++;
        }
    }
}

# Write the modified content back to the Pascal script
open(my $fh_mainunit2_out, '>', $mainunit2_filename) or die "Could not open script file '$mainunit2_filename' for writing: $!";
print $fh_mainunit2_out @script_lines_mainunit2;
close($fh_mainunit2_out);

print "MainUnit2 file content modified successfully. New strCheatEngine value: $random_string\n";