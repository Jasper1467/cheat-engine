use strict;
use warnings;

my $filename = '../Cheat Engine/dbk32/DBK32functions.pas';

# Read the contents of the Pascal script
open(my $fh, '<', $filename) or die "Could not open script file '$filename': $!";
my @script_lines = <$fh>;
close($fh);

# Extract the old filename from the script and generate a unique new filename for each occurrence
my %filename_mapping;
foreach my $line (@script_lines) {
    if ($line =~ /sysfile\s*:=\s*'([^']+)';/) {
        my $old_filename = $1;
        my $new_filename = generate_new_filename();
        $filename_mapping{$old_filename} = $new_filename;
    }
}

# Modify the content by replacing the old filenames with the new filenames within string literals
foreach my $line (@script_lines) {
    while ($line =~ /('.*?')/g) {
        my $string_literal = $1;
        foreach my $old_filename (keys %filename_mapping) {
            my $new_filename = $filename_mapping{$old_filename};
            $line =~ s/\Q$string_literal\E/'$new_filename'/ if ($string_literal =~ /\Q$old_filename\E/);
        }
    }
    $line =~ s/__DEV_SCRIPT_DRIVER_CHANGE_TAG__/$filename_mapping{$1}/g if ($line =~ /__DEV_SCRIPT_DRIVER_CHANGE_TAG__/);
}

# Write the modified content back to the Pascal script
open($fh, '>', $filename) or die "Could not open script file '$filename' for writing: $!";
print $fh @script_lines;
close($fh);

print "File content modified successfully.\n";

sub generate_new_filename {
    my @chars = ('a' .. 'z');
    my $new_filename;

    do {
        $new_filename = join('', map { $chars[rand @chars] } 1 .. 10);
    } while ($new_filename =~ /[0-9\W]/);

    return "$new_filename.sys";
}
