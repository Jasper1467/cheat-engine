use strict;
use warnings;

my $filename = '../Cheat Engine/dbk32/DBK32functions.pas';

# Read the contents of the Pascal script
open(my $fh, '<', $filename) or die "Could not open script file '$filename': $!";
my @script_lines = <$fh>;
close($fh);

# Extract the current servicename from the script
my ($current_servicename) = join('', @script_lines) =~ /servicename\s*:=\s*'([^']+)';/;

if ($current_servicename) {
    my $new_servicename = generate_new_servicename();

    # Modify the content by replacing the current servicename with the new servicename
    foreach my $line (@script_lines) {
        $line =~ s/\Q$current_servicename\E/$new_servicename/g;
    }

    # Write the modified content back to the Pascal script
    open($fh, '>', $filename) or die "Could not open script file '$filename' for writing: $!";
    print $fh @script_lines;
    close($fh);

    print "File content modified successfully. New servicename: $new_servicename\n";
} else {
    print "Current servicename not found in the Pascal script.\n";
}

sub generate_new_servicename {
    my @chars = ('a' .. 'z', 'A' .. 'Z');
    my $new_servicename;

    do {
        $new_servicename = join('', map { $chars[rand @chars] } 1 .. 10);
    } while ($new_servicename eq 'ULTIMAP2');

    return $new_servicename;
}
