#!/usr/bin/perl
# ------------------------------------------------------------------------
# This file:     /usr/local/nagios/sbin/InterfaceTableReset.cgi
#
# Permissions:   
#
# # ls -la /usr/local/nagios/sbin/InterfaceTableReset.cgi
# -rwxr-xr-x 1 nagios nagios 2522 Nov 16 13:14 /usr/local/nagio<...>
#
# Purpose:
#
# Simple cgi script to reset information in files from /tmp/.ifState
#
# URL example (should be one line): 
#
# http://nagios.itdesign.at/nagios/cgi-bin/InterfaceTableReset.cgi?Comma
# nd=rm&What=/tmp/.ifState/server1-Interfacetable.txt
#

use strict;

use lib "/usr/local/nagios/perl/lib/";
use lib "/usr/local/icinga/perl/lib/";
use Config::General;
use Data::Dumper;
use CGI qw(:standard);


# grab command line options
my $grefhOpt={};

# convert commandline arguments into hash
while (defined $ARGV[0]) {
    if ($ARGV[0] =~ /^-/) {
        $ARGV[0] =~ s/-//g;        
        $grefhOpt->{"$ARGV[0]"} = "$ARGV[1]";
    }
    shift;
}

# set debug environment variable
$grefhOpt->{Debug} and $ENV{WIT_DBG}="1";

# ------------------------------------------------------------------------

my $grefhFile;                                       # Properties from the interface file
my $gInterfaceInformationFile = param('What');


print header;
print start_html('Table Reset'),
    h1('Interface Table Reset Procedure'),
    hr;
print 
    "Resetting...",
    hr;
        
if ($ENV{WIT_DBG}) {
    print 
        "Your want to reset: ",em(param('What')),
        hr;
}

# ------------------------------------------------------------------------------
# Read data
# ------------------------------------------------------------------------------

# read all interfaces and its properties into the hash
$grefhFile = ReadInterfaceInformationFile ("$gInterfaceInformationFile");

if ($ENV{WIT_DBG}) { 
    print pre(Dumper ($grefhFile)); 
}

# ------------------------------------------------------------------------------
# clean up
# ------------------------------------------------------------------------------

# we reset the last reset of the file -> next run of the check script will recognize this
delete $grefhFile->{TableReset};
delete $grefhFile->{If};
#delete $grefhFile->{MD};

if ($ENV{WIT_DBG}) { 
    print 
        "so we do reset: ",em(param('What')),
        hr;
    print pre(Dumper ($grefhFile));
}

# ------------------------------------------------------------------------------
# write interface information file
# ------------------------------------------------------------------------------

WriteConfigFileNew ("$gInterfaceInformationFile",$grefhFile);

print 
    "New set of reference data saved. The interface table and the raised alarms will be resetted at the next check launch.",
    hr;

print q(<a href=JavaScript:history.back();>Back to the table</a>);

print end_html;

# ------------------------------------------------------------------------
#      MAIN ENDS HERE
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# Read config file with the perl Config::General Module
#
#   http://search.cpan.org/search?query=Config%3A%3AGeneral&mode=all
#
# ------------------------------------------------------------------------
sub ReadConfigFileNew {

    my $ConfigFile = shift;

    my $refoConfig; # object definition for the config
    my $refhConfig; # hash reference returned

    # return undef if file is not readable
    -r "$ConfigFile" or return $refhConfig;

    # Initialize ConfigFile Read Process (create object)
    $refoConfig = new Config::General (
        -ConfigFile             => "$ConfigFile",
        -UseApacheInclude       => "false",
        -MergeDuplicateBlocks   => "false",
        -InterPolateVars        => "false",
    );

    # Read Config File
    %$refhConfig = $refoConfig->getall;

    # return reference
    return $refhConfig;
}
# ------------------------------------------------------------------------
# --- write a hash reference to a file --- see ReadConfigFileNew ---------
#
# $gFile = full qulified filename with path
# $refhStruct = hash reference
#
# ------------------------------------------------------------------------
sub WriteConfigFileNew {
    my $ConfigFile   =   shift;
    my $refhStruct   =   shift;

    use File::Basename;

    my $refoConfig; # object definition for the config
    my $Directory = dirname ($ConfigFile);

    # Initialize ConfigFile Read Process (create object)
    $refoConfig = new Config::General (
        -ConfigPath => "$Directory"
    );

    # Write Config File
    if (-f "$ConfigFile" and not -w "$ConfigFile") {
        print "Unable to write to file $ConfigFile $!\n";
        #exit $STATE_UNKNOWN;
    }

    $refoConfig->save_file("$ConfigFile", $refhStruct);
    $ENV{WIT_DBG} and print "Wrote interface data to file: $ConfigFile\n";

    return 0;
}

# ------------------------------------------------------------------------
# Read all interfaces and its properties into the hash $grefhFile
# ------------------------------------------------------------------------
sub ReadInterfaceInformationFile {

    my $InterfaceInformationFile = shift;

    my $grefhFile;

    # read all properties from the state file - store into $grefhFile
    if (-r "$InterfaceInformationFile") {
        $grefhFile = ReadConfigFileNew ("$InterfaceInformationFile");
    } else {
        # the file with interface information was not found - this is the first
        # run of the program or it was deleted before
    }
    return $grefhFile;
}



