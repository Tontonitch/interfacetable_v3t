#!/usr/bin/perl
# nagios: -epn

=head1 NAME

  check_interface_table_v3t.pl -H <host> -C <community string> [OPTIONS]

=head1 DESCRIPTION

=head2 Introduction

B<check_interface_table_v3t.pl> is a Nagios(R) plugin that allows you to monitor
one network device (e.g. router, switch, server) without knowing each interface
in detail. Only the hostname (or ip address) and the snmp community string are
required.

  Simple Example:

  # check_interface_table_v3t.pl -H server1 -C public

  Output:

  <a href="/nagios/interfacetable/server1-Interfacetable.html">total 3 interface(s)</a>

The above example polls our netware server (server1) and reads all interfaces.
The output is a HTML link to a web page which shows all interface in a table.

When clicking on the link the output looks like:

  server1 updated: Fri Nov 16 13:22:08 2007 (1 sec.)

  Name      Uptime        System Information
  ---------------------------------------------------------------
  server1 71d 17h 56m   Novell NetWare 5.70.06 October 26, 2006

  index Description Alias AdminStatus OperStatus Speed IP
  --------------------------------------------------------
  1 HP NC10xx/... Gigabit Server Adapter   up up 1.00 Gbit 10.1.1.4/255.255.0.0
  2 HP NC10xx/... Gigabit Server Adapter (0x000f2097890c)   up up 1.00 Gbit 10.4.1.2/255.255.0.0
  3 3COM Etherlink PCI   up up 100.00 Mbit 192.168.17.4/255.255.0.0

  [back] [reset table]

The first line tells the name and when the table was last updated.
(1 sec.) means that the polling process took one second.

"Name", "Uptime" and "System Information" are for information only.

The table below these information fields shows different interface properties.
The last line has two ascii buttons which allow to navigate back and to reset the table.

=head2 Theory of operation

The perl program polls the remote machine in a highly efficient manner.
It collects all data from all interfaces and stores these data into the directory
/tmp/.ifState.

  Each host (option -H) holds one text file:

  # ls /tmp/.ifState/*.txt
  /tmp/.ifState/server1-Interfacetable.txt

When the program is called twice, three times, etc. it retreives new
information from the network and compares it against this state file.

=head1 SYNOPSIS

  check_interface_table_v3t.pl -H <host> -C <snmp community> [options]
  check_interface_table_v3t.pl -H <host> -C <snmp community> -w <warn> -c <crit> [options]

=head1 PREREQUISITS

This chapter describes the operating system prerequisits to get this program
running:

=head2 net-snmp installed

The B<snmpwalk> command must be available on your operating system.

  Test your snmpwalk output with a command like:

  # snmpwalk -Oqn -v 1 -c public router.itdesign.at | head -3

  .1.3.6.1.2.1.1.1.0 Cisco IOS Software, 2174 Software Version 11.7(3c), REL.
  SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport
  Copyright (c) 1986-2005 by Cisco Systems, Inc.
  Compiled Mon 22-Oct-03 9:46 by antonio
  .1.3.6.1.2.1.1.2.0 .1.3.6.1.4.1.9.1.620
  .1.3.6.1.2.1.1.3.0 9:11:09:19.48

  snmpwalk parameters:

  -Oqn -v 1 ............ some noise (please read "man snmpwalk")
  -c public  ........... snmp community string
  router.itdesign.at ... host where you do the snmp queries

B<snmpwalk> is part of the net-snmp suit (http://net-snmp.sourceforge.net/).
Some more unix commands to find it:

  # whereis snmpwalk
  snmpwalk: /usr/bin/snmpwalk /usr/share/man/man1/snmpwalk.1.gz

  # which snmpwalk
  /usr/bin/snmpwalk

  # rpm -qa | grep snmp
  net-snmp-5.3.0.1-25.15

  # rpm -ql net-snmp-5.3.0.1-25.15 | grep snmpwalk
  /usr/bin/snmpwalk
  /usr/share/man/man1/snmpwalk.1.gz

=head2 PERL V5 installed

You need a working perl 5.x installation. Currently we use V5.8.8 under
SUSE Linux Enterprise Server 10 SP1 for development. We know that it works
with other versions, too.

Get your perl version with:

  # perl -V

=head2 PERL Net::SNMP library

B<Net::SNMP> is the perl's snmp library. Some ideas to see if it is installed:

  # rpm -qa|grep -i perl|grep -i snmp
  perl-Net-SNMP-5.2.0-12.2

  # find /usr -name SNMP.pm
  /usr/lib/perl5/vendor_perl/5.8.8/Net/SNMP.pm

  if it is not installed please check your operating systems packages or install it
  from CPAN:

  http://search.cpan.org/search?query=Net%3A%3ASNMP&mode=all

=head2 PERL Config::General library installed

B<Config::General> is the only "excotic" library typically not installed on your OS.
We use this excelent library to write all interface information data back to the
file system.

  See:

  http://search.cpan.org/search?query=Config%3A%3AGeneral&mode=all

Version 2.31 of this library is part of the kit here - but it should work with
newer versions, too.

Installation is quite easy - extract the kit and type

  perl Makefile.PL
  make
  make install

=head2 CGI script to reset the interface table

If everything is working fine you need the possibility to reset the interface table.
Often it is necessary that someone changes ip addresses or other properties. These
changes are necessary and you want to update (=reset) the table.

Resetting the table means to delete the state file in /tmp/.ifState.

Withing this kit you find an example shell script which does this job for you.
To install this cgi script do the following:

  1) Copy the cgi script to the correct location on your WEB server

  # cp -i InterfaceTableReset_v3t.cgi /usr/local/nagios/sbin

  2) Check permissions

  # ls -l /usr/local/nagios/sbin/InterfaceTableReset_v3t.cgi
  -rwxr-xr-x 1 nagios nagios 2522 Nov 16 13:14 /usr/local/nagios/sbin/Inte...

  3) Prepare the /etc/sudoers file so that the web server's account can call
  the cgi script (as shell script)

  # visudo
  wwwrun ALL=(ALL) NOPASSWD: /usr/local/nagios/sbin/InterfaceTableReset_v3t.cgi

The above unix commands are tested under SUSE Linux Enterprise Server 10 SP1
with apache2 installed and nagios Version 3 compiled into /usr/local/nagios.

Please send me an email if you have information from other operating systems
on these details. I will update the documentation.

=head2 Configure Nagios 3.x to display HTML links in Plugin Output

In Nagios version 3.x there is html output per default disabled.

  1) Edit cgi.cfg and set this option to zero
      escape_html_tags=0

cgi.cfg is located in your configuration directory. (/usr/local/nagios/etc on
SuSe Linux)

=head1 OPTIONS

=head2 -H <host> (required option)

 no default

Specifies the remote host to poll.

=head2 -C <snmp community string> (required)

 default = public

Specifies the snmp version 1 community string. Other snmp versions are not
implemented.

=head2 -w <warning counter> (optional)

Must be a positiv integer number. Changes in the interface table are compared
against this threshold.

  Example:

    ... -H server1 -C public -w 1

  Leads to WARNING (exit code 1) when one or more interface properties were
  changed.

=head2 -c <critical counter> (optional)

Must be a positiv integer number. Changes in the interface table are compared
against this threshold.

  Example:

    ... -H server1 -C public -c 1

  Leads to CRITICAL (exit code 2) when one or more interface properties were
  changed.

=head2 -Exclude <interface description> [optional]

Let's you exclude some interfaces from tracking. This is useful when you know
that some interfaces tend to flap and you do not want to track these.

  Example:

  ... -H router -C public -Exclude Dialer0,BVI20,FastEthernet0

Interface descriptions must match exactly!

=head2 -Include <interface description> [optional]

This is the opposite to the -Exclude option and incudes only some
interfaces.

  Example:

  ... -H router -C public -Ixclude FastEthernet0,FastEthernet1

=head2 -HTMLDir <directory> (optional)

 default = /usr/local/nagios/share/interfacetable

Sets another directory where the interfae HTML files are stored. Specifies the
path in the file system. See option B<-HTMLUrl> for changing the HTML link.

=head2 -HTMLUrl <url praefix> (optional)

 default = /nagios/interfacetable

B<-HTMLUrl> allows you to change the URL praefix in the output of the plugin.

  Example 1:

  # check_interface_table.txt -H server1 -C public -HTMLUrl ''
  <a href="/server1-Interfacetable.html">total 3 interface(s)</a>

  Example 2:

  # check_interface_table.txt -H server1 -C public -HTMLUrl 'https://server1/iftbls'
  <a href="https://server1/iftbls/server1-Interfacetable.html">total 3 interface(s)</a>

Specifies the HTML link only. See option B<HTMLDir> for the file system path.

=head2 -ResetUrl <url praefix> (optional)

B<-ResetUrl> allows you to change the URL praefix for the reset cgi program.

  Example - SUSE Linux paths':

  # check_interface_table/check_interface_table.txt -H server1 -C public \
    -HTMLDir '/srv/www/htdocs' -ResetUrl 'cgi-bin' -HTMLUrl ''

=head2 -StateDir <directory> (optional)

 default = /tmp/.ifState

Sets another directory where the interfae states are stored.

  Example:

  check_interface_table.txt -H server1 -C public -StateDir '/var/tmp'

Interface states are stored in a reference txt file. This option
changes the file system location of that file.

ATTENTION! When implementing the "table reset" feature you must modify your
InterfaceTableReset_v3t program, too.

=head2 -h <host> (optinal option)

 if omitted it defaults to the host with -H

Specifies the remote host to display in the HTML link.

 Example:

 check_interface_table_v3t.pl -h firewall -H srv-itd-99.itdesign.at -C mkjz65a

This option is maybe useful when you want to poll a host with -H and display
another link for it.


=head1 ATTENTION - KNOWN ISSUES

=head2 Interaction with Nagios

If you use this program with Nagios then it is typically called in the "nagios"
users context. This means that the user "nagios" must have the correct permissions
to write all required files into the filesystem (see chapter "Theory of operation").

=head2 Reset table

The "reset table button" is the next challange. Clicking in the web browser means to
trigger the "InterfaceTableReset_v3t" script which then tries to remove the state
file.

 If this does not work please check the following:

 * correct directory and permissions of InterfaceTableReset_v3t
 * correct entry in the /etc/sudoers file
 * look at /var/log/messages or /var/log/secure to see what "sudo" calls
 * look at the web servers access and error log files

=head2 /tmp cleanup

Some operating systems clean up the /tmp directory during reboot (I know that
OpenBSD does this). This leads to the problem that the /tmp/.ifState directory
is deleted and you loose your interface information states. The solution for
this is to set the -StateDir <directory> switch from command line.

=head2 umask on file and directory creation

This program generats some files and directories on demand:

  /tmp/.ifState ... directory with table states
  /tmp/.ifCache ... directory with caching data
  /usr/local/nagios/share/interfacetable ... directory with html tables

To avoid file system conflicts we simply set the umask to 0000 so that all
files and directories are created with everyone read/write permissions.

If you don't want this - change the $UMASK variable in this program and
test it very carefully - especially under the account where the program is
executed.

  Example:

  # su - nagios
  nagios> check_interface_table_v3t.pl -H <host> -C <community string> -Debug 1

=head1 LICENSE

This program was demonstrated by ITdesign during the Nagios conference in
Nuernberg (Germany) on the 12th of october 2007. Normally it is part of the
commercial suite of monitoring add ons around Nagios from ITdesign.
This version is free software under the terms and conditions of GPLV3.

Netways had adapted it to include performance data and calculate bandwidth
usage. So now the features mentioned in the COMMERCIAL Version section are
available in this GPL version.

Copyright (C) [2007]  [ITdesign Software Projects & Consulting GmbH]
Copyright (C) [2009]  [Netways GmbH]

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along
with this program; if not, see <http://www.gnu.org/licenses/>.

=head1 COMMERCIAL Version

This version differs from our commercial version in the following:

 * Throughput on each intefcace is measured and displayed as graphs
 * Warning and critical can be set on throughput, too
 * Frequency of updates and bug fixes

Why dont't we have these features here?

From the technical point of view it is very time consuming to extract
these features out of our closed suite of add ons around nagios so
we decided not to do it.

What is out commercial version?

Our commercial suite of add ons around nagios contains the following
features:

 * Service Level Agreement calculation
 * AS/400, iSeries Monitoring
 * VMWARE ESX Monitoring
 * Servicemonitorung
 * Graph and Reports
 * Extended notification possibilities (distribution lists,
   Notify by mobile phone, UDP, FTP, etc.)
 * and much much more

More details see:

 http://www.watchit.at

=head1 CONTACT INFORMATION

 Werner Neunteufl
 ITdesign Software Projects & Consulting
 Anton Freunschlaggasse 49, 1230 Wien
 Werner.Neunteufl@itdesign.at

=cut

# ------------------------------------------------------------------------
# COPYRIGHT:
#
# This software is Copyright (c) 2009 NETWAYS GmbH, Birger Schmidt
#                                <info@netways.de>
#      (Except where explicitly superseded by other copyright notices)
#
# LICENSE:
#
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from http://www.fsf.org.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.fsf.org.
#
# CONTRIBUTION SUBMISSION POLICY:
#
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to NETWAYS GmbH.)
#
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# this Software, to NETWAYS GmbH, you confirm that
# you are the copyright holder for those contributions and you grant
# NETWAYS GmbH a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
#
# Nagios and the Nagios logo are registered trademarks of Ethan Galstad.
# ------------------------------------------------------------------------

use strict;
use warnings;

use lib "/usr/local/nagios/libexec";
use lib "/usr/local/icinga/libexec";
use Net::SNMP qw(oid_base_match);
use Config::General;
use Data::Dumper;
use Getopt::Long;
use utils qw(%ERRORS $TIMEOUT); # gather variables from utils.pm

# ========================================================================
# VARIABLES
# ========================================================================

# ------------------------------------------------------------------------
# global variable definitions
# ------------------------------------------------------------------------
use vars qw($PROGNAME $REVISION $CONTACT $TIMEOUT);
$PROGNAME       = $0;
$REVISION       = '3.0.0';
$CONTACT        = 'tontonitch-pro@yahoo.fr';
#$TIMEOUT       = 120;
#my %ERRORS     = ('OK'=>0,'WARNING'=>1,'CRITICAL'=>2,'UNKNOWN'=>3,'DEPENDENT'=>4);
my %ERRORCODES  = (0=>'OK',1=>'WARNING',2=>'CRITICAL',3=>'UNKNOWN',4=>'DEPENDENT');
my %COLORS      = ('HighLight' => '#81BEF7', 'PerfGraph' => '#DCFAC9');
my $UMASK       = "0000";
my $TMPDIR      = File::Spec->tmpdir();         # define cache directory or use /tmp
my $STARTTIME   = time ();                                      # time of program start
# NOT USED - my $refhPath = {};

# ------------------------------------------------------------------------
# OIDs definitions
# ------------------------------------------------------------------------

my $oid_sysDescr        = ".1.3.6.1.2.1.1.1.0";
my $oid_sysName         = ".1.3.6.1.2.1.1.5.0";
my $oid_sysUpTime       = ".1.3.6.1.2.1.1.3.0";

my $oid_ifDescr         = ".1.3.6.1.2.1.2.2.1.2";   # + ".<index>"
my $oid_ifSpeed         = ".1.3.6.1.2.1.2.2.1.5";   # + ".<index>"

my $oid_ifPhysAddress   = ".1.3.6.1.2.1.2.2.1.6";   # + ".<index>"
my $oid_ifAdminStatus   = ".1.3.6.1.2.1.2.2.1.7";   # + ".<index>"
my $oid_ifOperStatus    = ".1.3.6.1.2.1.2.2.1.8";   # + ".<index>"
my %gh_operstatus       = ('up'=>1,'down'=>2,'testing'=>3,'unknown'=>4,'dormant'=>5);
my $oid_ifLastChange    = ".1.3.6.1.2.1.2.2.1.9";   # + ".<index>"

# RFC1213 - Extracts about in/out stats
# ------------------------------------------------------------------------
# in_octet:     The total number of octets received on the interface, including framing characters.
# in_error:     The number of inbound packets that contained errors preventing them from being deliverable to a
#                               higher-layer protocol.
# in_discard:   The number of inbound packets which were chosen to be discarded even though no errors had been
#                               detected to prevent their being deliverable to a higher-layer protocol. One possible reason for
#                               discarding such a packet could be to free up buffer space.
# out_octet:    The total number of octets transmitted out of the interface, including framing characters.
# out_error:    The number of outbound packets that could not be transmitted because of errors.
# out_discard:  The number of outbound packets which were chosen to be discarded even though no errors had been
#                               detected to prevent their being transmitted. One possible reason for discarding such a packet could
#                               be to free up buffer space.
# ------------------------------------------------------------------------
my $oid_in_octet_table          = '1.3.6.1.2.1.2.2.1.10';    # + ".<index>"
my $oid_in_error_table          = '1.3.6.1.2.1.2.2.1.14';    # + ".<index>"
my $oid_in_discard_table        = '1.3.6.1.2.1.2.2.1.13';    # + ".<index>"
my $oid_out_octet_table         = '1.3.6.1.2.1.2.2.1.16';    # + ".<index>"
my $oid_out_error_table         = '1.3.6.1.2.1.2.2.1.20';    # + ".<index>"
my $oid_out_discard_table       = '1.3.6.1.2.1.2.2.1.19';    # + ".<index>"
# NOT USED - my $oid_in_octet_table_64  = '1.3.6.1.2.1.31.1.1.1.6';  # + ".<index>"
# NOT USED - my $oid_out_octet_table_64 = '1.3.6.1.2.1.31.1.1.1.10'; # + ".<index>"

# Cisco Specific
my $oid_cisco_type              = '.1.3.6.1.4.1.9.5.1.2.16.0'; # ex: WS-C3550-48-SMI
my $oid_cisco_serial            = '.1.3.6.1.4.1.9.5.1.2.19.0'; # ex: CAT0645Z0HB
# NOT USED - my $oid_locIfIntBitsSec = '1.3.6.1.4.1.9.2.2.1.1.6';   # need to append integer for specific interface
# NOT USED - my $oid_locIfOutBitsSec = '1.3.6.1.4.1.9.2.2.1.1.8';   # need to append integer for specific interface
# NOT USED - my $cisco_ports         = '.1.3.6.1.4.1.9.5.1.3.1.1.14.1'; # number of ports of the switch

my $oid_ifAlias                 = ".1.3.6.1.2.1.31.1.1.1.18"; # + ".<index>"

# Vlan oid per manufacturer
# ------------------------------------------------------------------------
# Cisco: ifVlan = ".1.3.6.1.4.1.9.9.68.1.2.2.1.2";
# HP:    ifVlan = ".1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.1.1.1";
# ------------------------------------------------------------------------
my $oid_ifVlanName              = '.1.3.6.1.2.1.47.1.2.1.1.2'; # + ".<index>"
my $oid_ifVlanPortHP            = '.1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.2'; # + ".<index>"
my $oid_ifVlanPortCisco         = '.1.3.6.1.4.1.9.9.68.1.2.2.1.2'; # + ".?.<index>"

my $oid_ipAdEntIfIndex          = ".1.3.6.1.2.1.4.20.1.2";
my $oid_ipAdEntNetMask          = ".1.3.6.1.2.1.4.20.1.3";

# ------------------------------------------------------------------------
# Other global variables
# ------------------------------------------------------------------------
my %ghOptions = ();

# ========================================================================
# FUNCTION DECLARATIONS
# ========================================================================
sub check_options();

# ========================================================================
# MAIN
# ========================================================================

# Get command line options and adapt default values in %ghOptions
check_options();

my $gInfoTable;                                      # Generated HTML code of the Info table
my $grefaInfoTableHeader = [                         # Header for the colomns of the Info table
    'Name','Uptime','System Information','Type','Serial','Ports',
    'delta seconds used for bandwidth calculations'
    ];                        
my $grefaInfoTableData;                              # Contents of the Info table (Uptime, SysDescr, ...)

my $gInterfaceTable;                                 # Html code of the interface table
my $grefaInterfaceTableHeader = [                    # Header for the cols of the html table
    'index','Description','Alias','AdminStatus','OperStatus','Speed',
    'Load In','Load Out','IP','bpsIn','bpsOut','last traffic'
    ];
my $grefaInterfaceTableFields = [                    # Hash keys for the content of the html table
    'index','ifDescr','ifAlias','ifAdminStatus','ifOperStatus','ifSpeedReadable',
    'ifLoadIn','ifLoadOut','IpInfo','bpsIn','bpsOut','ifLastTraffic'
    ];
if ($ghOptions{'vlan'}) { 
    # show VLANs per port
    splice(@$grefaInterfaceTableFields,6,0,'ifVlanNames');
    splice(@$grefaInterfaceTableHeader,6,0,'VLANs');
}
my $grefaInterfaceTableData;                         # Contents of the interface table (Uptime, OperStatus, ...)

my $grefaAllIndizes;                                 # Sorted array which holds all interface indexes
my $gUsedDelta                       = 0;            # time delta for bandwidth calculations (really used)

my $gInitialRun                      = 0;            # Flag that will be set if there exists no interface information file
my $gDifferenceCounter               = 0;            # Number of changes. This variable is used in the exitcode algorithm
my $gIfLoadWarnCounter               = 0;            # counter for interfaces with load warning. This variable is used in the exitcode algorithm
my $gIfLoadCritCounter               = 0;            # counter for interfaces with critical load. This variable is used in the exitcode algorithm
my $gNumberOfInterfaces              = 0;            # Total number of interfaces including vlans ...
my $gNumberOfFreeInterfaces          = 0;            # in "check_for_unused_interfaces" counted number of free interfaces
my $gNumberOfFreeUpInterfaces        = 0;            # in "check_for_unused_interfaces" counted number of free interfaces with status AdminUp
my $gNumberOfInterfacesWithoutTrunk  = 0;            # in "check_for_unused_interfaces" counted number of interfaces WITHOUT trunk ports
my $gInterfacesWithoutTrunk          = {};           # in "check_for_unused_interfaces" we use this for counting
my $gNumberOfPerfdataInterfaces      = 0;            # in "EvaluateInterfaces" counted number of interfaces we collect perfdata for
my $gPerfdata                        = "";           # performancedata
        # This is the base for the short and long cache timer.

my $grefaIPLines;                                    # Lines returned from snmpwalk storing ip addresses
my $grefaOperStatusLines;                            # Lines returned from snmpwalk storing ifOperStatus
my $grefaOctetInLines;                               # Lines returned from snmpwalk storing ifOctetsIn
my $grefaOctetOutLines;                              # Lines returned from snmpwalk storing ifOctetsOut
my $grefaInErrorsLines;                              # Lines returned from snmpwalk storing ifPktsInErr
my $grefaOutErrorsLines;                             # Lines returned from snmpwalk storing ifPktsOutErr
my $grefaInDiscardsLines;                            # Lines returned from snmpwalk storing ifPktsInDiscard
my $grefaOutDiscardLines;                            # Lines returned from snmpwalk storing ifPktsOutDiscard
my $gShortCacheTimer                 = 0;            # Short cache timer are calculated in ExtractCache timer routine
my $gLongCacheTimer                  = 0;            # Long cache timer are calculated in ExtractCache timer routine
my $gText;                                           # Plugin Output ...
my $gChangeText;                                     # Contains data of changes in interface properties
my $grefhSNMP;                                       # Temp snmp structure
my $grefhFile;                                       # Properties from the interface file
my $grefhCurrent;                                    # Properties from current interface states


# create uniq file name without extension
my $gFile =  normalize($ghOptions{'hostdisplay'}).'-Interfacetable';

# file where we store interface information table
my $gInterfaceInformationFile = "$ghOptions{'statedir'}/$gFile.txt";

# If -snapshot is set or DisableTrackingChanges is disabled on all interfaces
# we dont track changes
if (($ghOptions{'track'} and ($ghOptions{'track'}[0] eq "NONE")) or $ghOptions{'snapshot'}) {
    $gInitialRun = 1;
}

# ------------------------------------------------------------------------------
# Read data
# ------------------------------------------------------------------------------

# get uptime of the host - no caching !
$grefhCurrent->{MD}->{sysUpTime} = GetUptime ([ "$oid_sysUpTime" ],0);

# read all interfaces and its properties into the hash
$grefhFile = ReadInterfaceInformationFile ("$gInterfaceInformationFile");
logger(3, "grefhFile:".Dumper ($grefhFile));

# get sysDescr and sysName caching the long parameter
#$grefhSNMP = GetMultipleDataWithSnmp ([ "$oid_sysDescr","$oid_sysName" ],$gLongCacheTimer);
$grefhSNMP = GetMultipleDataWithSnmp ([ "$oid_sysDescr","$oid_sysName","$oid_cisco_type","$oid_cisco_serial" ],$gLongCacheTimer);
$grefhCurrent->{MD}->{sysDescr} = "$grefhSNMP->{$oid_sysDescr}";
$grefhCurrent->{MD}->{sysName}  = "$grefhSNMP->{$oid_sysName}";
$grefhCurrent->{MD}->{cisco_type}   = "$grefhSNMP->{$oid_cisco_type}";
$grefhCurrent->{MD}->{cisco_serial} = "$grefhSNMP->{$oid_cisco_serial}";

# get lines with interface oper status - no caching !
$grefaOperStatusLines = GetDataWithUnixSnmpWalk ($oid_ifOperStatus,0);

if ($#$grefaOperStatusLines < 0 ) {
    print "$0: Could not read ifOperStatus information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

# -----------------------------------------------------------------
# Get lines with interface octet counters - no caching !

# -> Octets in
$grefaOctetInLines = GetDataWithUnixSnmpWalk ($oid_in_octet_table,0);
if ($#$grefaOctetInLines < 0 ) {
    print "$0: Could not read ifOctetIn information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

# -> Octets out
$grefaOctetOutLines = GetDataWithUnixSnmpWalk ($oid_out_octet_table,0);
if ($#$grefaOctetOutLines < 0 ) {
    print "$0: Could not read ifOctetOut information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

# -> Packet errors in
$grefaInErrorsLines = GetDataWithUnixSnmpWalk ($oid_in_error_table,0);
if ($#$grefaInErrorsLines < 0 ) {
    print "$0: Could not read ifInErrors information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

# -> Packet errors out
$grefaOutErrorsLines = GetDataWithUnixSnmpWalk ($oid_out_error_table,0);
if ($#$grefaOutErrorsLines < 0 ) {
    print "$0: Could not read ifOutErrors information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

# -> Packet discards in
$grefaInDiscardsLines = GetDataWithUnixSnmpWalk ($oid_in_discard_table,0);
if ($#$grefaInDiscardsLines < 0 ) {
    print "$0: Could not read ifInDiscards information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

# -> Packet discards out
$grefaOutDiscardLines = GetDataWithUnixSnmpWalk ($oid_out_discard_table,0);
if ($#$grefaOutDiscardLines < 0 ) {
    print "$0: Could not read ifOutDiscards information from host \"$ghOptions{'hostquery'}\" with snmp\n";
    exit $ERRORS{"UNKNOWN"};
}

Get_TraficInOut ($grefaOctetInLines, "OctetsIn", "BitsIn");
Get_TraficInOut ($grefaOctetOutLines, "OctetsOut", "BitsOut");
Get_IfErrInOut ($grefaInErrorsLines, "PktsInErr");
Get_IfErrInOut ($grefaOutErrorsLines, "PktsOutErr");
Get_IfDiscardInOut ($grefaInDiscardsLines, "PktsInDiscard");
Get_IfDiscardInOut ($grefaOutDiscardLines, "PktsOutDiscard");


# get lines with ip addresses - no caching !
$grefaIPLines = GetDataWithUnixSnmpWalk ($oid_ipAdEntIfIndex,0);

# extract ifIndex and ifOperStatus out of the lines and get the
# ifDescription from the net or from cache
Get_OperStatus_Description_Index ($grefaOperStatusLines);

# get IP Address and SubnetMask from the net or from cache
Get_IpAddress_SubnetMask ($grefaIPLines);

# get ifAdminStatus, ifSpeed and ifAlias from the net or from cache
Get_AdminStatus_Speed_Alias_Vlan ($grefhCurrent);

logger(3, " Get interface info -> generated hash\ngrefhCurrent:".Dumper ($grefhCurrent));

# ------------------------------------------------------------------------------
# Include / Exclude interfaces
# ------------------------------------------------------------------------------

# Save include/exclude information of each interface in the metadata
$grefhCurrent = EvaluateInterfaces ($ghOptions{exclude}, $ghOptions{include});
logger(3, " Include / Exclude interfaces -> generated hash\ngrefhCurrent:".Dumper ($grefhCurrent));

# ------------------------------------------------------------------------------
# Create interface information table data
# ------------------------------------------------------------------------------

# sort ifIndex by number
@$grefaAllIndizes = sort { $a <=> $b }
    keys (%{$grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}});
logger(3, " Interface information table data -> generated array\ngrefaAllIndizes:".Dumper ($grefaAllIndizes));

my $basetime = CleanAndSelectHistoricalDataset();
(defined $basetime) and CalculateBps($basetime);

# ------------------------------------------------------------------------------
# write perfdata stdout and files
# ------------------------------------------------------------------------------
if ( $gNumberOfPerfdataInterfaces > 0 and not $gInitialRun) {
    perfdataout();
}

# ------------------------------------------------------------------------------
# write interface information file
# ------------------------------------------------------------------------------

# first run - the hash from the file is empty because we had no file before
# fill it up with all interface intormation and with the index tables
#
# we take a separate field where we remember the last reset
# of the entire file
if (not $grefhFile->{TableReset}) {
    $grefhFile->{TableReset} = scalar localtime time ();
    $grefhFile->{If} = $grefhCurrent->{If};
    logger(1, " (Debug) Initial run -> $grefhFile->{TableReset}");
}

# Fill up the MD tree (MD = MetaData) - here we store all variable
# settings
$grefhFile->{MD} = $grefhCurrent->{MD};

# ------------------------------------------------------------------------------
# write interface information file
# ------------------------------------------------------------------------------

WriteConfigFileNew ("$gInterfaceInformationFile",$grefhFile);

# ------------------------------------------------------------------------------
# STDOUT
# ------------------------------------------------------------------------------

# If there are changes in the table write it to stdout
if ($gChangeText) {
    $gText = $gChangeText . "$gNumberOfInterfacesWithoutTrunk interface(s)";
} else {
    $gText = "$gNumberOfInterfacesWithoutTrunk interface(s)"
}

#logger(3, "gInterfacesWithoutTrunk: " . Dumper (%{$gInterfacesWithoutTrunk}));
for my $switchport (keys %{$gInterfacesWithoutTrunk}) {
    if ($gInterfacesWithoutTrunk->{$switchport}) {
        # this port is free
        $gNumberOfFreeInterfaces++
    }
}
#TODO go critical...
if ( $gNumberOfFreeInterfaces >= 0 ) {
    logger(1, "---->>> ports: $gNumberOfInterfacesWithoutTrunk, free: $gNumberOfFreeInterfaces");
    $gText .= ", $gNumberOfFreeInterfaces free";
}

if ( $gNumberOfFreeUpInterfaces > 0 ) {
    $gText .= ", $gNumberOfFreeUpInterfaces AdminUp and free";
}

if ( $gNumberOfPerfdataInterfaces > 0 and $ghOptions{'enableportperf'}) {
    $gText .= ", $gNumberOfPerfdataInterfaces graphed";         # thd
}

# ------------------------------------------------------------------------------
# Create host information table data
# ------------------------------------------------------------------------------

$grefaInfoTableData->[0]->[0]->{Value} = "$grefhCurrent->{MD}->{sysName}";
$grefaInfoTableData->[0]->[1]->{Value} = TimeDiff (1,$grefhCurrent->{MD}->{sysUpTime} / 100); # start at 1 because else we get "NoData"
$grefaInfoTableData->[0]->[2]->{Value} = "$grefhCurrent->{MD}->{sysDescr}";
$grefaInfoTableData->[0]->[3]->{Value} = "$grefhCurrent->{MD}->{cisco_type}";
$grefaInfoTableData->[0]->[4]->{Value} = "$grefhCurrent->{MD}->{cisco_serial}";
$grefaInfoTableData->[0]->[5]->{Value} = "ports:&nbsp;$gNumberOfInterfacesWithoutTrunk free:&nbsp;$gNumberOfFreeInterfaces";
$grefaInfoTableData->[0]->[5]->{Value} .= " AdminUpFree:&nbsp;$gNumberOfFreeUpInterfaces";
if ($ghOptions{'delta'}) {$grefaInfoTableData->[0]->[6]->{Value} = "$ghOptions{'delta'}" }
else { $grefaInfoTableData->[0]->[6]->{Value} =  'no data to compare with'; }

#
# Generate Html Table
# do not compare ifDescr and ifIndex because they can change during reboot
# Field list: index,ifDescr,ifAlias,ifAdminStatus,ifOperStatus,ifSpeedReadable,ifVlanNames,ifLoadIn,ifLoadOut,IpInfo,bpsIn,bpsOut,ifLastTraffic
#
$grefaInterfaceTableData = GenerateHtmlTable ($grefaInterfaceTableFields,$ghOptions{track});

# ------------------------------------------------------------------------------
# Create HTML tables
# ------------------------------------------------------------------------------

my $EndTime = time ();
my $TimeDiff = $EndTime-$STARTTIME;

# If current run is the first run we dont compare data
if ( $gInitialRun ) {
    logger(1, " (Debug) Initial run -> Setting DifferenceCounter to zero.");
    $gDifferenceCounter = 0;
    $gText = "$gNumberOfInterfacesWithoutTrunk interface(s)";
} else {
    logger(1, " (Debug) Differences: $gDifferenceCounter");
    if ($gDifferenceCounter > 0) { $gText .= ", $gDifferenceCounter change(s)"; }
}

# Create "mini" info table
$gInfoTable = Csv2Html ($grefaInfoTableHeader,$grefaInfoTableData);

# Create "big" interface table
$gInterfaceTable   = Csv2Html ($grefaInterfaceTableHeader,$grefaInterfaceTableData);

# ------------------------------------------------------------------------------
# Calculate exitcode and exit this program
# ------------------------------------------------------------------------------

# $gDifferenceCounter contains the number of changes which
# were made in the interface configurations
my $ExitCode = mcompare ({
    Value       => $gDifferenceCounter,
    Warning     => $ghOptions{warning},
    Critical    => $ghOptions{critical}
});

#if ($gNumberOfFreeUpInterfaces > 0) {
#    $ExitCode = $ERRORS{'WARNING'} if ($ExitCode ne $ERRORS{'CRITICAL'});
#}

if ($gIfLoadWarnCounter > 0 ) {
    $ExitCode = $ERRORS{'WARNING'} if ($ExitCode ne $ERRORS{'CRITICAL'});
    $gText .= ", load warning: $gIfLoadWarnCounter";
}

if ($gIfLoadCritCounter > 0 ) {
    $ExitCode = $ERRORS{'CRITICAL'};
    $gText .= ", load critical: $gIfLoadCritCounter";
}

# Append html table link to text
$gText = AppendLinkToText({
          Text        => $gText,
          HtmlUrl     => $ghOptions{'htmlurl'},
          File        => "$gFile.html"
        });

if ($grefhCurrent->{MD}->{cisco_type} ne '' and $grefhCurrent->{MD}->{cisco_serial} ne '') {
    $gText = "$grefhCurrent->{MD}->{cisco_type} ($grefhCurrent->{MD}->{cisco_serial}): ". $gText;
}

# Write Html Table
WriteHtmlTable ({
    Header      => $gInfoTable,
    Body        => $gInterfaceTable,
    Dir         => $ghOptions{'htmldir'},
    FileName    => "$ghOptions{'htmldir'}/$gFile".'.html'
});

# Print Text and exit with the correct exitcode
ExitPlugin ({
    ExitCode    =>  $ExitCode,
    Text        =>  $gText,
    Fields      =>  $gDifferenceCounter
});

# This code should never be reached
exit $ERRORS{"UNKNOWN"};

# ------------------------------------------------------------------------
#      MAIN ENDS HERE
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
# write performance data for
#  - netways nagios grapher
#  - or pnp4nagios
# perfdataout ();
# ------------------------------------------------------------------------
sub perfdataout {
    if ($ghOptions{perfdatadir}) { # perfdata to file
        my $filename = $ghOptions{perfdatadir} . "/service-perfdata.$STARTTIME";
        umask "$UMASK";
        open (OUT,">>$filename") or die "cannot open $filename $!";
        flock (OUT, 2) or die "cannot flock $filename $!"; # get exclusive lock;
        }
    # $grefaAllIndizes is a indexed and sorteted list of all interfaces
    for my $InterfaceIndex (@$grefaAllIndizes) {
        # Get normalized interface name (key for If data structure)
        my $oid_ifDescr = $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$InterfaceIndex};

        if ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} eq "false" and defined $grefhCurrent->{MD}->{IfIndexTable}->{OctetsIn}->{$InterfaceIndex}) {

            my $port = sprintf("%03d", $InterfaceIndex);
            #my $servicename = "Port$port";
            my $servicename = "If_" . trim(denormalize($grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$InterfaceIndex}));
            $servicename =~ s/[: ]/_/g;
            $servicename =~ s/[()]//g;
            #my $servicename = 'Interface - ' . trim(denormalize($grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$InterfaceIndex}));
            my $perfdata = "";
            if ($ghOptions{'portperfunit'} eq "octet") {
                    $perfdata .= "${servicename}::check_interface_table_port_octet::" . # servicename::plugin
                             "OctetsIn=$grefhCurrent->{MD}->{IfIndexTable}->{OctetsIn}->{$InterfaceIndex}c;;;0; " .
                             "OctetsOut=$grefhCurrent->{MD}->{IfIndexTable}->{OctetsOut}->{$InterfaceIndex}c;;;0; ";
            } else {
                    $perfdata .= "${servicename}::check_interface_table_port_bit::" . # servicename::plugin
                             "BitsIn=$grefhCurrent->{MD}->{IfIndexTable}->{BitsIn}->{$InterfaceIndex}c;;;0; " .
                             "BitsOut=$grefhCurrent->{MD}->{IfIndexTable}->{BitsOut}->{$InterfaceIndex}c;;;0; ";
            }
            #Add pkt errors/discards if available
            if (defined $grefhCurrent->{MD}->{IfIndexTable}->{PktsInErr}->{$InterfaceIndex}) {
                $perfdata .= "PktsInErr=$grefhCurrent->{MD}->{IfIndexTable}->{PktsInErr}->{$InterfaceIndex}c;;;0; " .
                             "PktsOutErr=$grefhCurrent->{MD}->{IfIndexTable}->{PktsOutErr}->{$InterfaceIndex}c;;;0; " .
                             "PktsInDiscard=$grefhCurrent->{MD}->{IfIndexTable}->{PktsInDiscard}->{$InterfaceIndex}c;;;0; " .
                             "PktsOutDiscard=$grefhCurrent->{MD}->{IfIndexTable}->{PktsOutDiscard}->{$InterfaceIndex}c;;;0; ";
            }
            #Add interface status if available
            if (defined $grefhCurrent->{MD}->{IfIndexTable}->{OperStatus}->{$InterfaceIndex}) {
                $perfdata .= "OperStatus=".$gh_operstatus{"$grefhCurrent->{MD}->{IfIndexTable}->{OperStatus}->{$InterfaceIndex}"}.";;;0; ";
            }

            logger(1, "collected perfdata: $oid_ifDescr\t$perfdata");
            if ($ghOptions{perfdatadir}) { # perfdata to file
                #TODO: make it atomic (ie rename after write) and use a save filename
                print OUT "$grefhCurrent->{MD}->{sysName}\t";  # hostname
                print OUT "$servicename";                      # servicename
                print OUT "\t\t";                              # pluginoutput
                print OUT "$perfdata";                         # performancedata
                print OUT "\t$STARTTIME\n";                   # unix timestamp
                        }

            if($ghOptions{'enableportperf'}){$gPerfdata .= " $perfdata"; }      # thd collect performancedata
        }
    } # for $InterfaceIndex
    if (defined $ghOptions{perfdatadir}) { # perfdata to file
        close (OUT);
        }
    return 0;
}

# ------------------------------------------------------------------------
# Create interface table html table file
# This file will be visible on the browser
#
# WriteHtmlTable ({
#    Header      => $gInfoTable,
#    Body        => $gInterfaceTable,
#    FileName    => $gHtmlFileName
# });
#
# ------------------------------------------------------------------------
sub WriteHtmlTable {

    my $refhStruct = shift;

    my $Footer = HtmlLinks ({
        Back            =>  1,
        ResetTable      =>  "$gInterfaceInformationFile"
    });

    umask "$UMASK";

                not -d $refhStruct->{Dir} and MyMkdir($refhStruct->{Dir});

    open (OUT,">$refhStruct->{FileName}") or die "cannot $refhStruct->{FileName} $!";
        print OUT '
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>' . $grefhCurrent->{MD}->{sysName} . '</title>
    <script type="text/javascript">
      function ChangeColor(tableRow, highLight) {
        if (highLight) { tableRow.style.backgroundColor = "' . $COLORS{"HighLight"} . '"; }
        else { tableRow.style.backgroundColor = "' . $COLORS{"PerfGraph"} . '"; }
      }
      function DoNav(theUrl) {
        document.location.href = theUrl;
      }
    </script>
  </head>
<body>
';
        print OUT '<center><pre><a href="' . $ghOptions{'accessmethod'} . '://',$ghOptions{'hostquery'},'">',$ghOptions{'hostquery'},'</a>',
            ' updated: ',scalar localtime $EndTime,' (',$EndTime-$STARTTIME,' sec.)</pre>';
        print OUT $refhStruct->{Header};
        print OUT $refhStruct->{Body};
        print OUT $Footer;
        print OUT '<center></body></html>';
    close (OUT);
    return 0;
}

# ------------------------------------------------------------------------
# Source:
#   extracted from or our base library - but shortand
# Purpose:
#   calc exit code
# ------------------------------------------------------------------------
sub mcompare {

    my $refhStruct = shift;

    my $ExitCode = $ERRORS{"OK"};

    $refhStruct->{Warning} and $refhStruct->{Value} >= $refhStruct->{Warning}
        and $ExitCode = $ERRORS{"WARNING"};

    $refhStruct->{Critical} and $refhStruct->{Value} >= $refhStruct->{Critical}
        and $ExitCode = $ERRORS{"CRITICAL"};

    return $ExitCode;
}

# ------------------------------------------------------------------------
# Compare data from refhFile and refhCurrent and create the csv data for
# html table.
# ------------------------------------------------------------------------
sub GenerateHtmlTable {

    my $refaFields               = shift;               # Array of the fields for the table
    my $refaToCompare            = shift;               # Array of fields which should be included from change tracking
    my $iLineCounter             = 0;                   # Fluss Variable (ah geh ;-) )
    my $refaContentForHtmlTable;                        # This is the final data structure which we pass to csv2htmlnew
    my $DataForMD5CheckSum       = "";                  # MD5 Checksum

    # Print a header for debug information
    logger(1, "x"x50);
    
    # Print tracking info
    logger(3, "Available fields:".Dumper($refaFields));
    logger(3, "Tracked fields:".Dumper($refaToCompare));
    
    # $grefaAllIndizes is a indexed and sorteted list of all interfaces
    for my $InterfaceIndex (@$grefaAllIndizes) {

        # Current field ID
        my $iFieldCounter = 0;

        # Get normalized interface name (key for If data structure)
        my $oid_ifDescr = $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$InterfaceIndex};

        # Netways Nagios Grapher - one link per line/interface/port
        if ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} eq "false" and defined $grefhCurrent->{MD}->{IfIndexTable}->{OctetsIn}->{$InterfaceIndex}) {
            #my $servicename = 'Port' . sprintf("%03d", $InterfaceIndex);
            my $servicename = "If_" . trim(denormalize($grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$InterfaceIndex}));
            $servicename =~ s/#/%23/g;
            $servicename =~ s/:/_/g;
            $servicename =~ s/[()]//g;
            $refaContentForHtmlTable->[ $iLineCounter ]->[ $iFieldCounter ]->{InterfaceGraphURL} =
                '/pnp4nagios/graph?host=' . $ghOptions{'hostdisplay'} . '&srv=' . $servicename;
        }

        # This is the If datastructure from the interface information file
        my $refhInterFaceDataFile     = $grefhFile->{If}->{$oid_ifDescr};

        # This is the current measured If datastructure
        my $refhInterFaceDataCurrent  = $grefhCurrent->{If}->{$oid_ifDescr};

        # This variable used for exittext
        $gNumberOfInterfaces++;

        for my $FieldName ( @$refaFields ) {

            my $ChangeTime;
            my $LastChangeInfo          = "";
            my $CellColor;
            my $CellBackgroundColor;
            my $CellContent;
            my $CurrentFieldContent     = "";
            my $FileFieldContent        = "";

            if (defined $refhInterFaceDataCurrent->{"$FieldName"}) {
                # This is used to calculate the id (used for displaying the html table)
                $DataForMD5CheckSum .= $refhInterFaceDataCurrent->{"$FieldName"};
                $CurrentFieldContent  = $refhInterFaceDataCurrent->{"$FieldName"};
                # Delete the first and last "blank"
                $CurrentFieldContent =~ s/^ //;
                $CurrentFieldContent =~ s/ $//;
            }
            if (defined $refhInterFaceDataFile->{"$FieldName"}) {
                $FileFieldContent     = $refhInterFaceDataFile->{"$FieldName"};
            }

            # Flag if the current status of this field should be compared with the
            # "snapshoted" status of this field.
            my $CompareThisField = grep (/$FieldName/i, @$refaToCompare);

            # some fields have a change time property in the interface information file.
            # if the change time exists we store this and write into html table
            $ChangeTime = $grefhFile->{MD}->{If}->{$oid_ifDescr}->{$FieldName."ChangeTime"};

            # If interface is excluded or this is the initial run we don't lookup for
            # data changes
            if ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} eq "true" or $gInitialRun)  {
                $CompareThisField = 0;
                # Change the font color to "olive"
                $CellColor     = '<font color="#808000">';
            } elsif (defined $grefhCurrent->{If}->{$oid_ifDescr}->{$FieldName."OutOfRange"}) {
                $CellBackgroundColor = $grefhCurrent->{If}->{$oid_ifDescr}->{$FieldName."OutOfRange"};
            }
            
            # Set LastChangeInfo to this Format "(since 0d 0h 43m)"
            if ( defined $ChangeTime and $ghOptions{trackduration} ) {
                $ChangeTime = TimeDiff ("$ChangeTime",time());
                $LastChangeInfo = "(since $ChangeTime)";
            }

            if ( $CompareThisField  ) {
                # Field content has NOT changed
                logger(1, "Compare \"".denormalize($oid_ifDescr)."($FieldName)\" now=\"$CurrentFieldContent\" file=\"$FileFieldContent\"");
                if ( $CurrentFieldContent eq $FileFieldContent ) {
                    $CellContent = denormalize ( $CurrentFieldContent );
                } else {
                # Field content has changed ...
                    $CellContent = "now: " . denormalize( $CurrentFieldContent ) . "$LastChangeInfo was: " . denormalize ( $FileFieldContent );

                    if ($ghOptions{verbose} or $ghOptions{warning} > 0 or $ghOptions{critical} > 0) {
                        $gChangeText .= "(" . denormalize ($oid_ifDescr) .
                            ") $FieldName now <b>$CurrentFieldContent</b> (was: <b>$FileFieldContent</b>)<br>";
                    }

                    if ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} eq "false") {
                        $CellBackgroundColor = "red";
                        $gDifferenceCounter++;
                    } else {
                        $CellBackgroundColor = "#F5A9A9"; # light red
                    }
                }
            } else {
                # Filed will not be compared, just write the current field - value in the table.
                logger(1, "Not comparing $FieldName on interface ".denormalize($oid_ifDescr));
                $CellContent = denormalize( $CurrentFieldContent );
            }

            # Write an empty cell content if CellContent is empty
            # This is for visual purposes
            not $CellContent and $CellContent = '&nbsp';

            # Store cell content in table
            $refaContentForHtmlTable->[ $iLineCounter ]->[ $iFieldCounter ]->{"Value"} = "$CellContent";

            # Change font and background color
            defined $CellColor and
              $refaContentForHtmlTable->[ $iLineCounter ]->[ $iFieldCounter ]->{Font} =
              $CellColor;
            defined $CellBackgroundColor and
              $refaContentForHtmlTable->[ $iLineCounter ]->[ $iFieldCounter ]->{Background} =
              $CellBackgroundColor;

            $iFieldCounter++;
        } # for FieldName
        $iLineCounter++;
    } # for $InterfaceIndex

    # Print a footer for debug information
    logger(1, "x"x50);

    return $refaContentForHtmlTable;
}

# ------------------------------------------------------------------------
# This function includes or excludes interfaces from change comparison
# if there are exclude or include lists defined on the commandline.
#
# All interfaces which are excluded will be excluded from
# traffic measurement and change counter count.
#
#   Indicated must be the interface name (ifDescr)
#   -Exclude "3COM Etherlink PCI"
#
#   It is possible to exclude all interfaces
#   -Exclude "ALL"
#
#   It is possible to exclude all interfaces but include one
#   -Exclude "ALL" -Include "3COM Etherlink PCI"
#
# It isnt neccessary to include ALL. By default, all the interfaces are 
# included.
#
# The interface information file will be altered as follows:
#
# <MD>
#    <If>
#        <3COMQ20EtherlinkQ20PCI>
#            CacheTimer   3600
#            Excluded     true
#            ifOperStatusChangeTime   1151586678
#        </3COMQ20EtherlinkQ20PCI>
#    </If>
# </MD>
#
# ------------------------------------------------------------------------
sub EvaluateInterfaces {

    my $ExcludeList = shift;
    my $IncludeList = shift;
    my $ExcludePerfList = shift;
    my $IncludePerfList = shift;

    # Loop through all interfaces
    for my $oid_ifDescr (keys %{$grefhCurrent->{MD}->{If}}) {

        #----- Includes or excludes interfaces from change comparison -----#
        
        # Denormalize interface name
        my $oid_ifDescrReadable = denormalize ($oid_ifDescr);
        my $oid_ifAliasReadable = denormalize ($grefhCurrent->{If}->{"$oid_ifDescr"}->{ifAlias});
        
        # By default, don't exclude the interface
        $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} = "false";
        
        # Process the interface exclusion list
        for my $ExcludeString (@$ExcludeList) {
            if ($ghOptions{regexp}) {
                if ("$oid_ifDescrReadable" =~ /$ExcludeString/i or "$ExcludeString" eq "ALL") {
                    logger(1, "-- exclude ($ExcludeString) interface \"$oid_ifDescrReadable\"");
                    $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} = "true";
                }
            }
            elsif ("$oid_ifDescrReadable" eq "$ExcludeString" or "$ExcludeString" eq "ALL") {
                logger(1, "-- exclude ($ExcludeString) interface \"$oid_ifDescrReadable\"");
                $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} = "true";
            }
        }

        # Process the interface inclusion list
        # Inclusions are done after exclusions to be able to include a 
        # subset of a group of interfaces which were excluded previously
        for my $IncludeString (@$IncludeList) {
            if ($ghOptions{regexp}) {
                if ("${oid_ifDescrReadable}_${oid_ifAliasReadable}" =~ /$IncludeString/i or "$IncludeString" eq "ALL") {
                    logger(1, "+ include ($IncludeString) interface \"$oid_ifDescrReadable\"");
                    $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} = "false";
                }
            }
            elsif ("$oid_ifDescrReadable" eq "$IncludeString" or "$oid_ifAliasReadable" eq "$IncludeString" or "$IncludeString" eq "ALL") {
                logger(1, "+ include ($IncludeString) interface \"$oid_ifDescrReadable\"");
                $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} = "false";
            }
        }
        
        # Update the counter if needed        
        #if ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} eq "false") {
        #    $gNumberOfInterfaces++;
        #}    
        
        # For included interfaces, enable the performance data depending to the exclude and/or include perf port list
        if ($ghOptions{'enableportperf'} and $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{Excluded} eq "false") {
            
            # By default, take the performance data for the interface
            $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} = "false";
            
            # Process the interface exclusion list
            for my $ExcludeString (@$ExcludePerfList) {
                if ($ghOptions{regexp}) {
                    if ("$oid_ifDescrReadable" =~ /$ExcludeString/i or "$ExcludeString" eq "ALL") {
                        logger(1, "-- exclude ($ExcludeString) interface \"$oid_ifDescrReadable\"");
                        $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} = "true";
                    }
                }
                elsif ("$oid_ifDescrReadable" eq "$ExcludeString" or "$ExcludeString" eq "ALL") {
                    logger(1, "-- exclude ($ExcludeString) interface \"$oid_ifDescrReadable\"");
                    $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} = "true";
                }
            }
    
            # Process the interface inclusion list
            # Inclusions are done after exclusions to be able to include a 
            # subset of a group of interfaces which were excluded previously
            for my $IncludeString (@$IncludePerfList) {
                if ($ghOptions{regexp}) {
                    if ("${oid_ifDescrReadable}_${oid_ifAliasReadable}" =~ /$IncludeString/i or "$IncludeString" eq "ALL") {
                        logger(1, "+ include ($IncludeString) interface \"$oid_ifDescrReadable\"");
                        $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} = "false";
                    }
                }
                elsif ("$oid_ifDescrReadable" eq "$IncludeString" or "$oid_ifAliasReadable" eq "$IncludeString" or "$IncludeString" eq "ALL") {
                    logger(1, "+ include ($IncludeString) interface \"$oid_ifDescrReadable\"");
                    $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} = "false";
                }
            }
            if ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} eq "false") {
                # Update the counter if needed
                $gNumberOfPerfdataInterfaces++;
            }
            
        } else {
            $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{ExcludedPerf} = "true";
        }
        
    } # for each interface
    return $grefhCurrent;
}

# ------------------------------------------------------------------------
# Get the uptime of the remote system and store timeticks in raw format
# (not translated into human readable format)
# ------------------------------------------------------------------------
sub GetUptime {
    my $refaOID     = shift;
    my $CacheTimer  = shift;

    my $Value = SnmpGetV1 ({
        -hostname   => "$ghOptions{'hostquery'}",
        -community  => "$ghOptions{'community'}",
        -translate  => [ -timeticks => 0x0 ], # disable conversion get raw timeticks
        OID         => $refaOID,
        CacheTimer  => int rand ($CacheTimer),
    });

    # we got data
    if ($Value) {
        return $Value;
    } else {
        # und tschuess - hat keinen Sinn weiter zu machen
        print "$0: Could not read sysUpTime information from host \"$ghOptions{hostquery}\" with snmp\n";
#TODO get from cache to enrich error text
# $oid_cisco_type   = '.1.3.6.1.4.1.9.5.1.2.16.0'; # WS-C3550-48-SMI
# $oid_cisco_serial = '.1.3.6.1.4.1.9.5.1.2.19.0'; # CAT0645Z0HB
        exit $ERRORS{"CRITICAL"};
    }
}
# ------------------------------------------------------------------------
# Get Data with perl net-snmp module
# ------------------------------------------------------------------------
sub GetDataWithSnmp {
    my $refaOID     = shift;    # ref to array of OIDs (numbers only)
    my $CacheTimer  = shift;

    my $Value = SnmpGetV1 ({
        -hostname   => "$ghOptions{'hostquery'}",      # option -h
        -community  => "$ghOptions{'community'}", # option -C
        OID         => $refaOID,
        CacheTimer  => int rand ($CacheTimer),  # random caching  
    });

    return ($Value);
}

# ------------------------------------------------------------------------
# Get multiple Data with perl net-snmp module
# ------------------------------------------------------------------------
sub GetMultipleDataWithSnmp {

    my $refaOID     = shift;    # ref to array of OIDs (numbers only)
    my $CacheTimer  = shift;
    unless ($CacheTimer) {$CacheTimer = 0;}
    
    my $refhSNMP = SnmpGetV1 ({
        -hostname   => "$ghOptions{'hostquery'}",      # option -h
        -community  => "$ghOptions{'community'}", # option -C
        OID         => $refaOID,
        CacheTimer  => int rand ($CacheTimer),  # random caching
    });

    return ($refhSNMP);
}
# ------------------------------------------------------------------------
# Get Data with the unix snmpwalk command - this is faster than perls
# snmp implementation
# ------------------------------------------------------------------------
sub GetDataWithUnixSnmpWalk {

    my $OID         = shift;    # only one OID (number or name)
    my $CacheTimer  = shift;
    unless ($CacheTimer) {$CacheTimer = 0;}
    
    my ($refaLines) = ExecuteCommand ({
        Command     => "snmpwalk -Oqn -c '$ghOptions{'community'}' -v 1 $ghOptions{'hostquery'} $OID",
        Retry       =>  2,
        CacheTimer  =>  int rand ($CacheTimer),
    });

    return $refaLines;
}
# ------------------------------------------------------------------------
# get ifOperStatus, ifDescr and ifIndex
# ------------------------------------------------------------------------
sub Get_OperStatus_Description_Index {

    my $refaOperStatusLines = shift;

    # Example of $refaOperStatusLines
    #    .1.3.6.1.2.1.2.2.1.8.1 up
    #    .1.3.6.1.2.1.2.2.1.8.2 down
    for (@$refaOperStatusLines) {
        my ($Index,$OperStatusNow) = split / /,$_,2;
        $Index =~ s/^.*\.//g;           # remove all but the index
        $OperStatusNow =~ s/\s+$//g;    # remove invisible chars from the end

        logger(1, "Index = $Index $gLongCacheTimer");
        # read the interface description with the index extracted above
        my $Desc = GetDataWithSnmp ([ "$oid_ifDescr.$Index" ],$gLongCacheTimer);

        # check an empty interface description and add a new description
        # this occurs on some devices (e.g. HP procurve switches)
        if ("$Desc" eq "") {
            # read the MAC address of the interface - independend if it has one or not
            my $MacAddress = GetDataWithSnmp ([ "$oid_ifPhysAddress.$Index" ],$gShortCacheTimer);
            $Desc = "($MacAddress)";
            logger(1, "Interface with index $Index has no description.\nSet it to $Desc");
        }

        # normalize the interface description to not get into trouble
        # with special characters and how Config::General handles blanks
        $Desc = normalize ($Desc);

        # on some operating systems there could be interfaces with
        # the same name - check this out - append uniq text at the end to
        # get a uniq interface name
        if ($grefhCurrent->{If}->{"$Desc"}) {
            my $Text; # dummy text for uniq if description

            # read the MAC address of the interface
            my $MacAddress = GetDataWithSnmp ([ "$oid_ifPhysAddress.$Index" ],
                $gShortCacheTimer);

            # check if we got back a MAC Address - otherwise take the interface
            # index - this could only lead to problems where index is changed
            # during reboot and duplicate interface names
            if ($MacAddress) {
                $Text = "(${MacAddress})";
            } else {
                $Text = "(${Index})";
            }
            logger(1, "Duplicate if ($Index) name - \"$Text\"");

            # append a blank (normalized) the MAC Address or the index
            # to the end of the description
            $Desc = "${Desc}Q20".normalize($Text);
        }

        # Store the oper status as property of the current interface
        $grefhCurrent->{If}->{"$Desc"}->{ifOperStatus}    = "$OperStatusNow";
        $grefhCurrent->{MD}->{IfIndexTable}->{"OperStatus"}->{"$Index"} = "$OperStatusNow";

        #
        # Store a CacheTimer (seconds) where we cache the next
        # reads from the net - we have the following possibilities
        #
        # ifOperStatus:
        #
        # Current state | first state  |  CacheTimer
        # -----------------------------------------
        # up              up              $gShortCacheTimer
        # up              down            0
        # down            down            $gLongCacheTimer
        # down            up              0
        # other           *               0
        # *               other           0
        #
        # One exception to that logic is the "Changed" flag. If this
        # is set we detected a change on an interface property and do not
        # cache !
        #
        my $OperStatusFile = $grefhFile->{If}->{"$Desc"}->{ifOperStatus};
        unless ($OperStatusFile) {$OperStatusFile = "";}
        
        logger(1, "Now=\"$OperStatusNow\" File=\"$OperStatusFile\"");
        # set cache timer for further reads
        if ("$OperStatusNow" eq "up" and "$OperStatusFile" eq "up") {
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{CacheTimer} = $gShortCacheTimer;
        } elsif ("$OperStatusNow" eq "down" and "$OperStatusFile" eq "down") {
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{CacheTimer} = $gLongCacheTimer;
        } else {
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{CacheTimer} = 0;
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText} =
                "Old = \"$OperStatusFile\", Current = \"$OperStatusNow\" ";
        }

        # remember change time of the interface property
        if ($grefhFile->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime}) {
                        # umkopieren damit am Ende die Info erhalten bleibt
                $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime} =
                    $grefhFile->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime}
        } else {
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime} = time;
        }

        # track changes of the oper status
        if ("$OperStatusNow" eq "$OperStatusFile") {   # no changes to its first state
            # delete the changed flag and reset the time when it was changed
            if ($grefhFile->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText}) {
                delete $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText};
                $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime} = time;
            }
        }
        # ifOperstatus has changed to up, no alert
        elsif ("$OperStatusNow" ne "down") {
            # update the state in the status file
            $grefhFile->{If}->{"$Desc"}->{ifOperStatus} = "$OperStatusNow";
            # delete the changed flag and reset the time when it was changed
            if ($grefhFile->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText}) {
                delete $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText};
                $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime} = time;
            }
        }
        # ifOperstatus has changed, alerting
        else {
            # flag if changes already tracked
            if (not $grefhFile->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText}) {
                $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeTime} = time;
            }

            # remember the change every run of this program, this is useful if the
            # ifOperStatus changes from "up" to "testing" to "down"
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{ifOperStatusChangeText} =
                "Old = \"$OperStatusFile\", Current = \"$OperStatusNow\" ";
        }


        # create another tree in the MetaData hash which stores interface index
        # and description. This is used later wehen getting the ip address
        # and for displaying the html table
        $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{"$Index"} = "$Desc";
        $grefhCurrent->{MD}->{IfIndexTable}->{ByName}->{"$Desc"} = "$Index";

         # Store Index und Description in MD. This is needed for displaying the
         # Html table. lukas2
         $grefhCurrent->{If}->{$Desc}->{index}   = "$Index";
         $grefhCurrent->{If}->{$Desc}->{ifDescr} = "$Desc";

    }
    return 0;
}

# ------------------------------------------------------------------------
# get trafic in octets (ifInOctets / ifOutOctets)
# ------------------------------------------------------------------------
sub Get_TraficInOut {

    my $refaOctetLines = shift;
    my $WhatOctet = shift;
    my $WhatBit = shift;

    # Example of $refaOctetLines
    #    .1.3.6.1.2.1.2.2.1.10.2 2510821601
    #    .1.3.6.1.2.1.2.2.1.10.3 0
    for (@$refaOctetLines) {
        my ($Index,$Octets) = split / /,$_,2;
        $Index =~ s/^.*\.//g;    # remove all but the index
        $Octets =~ s/\s+$//g;    # remove invisible chars from the end
        my $Bits = $Octets * 8;  # convert in bits

        # Store the octets of the current interface
        $grefhCurrent->{MD}->{IfIndexTable}->{"$WhatOctet"}->{"$Index"} = "$Octets";
        $grefhFile->{'history'}->{$STARTTIME}->{"$WhatOctet"}->{"$Index"} = "$Octets";
        # Store the bits of the current interface
        $grefhCurrent->{MD}->{IfIndexTable}->{"$WhatBit"}->{"$Index"} = "$Bits";
    }
    return 0;
}

# ------------------------------------------------------------------------
# get trafic in bits (ifInOctets / ifOutOctets)
# ------------------------------------------------------------------------
sub Get_IfErrInOut {

    my $refaIfErrLines = shift;
    my $What = shift;

    # Example of $refaIfErrLines
    #    .1.3.6.1.2.1.2.2.1.14.1 201
    #    .1.3.6.1.2.1.2.2.1.14.2 0
    for (@$refaIfErrLines) {
        my ($Index,$IfErr) = split / /,$_,2;
        $Index =~ s/^.*\.//g;    # remove all but the index
        $IfErr =~ s/\s+$//g;    # remove invisible chars from the end

        # Store the Errors of the current interface
        $grefhCurrent->{MD}->{IfIndexTable}->{"$What"}->{"$Index"} = "$IfErr";
        $grefhFile->{'history'}->{$STARTTIME}->{"$What"}->{"$Index"} = "$IfErr";
    }
    return 0;
}

# ------------------------------------------------------------------------
# get packet discards (ifInDiscards/ifOutDiscards)
# ------------------------------------------------------------------------
sub Get_IfDiscardInOut {

    my $refaIfDiscardLines = shift;
    my $What = shift;

    # Example of $refaIfDiscardLines
    #    .1.3.6.1.2.1.2.2.1.13.1 201
    #    .1.3.6.1.2.1.2.2.1.13.2 0
    for (@$refaIfDiscardLines) {
        my ($Index,$IfDiscard) = split / /,$_,2;
        $Index =~ s/^.*\.//g;    # remove all but the index
        $IfDiscard =~ s/\s+$//g;    # remove invisible chars from the end

        # Store the Discards of the current interface
        $grefhCurrent->{MD}->{IfIndexTable}->{"$What"}->{"$Index"} = "$IfDiscard";
        $grefhFile->{'history'}->{$STARTTIME}->{"$What"}->{"$Index"} = "$IfDiscard";
    }
    return 0;
}

# ------------------------------------------------------------------------
# clean outdated historical data statistics and select the one eligible
# for bandwitdh calculation
# ------------------------------------------------------------------------
sub CleanAndSelectHistoricalDataset {

    #logger(3, "perfdata dirty:\n".Dumper($grefhFile));

    my $firsttime = $STARTTIME;

    # loop through all historical perfdata
    for my $time (sort keys %{$grefhFile->{'history'}}) {
        if (($STARTTIME - ($ghOptions{'delta'} + 200)) > $time) {
            # delete anything older than starttime - (delta + a bit buffer)
            # so we keep a sliding window following us
            delete $grefhFile->{'history'}->{$time};
            logger(1, "outdated perfdata cleanup: $time");
        } elsif ($time < $firsttime) {
            # chose the oldest dataset to compare with
            $firsttime = $time;
            $gUsedDelta = $STARTTIME - $firsttime;
            logger(1, "now ($STARTTIME) - comparetimestamp ($time) = used delta ($gUsedDelta)");
            last;
        } else {
            # no dataset (left) to compare with
            # no further calculations if we run for the first time.
            $firsttime = undef;
            logger(1, "no dataset (left) to compare with, bandwitdh calculations will not be done");
        }
    }
    return $firsttime;
}

# ------------------------------------------------------------------------
# calculate rate / bandwidth usage within a specified period
# ------------------------------------------------------------------------
sub CalculateBps {
    my $firsttime = shift;
    # check if the counter is back to 0 after 2^32 / 2^64.
    # First set the modulus depending on highperf counters or not
    #my $overfl_mod = defined ($o_highperf) ? 18446744073709551616 : 4294967296;
    my $overfl_mod = 4294967296;
    
    # $grefaAllIndizes is a indexed and sorteted list of all interfaces
    for my $Index (@$grefaAllIndizes) {

        # ---------- Bandwidth calculation -----------
        
        my $overfl      = 0;
        my $bpsIn       = 0;
        my $bpsOut      = 0;
        
        # be sure that history exist
        # then check if the counter is back to 0 after 2^32 / 2^64.
        if (defined $grefhFile->{'history'}->{$STARTTIME}->{OctetsIn}->{"$Index"} 
            and defined $grefhFile->{'history'}->{$firsttime}->{OctetsIn}->{"$Index"}){ 
                $overfl = ($grefhFile->{'history'}->{$STARTTIME}->{OctetsIn}->{"$Index"} >=
                    $grefhFile->{'history'}->{$firsttime}->{OctetsIn}->{"$Index"} ) ? 0 : $overfl_mod;
                $bpsIn = ($grefhFile->{'history'}->{$STARTTIME}->{OctetsIn}->{"$Index"} -
                    $grefhFile->{'history'}->{$firsttime}->{OctetsIn}->{"$Index"} + $overfl) / $gUsedDelta * 8;
        }
        
        # be sure that history exist
        # then check if the counter is back to 0 after 2^32 / 2^64.
        if (defined $grefhFile->{'history'}->{$STARTTIME}->{OctetsOut}->{"$Index"} 
            and defined $grefhFile->{'history'}->{$firsttime}->{OctetsOut}->{"$Index"}){ 
                $overfl = ($grefhFile->{'history'}->{$STARTTIME}->{OctetsOut}->{"$Index"} >=
                    $grefhFile->{'history'}->{$firsttime}->{OctetsOut}->{"$Index"} ) ? 0 : $overfl_mod;
                $bpsOut = ($grefhFile->{'history'}->{$STARTTIME}->{OctetsOut}->{"$Index"} -
                    $grefhFile->{'history'}->{$firsttime}->{OctetsOut}->{"$Index"} + $overfl) / $gUsedDelta * 8;
        }
        
        my $oid_ifDescr = $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$Index};

        # bandwidth usage in percent of (configured/negotiated) interface speed
        if ($grefhCurrent->{If}->{$oid_ifDescr}->{ifSpeed} > 0) {
            my $ifLoadIn  = 100 * $bpsIn  / $grefhCurrent->{If}->{$oid_ifDescr}->{ifSpeed};
            my $ifLoadOut = 100 * $bpsOut / $grefhCurrent->{If}->{$oid_ifDescr}->{ifSpeed};
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLoadIn}  = sprintf("%.2f", $ifLoadIn);
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLoadOut} = sprintf("%.2f", $ifLoadOut);
            # check interface utilization in percent
            if ($ifLoadIn > 0) {
                $grefhCurrent->{If}->{$oid_ifDescr}->{ifLoadInOutOfRange} = colorcode($ifLoadIn);
            }
            if ($ifLoadOut > 0) {
                $grefhCurrent->{If}->{$oid_ifDescr}->{ifLoadOutOutOfRange} = colorcode($ifLoadOut);
            }
        } else {
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLoadIn} = 0;
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLoadOut} = 0;
        }

        #print OUT "BandwidthUsageIn=${bpsIn}bps;0;0;0;$grefhCurrent->{If}->{$oid_ifDescr}->{ifSpeed} ";
        #print OUT "BandwidthUsageOut=${bpsOut}bps;0;0;0;$grefhCurrent->{If}->{$oid_ifDescr}->{ifSpeed} ";

        my $SpeedUnitOut='';
        my $SpeedUnitIn='';
        if ($ghOptions{human}) {
            # human readable bandwidth usage in (G/M/K)bits per second
            $SpeedUnitIn=' bps';
            if ($bpsIn > 1000000000) {        # in Gbit/s = 1000000000 bit/s
                  $bpsIn = $bpsIn / 1000000000;
                  $SpeedUnitIn=' Gbps';
            } elsif ($bpsIn > 1000000) {      # in Mbit/s = 1000000 bit/s
                  $bpsIn = $bpsIn / 1000000;
                  $SpeedUnitIn=' Mbps';
            } elsif ($bpsIn > 1000) {         # in Kbits = 1000 bit/s
                  $bpsIn = $bpsIn / 1000;
                  $SpeedUnitIn=' Kbps';
            }

            $SpeedUnitOut=' bps';
            if ($bpsOut > 1000000000) {       # in Gbit/s = 1000000000 bit/s
                  $bpsOut = $bpsOut / 1000000000;
                  $SpeedUnitOut=' Gbps';
            } elsif ($bpsOut > 1000000) {     # in Mbit/s = 1000000 bit/s
                  $bpsOut = $bpsOut / 1000000;
                  $SpeedUnitOut=' Mbps';
            } elsif ($bpsOut > 1000) {        # in Kbit/s = 1000 bit/s
                  $bpsOut = $bpsOut / 1000;
                  $SpeedUnitOut=' Kbps';
            }
        }

        $grefhCurrent->{If}->{$oid_ifDescr}->{bpsIn} = sprintf("%.2f$SpeedUnitIn", $bpsIn);
        $grefhCurrent->{If}->{$oid_ifDescr}->{bpsOut} = sprintf("%.2f$SpeedUnitOut", $bpsOut);

        # ---------- Last traffic calculation -----------
        
        # remember last traffic time
        if ($bpsIn > 0 or $bpsOut > 0) { # there is traffic now, remember it
            $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic} = $STARTTIME;
            #logger(1, "setze neuen wert!!! LastTraffic: ", $STARTTIME);
        } elsif (not defined $grefhFile->{MD}->{If}->{$oid_ifDescr}->{LastTraffic}) {
            #if ($gInitialRun) {
            #    # initialize on the first run
            #    $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic} = $STARTTIME;
            #} else {
                $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic} = 0;
            #}
            #logger(1, "grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic}: not defined");
        } else { # no traffic now, dont forget the old value
            $grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic} = $grefhFile->{MD}->{If}->{$oid_ifDescr}->{LastTraffic};
            #$grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic} = $STARTTIME;
            #logger(1, "merke alten wert!!! LastTraffic: ", $grefhFile->{MD}->{If}->{$oid_ifDescr}->{LastTraffic});
        }
        # Set LastTrafficInfo to this Format "0d 0h 43m" and compare the critical and warning levels for "unused interface"
        ($grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTraffic}, my $LastTrafficStatus) =
            TimeDiff ($grefhCurrent->{MD}->{If}->{$oid_ifDescr}->{LastTraffic}, $STARTTIME,
                $ghOptions{lasttrafficwarn}, $ghOptions{lasttrafficcrit});
        
        # ---------- Last traffic calculation -----------
        
        # ifUsage variable:
        #   * -1  -> interface used, unknown last traffic
        #   * 0   -> interface used, last traffic is < crit duration
        #   * 1   -> interface unused, last traffic is >= crit duration
        my $ifUsage = -1; # default: interface unused
        
        if ($LastTrafficStatus == $ERRORS{'CRITICAL'}) {
            logger(2, "  (debug) interface unused, last traffic is >= crit duration");
            # this means "no traffic seen during the last LastTrafficCrit seconds"
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTrafficOutOfRange} = "red";
            $ifUsage = 1;   # interface unused
        } elsif ($LastTrafficStatus == $ERRORS{'WARNING'}) {
            logger(2, "  (debug) interface used, last traffic is < crit duration");
            # this means "no traffic seen during the last LastTrafficWarn seconds"
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTrafficOutOfRange} = "yellow";
            $ifUsage = 0;   # interface used
        } elsif ($LastTrafficStatus == $ERRORS{'UNKNOWN'}) {
            logger(2, "  (debug) interface used, unknown last traffic");
            # this means "no traffic seen during the last LastTrafficWarn seconds"
            $grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTrafficOutOfRange} = "orange";
            $ifUsage = -1;  # interface unused
        } else {
            logger(2, "  (debug) interface used, last traffic is < crit duration");            
            logger(1, "  (debug) LastTraffic ($oid_ifDescr): ", $grefhFile->{MD}->{If}->{$oid_ifDescr}->{LastTraffic});
            # this means "there is traffic on the interface during the last LastTrafficWarn seconds"
            $ifUsage = 0;   # interface used
        }
        check_for_unused_interfaces ($oid_ifDescr, $ifUsage);

    }
    #logger(3, "grefhCurrent: " . Dumper ($grefhCurrent));
    #logger(3, "grefhFile: " . Dumper ($grefhFile));
    #logger(3, "grefhCurrent: " . Dumper ($grefhCurrent->{If}));
    #logger(3, "grefhFile: " . Dumper ($grefhFile->{If}));

    return 0;
}

# ------------------------------------------------------------------------
# extract ip addresses out of snmpwalk lines
#
# # snmpwalk -Oqn -c public -v 1 router IP-MIB::ipAdEntIfIndex
# .1.3.6.1.2.1.4.20.1.2.172.31.92.91 15
# .1.3.6.1.2.1.4.20.1.2.172.31.92.97 15
# .1.3.6.1.2.1.4.20.1.2.172.31.99.76 15
# .1.3.6.1.2.1.4.20.1.2.193.83.153.254 29
# .1.3.6.1.2.1.4.20.1.2.193.154.197.192 14
#
# ------------------------------------------------------------------------
sub Get_IpAddress_SubnetMask {
    my $refaIPLines = shift;

    my $refaNetMask;

    # store all ip information in the hash to avoid reading the netmask
    # again in the next run
    $grefhCurrent->{MD}->{SnmpIpInfo} = join (";",@$refaIPLines);

    # remove all invisible chars incl. \r and \n
    $grefhCurrent->{MD}->{SnmpIpInfo} =~ s/[\000-\037]|[\177-\377]//g;
	
    # # snmpwalk -Oqn -v 1 -c public router IP-MIB::ipAdEntNetMask
    # .1.3.6.1.2.1.4.20.1.3.172.31.92.91 255.255.255.255
    # .1.3.6.1.2.1.4.20.1.3.172.31.92.97 255.255.255.255
    #
    # read the subnet masks with caching 0 only if the ip addresses
    # have changed
    if (defined $grefhFile->{MD}->{SnmpIpInfo} and $grefhCurrent->{MD}->{SnmpIpInfo} eq $grefhFile->{MD}->{SnmpIpInfo}) {
        $refaNetMask = GetDataWithUnixSnmpWalk ($oid_ipAdEntNetMask,$gLongCacheTimer);
    } else {
        $refaNetMask = GetDataWithUnixSnmpWalk ($oid_ipAdEntNetMask,0);
    }

    # Example lines:
    # .1.3.6.1.2.1.4.20.1.2.172.31.99.76 15
    # .1.3.6.1.2.1.4.20.1.2.193.83.153.254 29
    for (@$refaIPLines) {
        my ($IpAddress,$Index) = split / /,$_,2;        # blank splits OID & ifIndex
        $IpAddress  =~  s/^.*1\.4\.20\.1\.2\.//;    # remove up to the ip address
        $Index          =~  s/\D//g;                    # remove all but numbers

        # extract the netmask
        #
        # $refaNetMaks looks like this:
        #
        # $VAR1 = [
        #          '.1.3.6.1.2.1.4.20.1.3.10.1.1.4 255.255.0.0',
        #          '.1.3.6.1.2.1.4.20.1.3.10.2.1.4 255.255.0.0',
        #          '.1.3.6.1.2.1.4.20.1.3.172.30.1.4 255.255.0.0
        #        ];

        my ($Tmp,$NetMask) = split (" ",join ("",grep /$IpAddress /,@$refaNetMask),2);
        $NetMask    =~ s/\s+$//;    # remove invisible chars from the end

        # get the interface description stored before from the index table
        my $Desc = $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{"$Index"};

        # separate multiple IP Adresses with a blank
        # blank is good because the WEB browser can break lines
        if ($grefhCurrent->{If}->{"$Desc"}->{IpInfo}) {
            $grefhCurrent->{If}->{"$Desc"}->{IpInfo} =
            $grefhCurrent->{If}->{"$Desc"}->{IpInfo}." "
        }
        # now we are finished with the puzzle of getting ip and subnet mask
        # add IpInfo as property to the interface
        my $IpInfo = "$IpAddress/$NetMask";
        $grefhCurrent->{If}->{"$Desc"}->{IpInfo} .= $IpInfo;

        # check if the IP address has changed to its first run
        my $FirstIpInfo = $grefhFile->{If}->{"$Desc"}->{IpInfo};
        unless ($FirstIpInfo) {$FirstIpInfo = "";}
        
        # disable caching of this interface if ip information has changed
        if ("$IpInfo" ne "$FirstIpInfo") {
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{CacheTimer} = 0;
            $grefhCurrent->{MD}->{If}->{"$Desc"}->{CacheTimerComment} =
                "caching is disabled because of first or current IpInfo";
        }
    }
    return 0;
}

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
    eval {
        $refoConfig = new Config::General (
            -ConfigFile             => "$ConfigFile",
            -UseApacheInclude       => "false",
            -MergeDuplicateBlocks   => "false",
            -InterPolateVars        => "false",
        );
    };
    if($@) {
        # it's not successfull so remove the bad config file and try again.
        logger(1, "CONFIG READ FAIL: create new one ($ConfigFile).");
        unlink "$ConfigFile";
        return $refhConfig;
    }

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
        exit $ERRORS{"UNKNOWN"};
    }

    umask "$UMASK";
    $refoConfig->save_file("$ConfigFile", $refhStruct);
    logger(1, "Wrote interface data to file: $ConfigFile");

    return 0;
}
# ------------------------------------------------------------------------
# walk through each interface and read ifAdminStatus, ifSpeed and ifAlias
# ------------------------------------------------------------------------
sub Get_AdminStatus_Speed_Alias_Vlan {

    # loop through all found interfaces
    for my $Desc (keys %{$grefhCurrent->{If}}) {

        my $CacheTimer = 0;

        # extract the index out of the MetaData
        my $Index           = $grefhCurrent->{MD}->{IfIndexTable}->{ByName}->{"$Desc"};

        # Current state | first state  |  CacheTimer
        # -----------------------------------------
        # down            down            $gLongCacheTimer
        # *               *               0
        my $OperStatusNow  = $grefhCurrent->{If}->{"$Desc"}->{ifOperStatus};
        my $OperStatusFile = $grefhFile->{If}->{"$Desc"}->{ifOperStatus};
        unless ($OperStatusFile) {$OperStatusFile = "";}
        
         # Set cachtimer to the long cache timer value if the operstatus is now down
         # and was down in the past.
         if ( ( "$OperStatusNow" eq "down" ) and ( "$OperStatusFile" eq "down" ) ) {
            $CacheTimer = $gLongCacheTimer;
         }

        # get next interface properties with caching to avoid network load
        my $refhSNMP = GetMultipleDataWithSnmp (
            [ "$oid_ifAdminStatus.$Index", "$oid_ifSpeed.$Index","$oid_ifAlias.$Index" ],$CacheTimer);

        # store ifAdminStatus converted from a digit to "up" or "down"
        $grefhCurrent->{If}->{"$Desc"}->{ifAdminStatus} =
            ConvertAdminStatusToReadable ($refhSNMP->{"$oid_ifAdminStatus.$Index"});

        # store ifSpeed in a machine and human readable format
        $grefhCurrent->{If}->{"$Desc"}->{ifSpeed} =
            ($refhSNMP->{"$oid_ifSpeed.$Index"});
        $grefhCurrent->{If}->{"$Desc"}->{ifSpeedReadable} =
            ConvertSpeedToReadable ($refhSNMP->{"$oid_ifSpeed.$Index"});

        # store ifAlias normalized to not get into trouble with special chars
        $grefhCurrent->{If}->{"$Desc"}->{ifAlias} =
            normalize ($refhSNMP->{"$oid_ifAlias.$Index"});

        if ($ghOptions{vlan}) { # show VLANs per port
                # clear ifVlanNames
                $grefhCurrent->{If}->{"$Desc"}->{ifVlanNames} = '';
                }
    }

    if ($ghOptions{vlan}) { # show VLANs per port

        my $VlanNames = GetDataWithUnixSnmpWalk ($oid_ifVlanName,0);
        my $VlanPortHP = GetDataWithUnixSnmpWalk ($oid_ifVlanPortHP,0);
        my $VlanPortCisco = GetDataWithUnixSnmpWalk ($oid_ifVlanPortCisco,0);

        # store Vlan names in a hash
        my %vlanname;
        foreach my $tmp ( @$VlanNames ) {
            my ($oid, @name) = split(/ /, $tmp);
                chomp(@name);
                $vlanname{$oid} = "@name";
                $vlanname{$oid} =~ tr/"<>/'../; #"
        }
        if (@$VlanPortHP > 0) {
            foreach my $tmp ( @$VlanPortHP ) {
                my ($oid, $port) = split(/ /, $tmp);
                        chomp($port);
                my @oid = split(/\./, $oid);
                        my $vlan = $oid[-2];
                my $oid_ifDescr = $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$port};

                # store ifVlanNames
                $grefhCurrent->{If}->{"$oid_ifDescr"}->{ifVlanNames} .= $vlanname{"$oid_ifVlanName.$vlan"}. " ";

                #logger(1, " (Debug) VlanName -> $port, " . $vlanname{"$oid_ifVlanName.$vlan"});
                }
        }
        if (@$VlanPortCisco > 0) {
            foreach my $tmp ( @$VlanPortCisco ) {
                my ($oid, $vlan) = split(/ /, $tmp);
                        chomp($vlan);
                my @oid = split(/\./, $oid);
                        my $port = $oid[-1];
                my $oid_ifDescr = $grefhCurrent->{MD}->{IfIndexTable}->{ByIndex}->{$port};

                # store ifVlanNames
                $grefhCurrent->{If}->{"$oid_ifDescr"}->{ifVlanNames} .= $vlan. " ";

                #logger(1, " (Debug) VlanName -> $port, " . $vlan ."");
                }
        }
        }

    return 0;
}
# ------------------------------------------------------------------------
# extract two cache timers out of the commandline -cache option
#
# Examples:
#   -cache 150              $gShortCacheTimer = 150 and $Long... = 300
#   -cache 3600,86400       $gShortCacheTimer = 3600 and $Long...= 86400
#
# ------------------------------------------------------------------------
sub ExtractCacheTimer {
    my $CacheString = shift;

    # only one number entered
    if ($CacheString =~ /^\d+$/) {
        $gShortCacheTimer = $CacheString;
        $gLongCacheTimer  = 2*$gShortCacheTimer;
    # two numbers entered - separated with a comma
    } elsif ($CacheString =~ /^\d+$ghOptions{'ifs'}\d+$/) {
        ($gShortCacheTimer,$gLongCacheTimer) = split (/$ghOptions{'ifs'}/,$CacheString);
    } else {
        print "$0: Wrong cache timer specified\n";
        exit $ERRORS{"UNKNOWN"};
    }
    logger(1, "Set ShortCacheTimer = $gShortCacheTimer and LongCacheTimer = $gLongCacheTimer");
    return ($gShortCacheTimer,$gLongCacheTimer);
}
# ------------------------------------------------------------------------
# get the interface speed as integer and convert it to a readable format
# return a string
# ------------------------------------------------------------------------
sub ConvertSpeedToReadable {
    my $Speed = shift;
    if ($Speed > 999999999) {
        $Speed = sprintf ("%0.2f Gbit",$Speed/1000000000);
    } elsif ($Speed > 999999) {
        $Speed = sprintf ("%0.2f Mbit",$Speed/1000000);
    } elsif ($Speed > 999) {
        $Speed = sprintf ("%0.2f kbit",$Speed/1000);
    } elsif ($Speed > 0) {
        $Speed = sprintf ("%0.2f bit",$Speed);
    } else {
        $Speed = "";
    }
    return $Speed;
}
# ------------------------------------------------------------------------
# get the interface administrative status as integer or string and convert
# it to a readable format - return a string
#
# http://www.faqs.org/rfcs/rfc2863.html
#
#    ifAdminStatus OBJECT-TYPE
#        SYNTAX  INTEGER {
#                    up(1),       -- ready to pass packets
#                    down(2),
#                    testing(3)   -- in some test mode
#                }
# ------------------------------------------------------------------------
sub ConvertAdminStatusToReadable {
    my $AdminStatus = shift;
    if ($AdminStatus =~ /1/) {
        $AdminStatus = "up";
    } elsif ($AdminStatus =~ /2/) {
        $AdminStatus = "down";
    } elsif ($AdminStatus =~ /3/) {
        $AdminStatus = "testing";
    } else {
        # we do nothing and leave the original status
    }
    return $AdminStatus;
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

        # we got data from an old formated file - check this
        if (not $grefhFile->{MD}->{sysUpTime}) {
            unlink ("$InterfaceInformationFile");   # delete the old file
            print "$0: first run - initializing interface table now\n";
            exit $ERRORS{"OK"};
        }

        # check if the uptime read from the host > then the uptime
        # stored in the file -> means host was not rebooted
        if ($grefhCurrent->{MD}->{sysUpTime} > $grefhFile->{MD}->{sysUpTime} and
            $ghOptions{'cache'}) {

            # extract cache timers out of the command line option
            ($gShortCacheTimer,$gLongCacheTimer) = ExtractCacheTimer ("$ghOptions{'cache'}");
        # it seems that the remote system was rebooted - caching is disabled
        }
    # the file with interface information was not found - this is the first
    # run of the program or it was deleted before
    } else {
        # the file was not found - store the sysUptime immediately
        # Grund: Wenn das Programm mitten drinnen unterbrochen wird
        # (z.B. service check time out) greift beim naechsten Aufruf
        # das Caching.
        WriteConfigFileNew ("$InterfaceInformationFile",$grefhCurrent);
        $gInitialRun = 1;
    }
    return $grefhFile;
}

# ------------------------------------------------------------------------
# calculate time diff of unix epoch seconds and return it in
# a readable format
#
# my $x = TimeDiff ("1150100854","1150234567");
# print $x;   # $x equals to 1d 13h 8m
#
# ------------------------------------------------------------------------
sub TimeDiff {
    my ($StartTime, $EndTime, $warn, $crit) = @_;

    my $Days  = 0;
    my $Hours = 0;
    my $Min   = 0;
    my $Status   = $ERRORS{'UNKNOWN'};
    my $TimeDiff = $EndTime - $StartTime;

    my $Rest;

    my $String = "(NoData)"; # default text (unknown/error)

    # check start not 0
    if ($StartTime == 0) {
        return wantarray ? ('(NoData)', $ERRORS{'UNKNOWN'}) : '(NoData)';
    }

    # check start must be before end
    if ($EndTime < $StartTime) {
        return wantarray ? ('(NoData)', $ERRORS{'UNKNOWN'}) : '(NoData)';
    }

    # check if there is no traffic for $crit or $warn seconds
    if (defined $warn and defined $crit) {
        if ($TimeDiff > $crit) {
            $Status = $ERRORS{'CRITICAL'};
        } elsif ($TimeDiff > $warn) {
            $Status = $ERRORS{'WARNING'};
        } else {
            $Status = $ERRORS{'OK'};
        }
    } else {
        $Status = $ERRORS{'OK'};
    }

    $Days = int ($TimeDiff / 86400);
    $Rest = $TimeDiff - ($Days * 86400);

    if ($Rest < 0) {
        $Days = 0;
        $Hours = int ($TimeDiff / 3600);
    } else {
        $Hours = int ($Rest / 3600);
    }

    $Rest = $Rest - ($Hours * 3600);

    if ($Rest < 0) {
        $Hours = 0;
        $Min = int ($TimeDiff / 60);
    } else {
        $Min = int ($Rest / 60);
    }

    #logger(1, "warn: $warn, crit: $crit, diff: $TimeDiff, status: $Status");
    return wantarray ? ("${Days}d&nbsp;${Hours}h&nbsp;${Min}m", $Status) : "${Days}d&nbsp;${Hours}h&nbsp;${Min}m";
}

# ------------------------------------------------------------------------
# normalize and denormalize subroutines extracted from our Common library
# - used to get rid of special characters
# ------------------------------------------------------------------------
sub normalize {
    my $Text=shift;
    $Text=~s/Q/Q51/g;                                                                                   # Q normalisieren
    $Text=~s/[\000-\017]/sprintf ("Q0%X",ord($&))/ge;                   # einstellige HEX Zahlen mit 0 davor konvertieren
    $Text=~s/[\W_]/sprintf ("Q%X",ord($&))/ge;                                  # alle anderen Zeichen durch Q + HEX code ersetzen
    return $Text;                                                                                               # fertig
}

# ------------------------------------------------------------------------
# normalize and denormalize subroutines extracted from our Common library
# - used to get rid of special characters
# ------------------------------------------------------------------------

sub denormalize {
    my $Text=shift;
    $Text=~s/Q../pack "H2",substr($&,1,3)/ge;
    return $Text;
}

# ------------------------------------------------------------------------
# trim function to remove whitespace from the start and end of the string
# ------------------------------------------------------------------------
sub trim {
    my @out = @_;
    for (@out) {
        s/^\s+//;
        s/\s+$//;
    }
    return wantarray ? @out : $out[0];
}

# ------------------------------------------------------------------------
# colorcode function to give a html color code between green and red for a given percent value
# ------------------------------------------------------------------------
sub colorcode {
    my $ifLoad = $_[0];
    my $colorcode;

    # just traffic light color codes for the lame
    if ($ifLoad < $ghOptions{ifloadwarn}) {            # green / ok
        $colorcode = 'green';
    } elsif ($ifLoad < $ghOptions{ifloadcrit}) {       # yellow / warn
        $colorcode = 'yellow';
        $gIfLoadWarnCounter++;
    } else {                          # red / crit
        $colorcode = 'red';
        $gIfLoadCritCounter++;
    }

    if ($ghOptions{'ifloadgradient'}) {
        # its cool to have a gradient from green over yellow to red representing the percent value
        # the gradient goes from
        #   #00FF00 (green) at 0 % over
        #   #FFFF00 (yellow) at $warn % to
        #   #FF0000 (red) at $crit % and over

        # first adjust the percent value according to the given warning and critical levels
        if ($ifLoad <= $ghOptions{ifloadwarn}) {
            $ifLoad = $ifLoad * 50 / $ghOptions{ifloadwarn};
        } elsif ($ifLoad <= $ghOptions{ifloadcrit}) {
            $ifLoad = $ifLoad * 100 / $ghOptions{ifloadcrit};
        }
        my $color = 5.12 * $ifLoad;      # (256+256) * $ifLoad / 100
        if ($color > 512) { $color = 512 }
        my $red   = ($color > 255) ? 255 : $color;
        my $green = ($color < 255) ? 255 : -1 - (-1 * (512 - $color));
        $colorcode = sprintf "%2.2x%2.2x%2.2x", $red, $green, 0;
        logger(2, " (Debug) colorcode: $colorcode, ifLoad: $ifLoad, color: $color, red: $red, green: $green");
                # (Debug) colorcode: ff5f00, ifLoad: 81.1764679663113, color: 415.623515987514, red: 255, green: 95.3764840124863
                # (Debug) colorcode: b8ff00, ifLoad: 36.0897789918691, color: 184.77966843837, red: 184.77966843837, green: 255
    }
    return $colorcode;
}
 
# ------------------------------------------------------------------------
# check_for_unused_interfaces
#  * arg 1: oid ifDescr of the interface
#  * arg 2: free???
#     . -1  -> interface used, unknown last traffic
#     . 0   -> interface used, last traffic is < crit duration
#     . 1   -> interface unused, last traffic is >= crit duration
# ------------------------------------------------------------------------
sub check_for_unused_interfaces {
    my ($oid_ifDescr, $free) = @_;
    
    if ($grefhCurrent->{If}->{"$oid_ifDescr"}->{ifSpeed}) {
        # Interface has a speed property, that can be a physical interface
        
        if ($oid_ifDescr =~ /Ethernet(\d+)Q2F(\d+)Q2F(\d+)/) {
            # we look for ethernet ports (and decide if it is a stacked switch), x/x/x format
            if (not defined $gInterfacesWithoutTrunk->{"$1/$2/$4"}) {
                $gInterfacesWithoutTrunk->{"$1/$2/$4"} = $free;
                $gNumberOfInterfacesWithoutTrunk++;
                # look for free ports with admin status up
                if ($free and $grefhCurrent->{If}->{"$oid_ifDescr"}->{ifAdminStatus} eq 'up') {
                    $grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTrafficOutOfRange} = "yellow";
                    $gNumberOfFreeUpInterfaces++;
                }
            }
        } elsif ($oid_ifDescr =~ /Ethernet(\d+)Q2F(\d+)/) {
            # we look for ethernet ports (and decide if it is a stacked switch), x/x format
            if (not defined $gInterfacesWithoutTrunk->{"$1/$2"}) {
                $gInterfacesWithoutTrunk->{"$1/$2"} = $free;
                $gNumberOfInterfacesWithoutTrunk++;
                # look for free ports with admin status up
                if ($free and $grefhCurrent->{If}->{"$oid_ifDescr"}->{ifAdminStatus} eq 'up') {
                    $grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTrafficOutOfRange} = "yellow";
                    $gNumberOfFreeUpInterfaces++;
                }
            }
        } elsif (not $oid_ifDescr =~ /^vif|Loopback/i) {
            # we look for all interfaces having speed property but not looking like a virtual interface
            if (not defined $gInterfacesWithoutTrunk->{"$oid_ifDescr"}) {
                $gInterfacesWithoutTrunk->{"$oid_ifDescr"} = $free;
                $gNumberOfInterfacesWithoutTrunk++;
                # look for free ports with admin status up
                if ($free and $grefhCurrent->{If}->{"$oid_ifDescr"}->{ifAdminStatus} eq 'up') {
                    $grefhCurrent->{If}->{$oid_ifDescr}->{ifLastTrafficOutOfRange} = "yellow";
                    $gNumberOfFreeUpInterfaces++;
                }
            }
        } 
    }
    logger(1, "ifDescr: $oid_ifDescr\tFreeUp: $gNumberOfFreeUpInterfaces\tWithoutTrunk: $gNumberOfInterfacesWithoutTrunk");
}

# ------------------------------------------------------------------------
# routine extracted from our communications library
# ------------------------------------------------------------------------
sub SnmpGetV1 {
    my $refhStruct = shift;

    #
    # store variables and delete them from the hash
    # this is necessary for the snmp session which takes the same
    # hash ref and does not work with arguments other than starting
    # with a dash
    # see http://search.cpan.org/search?query=Net%3A%3ASnmp&mode=all
    #
    my $refaOIDs            = $refhStruct->{OID}; # ref to array of OIDs
    my $GlobalCacheTimer    = $refhStruct->{CacheTimer}; # CacheTimer

    delete $refhStruct->{OID};
    delete $refhStruct->{CacheTimer};

    my $refhSnmpValues; # hash returned to the caller
    my $refoSession;    # SNMP session object
    my $SessionError;   # SNMP session error

    # example cache dir name
    # /tmp/watchit/Cache/SnmpGetV1/cat-itd-01
    my $CacheDir = "$ghOptions{'cachedir'}/SnmpGetV1";

    # Create the directory if not existend
    not -d $CacheDir and MyMkdir($CacheDir);

    # create snmp V1 session
    ($refoSession,$SessionError) = Net::SNMP->session (%$refhStruct);

    my $OIDLine;    # one line of OIDs or OIDs and caching timers
    my $SnmpValue;  # one snmp value

    if (defined $refoSession) {

        # OIDs come in an array (ref) - go through each
        # example:
        #    $refaOIDs = [
        #              '.1.3.6.1.2.1.2.2.1.11.1',
        #              '.1.3.6.1.2.1.2.2.1.12.1'
        #            ];
        for $OIDLine (@$refaOIDs) {

            my  $CacheTimer=0;

            $SnmpValue="";  # clear value

            # OID could be .1.3.6.1.2.1.2.2.1.11.1,200
            # <OID>,<CacheTimer> for this OID only
            my ($OID,$OIDCacheTimer) = ("","");
            ($OID,$OIDCacheTimer) = split ',',$OIDLine,2;

            if (defined $OIDCacheTimer) {
                # remove non digits
                $OIDCacheTimer =~ s/\D//g;
                if ("X$OIDCacheTimer" eq "X") { # is empty?
                    $CacheTimer = $GlobalCacheTimer;
                } else {
                    $CacheTimer = $OIDCacheTimer;
                }
            } else {
                $CacheTimer = $GlobalCacheTimer;
            }

            if ($CacheTimer > 0) {
                if (-r "$CacheDir/$OID") {
                    my @FileProperties=stat("$CacheDir/$OID");

                    # $FileProperties[9] = LastModifyTime of file
                    # only read the cache file if it is not too old
                    if (time - $CacheTimer < $FileProperties[9]) {
                        open (IN,"<$CacheDir/$OID");
                            $SnmpValue = <IN>;
                        close (IN);
                    }
                }
            }
            unless (defined $SnmpValue) {$SnmpValue = "";}
            # snmp value not from cache - read it from the net
            if ("X$SnmpValue" eq "X") {
                # get the snmp value - we do not check errors
                # here because of negative caching
                my $refhValue = $refoSession->get_request(-varbindlist => ["$OID"]);
                if (defined $refhValue->{"$OID"}) {
                    $SnmpValue  =   $refhValue->{"$OID"};

                    # remove non ascii chars incl. \r and \n
                    $SnmpValue  =~  s/[\000-\037]|[\177-\377]//g;

                    # replace ; with , - just to be sure
                    $SnmpValue  =~  s/;/,/g;

                    if ($CacheTimer > 0) {

                        umask "$UMASK";
                        open (OUT,">$CacheDir/$OID");
                            print OUT $SnmpValue;
                        close (OUT);
                    }
                }
                logger(1, "SnmpGetV1 data from net (cache=$CacheTimer sec.) OID=$OID ");
            } else {
                logger(1, "SnmpGetV1 data from file (cache=$CacheTimer sec.) $CacheDir/$OID ");
            }

            logger(1, "SnmpValue: $SnmpValue");

            # fill hash with data
            $refhSnmpValues->{$OID}="$SnmpValue";
        } # for my $OIDLine ...

        # if we have only 1 OID -> return the Value instead the hash
        if ($#$refaOIDs == 0) {
            return $SnmpValue;
        }
    }
    # return the complete hash with OIDs as keys or
    # undef if the SNMP session fails
    return $refhSnmpValues;
} # sub

# ------------------------------------------------------------------------
# dir creator extracted from our FileOperations library
# ------------------------------------------------------------------------
sub MyMkdir {

    my  $Directory = shift;

    $Directory  =~  s/\s//g;    # remove invisible characters
    $Directory  =~  s/\\/\//g;  # replace \ with /
    $Directory  =~  s/\/+/\//g; # replace duplicate or more slashes with one /

    # split directory into pieces
    my @Dirs    =   split /\//,$Directory;

    # growing directory structure
    my $Snake;

    # walk through each directory and create it
    for my $Dir (@Dirs) {
        $Snake .= $Dir.'/';
        if (not -d "$Snake") {
                        umask "$UMASK";
            my $Success = mkdir $Snake;
            if ("$Success" ne "1") {
                undef $Snake;
                last;
            }
        }
    }

    # remove last / and return the directory back to the caller
    if ("$Snake" =~ /\/$/) {
        chop ($Snake);
    }
    return $Snake;
}

# ------------------------------------------------------------------------
# ExecuteCommand Routine. Enhanced with our cache algorith...
# ------------------------------------------------------------------------
sub ExecuteCommand {
    my $refhStruct=shift;

    my $Command = $refhStruct->{Command};

    my $refaLines=[];   # Pointer to Array of strings (output)

    my $CacheFile;      # Filename storing cached data
    my $ExitCode;       # exit code of the unix command

    my $Now=time();     # current time in seconds since epoch

    my $CacheDir="$ghOptions{'cachedir'}/ExecuteCommand/"; # cache dir

    # Create Cachedir if not existend
    not -d $CacheDir and MyMkdir($CacheDir);

    # If caching for this command is enabled
    if ($refhStruct->{CacheTimer} > 0) {

        $CacheFile = $CacheDir . normalize ("$Command");

        if (-r "$CacheFile") {
            my @FileProperties=stat($CacheFile);

            # $FileProperties[9] = LastModifyTime of file
            # only read the cache file if it is not too old
            if ($Now-$refhStruct->{CacheTimer} < $FileProperties[9]) {
                open (IN,"<$CacheFile");
                    @$refaLines=<IN>;
                close (IN);
                # leave this subroutine with cached data found
                logger(2, "ExecuteCommand (1) got data from cache $CacheFile");
                return ($refaLines,0);
            }
        }
    }

    # execute the unix command
    open(UNIX,"$Command |") or last;
        while (<UNIX>) {
            push @$refaLines,$_;
        }
    close(UNIX);
    $ExitCode=$? >> 8; # calculate the exit code

    logger(2, "ExecuteCommand (2) executed \"$Command\" and got ExitCode \"$ExitCode\"");

    # write a cache file if the cache timer > 0
    if ($refhStruct->{CacheTimer} > 0) {
        logger(2, "ExecuteCommand (3) Write cache file CacheTimer=$refhStruct->{CacheTimer}");
        umask "$UMASK"; # change to rw-rw-rw maybe changed later because of security
        open (OUT,">$CacheFile") or return ($refaLines,$ExitCode);
            print OUT @$refaLines;
        close (OUT);
    }
    return ($refaLines,$ExitCode);
}

# ------------------------------------------------------------------------------
# Csv2Html
# This function generates a html table
#
# Function call:
# $gHtml   = Csv2Html ($refaHeader,$refaLines);
# ------------------------------------------------------------------------------
sub Csv2Html {
    my $refaHeader = shift;       # Header contains the HTML table header as scalar
    my $refaLines  = shift;       # Reference to array of table lines

    my $refaProperties;           # List of properties from each line
    my $HTML;                     # HTML Content back to the caller
    my $HTMLTable;                # HTML Table code only
    my $FS = ';';

    if ($#$refaLines >= 0) {

        # Build HTML format and table header
        $HTML .= '<a name=top></a>'."\n";
        $HTML .= '<br>';
        $HTML .='<span style="font-size:8pt" style="font-family:monospace">'."\n";
        $HTML .='<table border style="font-size:8pt;WORD-BREAK:NORMAL;" bgcolor=#D2D2D2>'."\n";

        # Build html table title header
        #
        # - $Header looks like this:
        # index;Description;Alias;AdminStatus;OperStatus;Speed;IP
        #
        # - It will be transformed to:
        # <th>index</th><th>Description</th><th>Alias</th> ...
        $HTML .= "<th>$_</th>" for ( @$refaHeader );

        foreach my $Line ( @$refaLines ) {
            #logger(3, "CSVline: " . Dumper ($Line));
            # start table line ---------------------------------------------
            $HTMLTable .= "\n<tr";
            my $trTagclose = '>';

            foreach my $Cell ( @$Line ) {

                my $Value;
                my $SpecialCellFormat      = "";
                my $SpecialTextFormatHead  = "";
                my $SpecialTextFormatFoot  = "";

            if ( defined $Cell->{InterfaceGraphURL} ) {
                if($ghOptions{'enableportperf'}){         # thd
                    $HTMLTable .= ' bgcolor="' . $COLORS{"PerfGraph"} .
                        '" onmouseover="ChangeColor(this, true);" onmouseout="ChangeColor(this, false);" '.
                        'onclick="DoNav(\''.$Cell->{InterfaceGraphURL}. '\');" >';
                }else{
                    $HTMLTable .= ' bgcolor="' . $COLORS{"PerfGraph"} . '" onmouseover="ChangeColor(this, true);" onmouseout="ChangeColor(this, false);" >';
                }
                $trTagclose = '';
            }
                $HTMLTable .= $trTagclose;
                $trTagclose = '';
                #logger(1, "HTMLTable: $HTMLTable \nCell: $Cell->{InterfaceGraphURL}");
                # if background is defined ---------------------------------
                if ( defined $Cell->{Background} ) {
                    $SpecialCellFormat .= 'bgcolor="' . $Cell->{Background} . '"';
                }

                # if a special font is indicated ---------------------------
                if ( defined $Cell->{Font} ) {
                    $SpecialTextFormatHead .= $Cell->{Font};
                    $SpecialTextFormatFoot .= '</font>';
                }

                # if we got a value write into cell ------------------------
                if ( defined $Cell->{Value} and  $Cell->{Value} ne " ") {
                    $Value = $Cell->{Value};
                } else {
                # otherwise create a empty cell ----------------------------
                    $Value = "&nbsp;";
                }

                # if a link is indicated -----------------------------------
                if ( defined $Cell->{Link} ) {
                    $Value = '<a href="' . $Cell->{Link} . '">' . $Value . '</a>';
                }

                # finally build the table line;
                $HTMLTable .= "\n" . '<td ' . $SpecialCellFormat . '>' .
                    $SpecialTextFormatHead . $Value .
                    $SpecialTextFormatFoot. '</td>';
            }
            # end table line -----------------------------------------------
            $HTMLTable .= "</tr>";
        }
         $HTMLTable .= "</table>";
         $HTML .= "$HTMLTable</td></tr><br>";
    } else {
        $HTML.='<a href=JavaScript:history.back();>No data to display</a>'."\n";
    }

    return $HTML;
}

# ------------------------------------------------------------------------------
# AppendLinkToText
# Apend html table link to text
# ------------------------------------------------------------------------------
sub AppendLinkToText {

    my $refhStruct = shift;
    my $ResultText;

    #$ResultText = '<a href="' . "$refhStruct->{HtmlUrl}/$refhStruct->{File}" . '">' . $refhStruct->{Text} . '</a>';

    #Modified output to avoid problems with addons not handling html links correctly (ex: nagstamon)
    $ResultText = $refhStruct->{Text} . ' <a href="' . "$refhStruct->{HtmlUrl}/$refhStruct->{File}" . '">[details]</a>';

    return $ResultText;
}

# ------------------------------------------------------------------------------
# ExitPlugin
# Print correct output text and exit this plugin now
# ------------------------------------------------------------------------------
sub ExitPlugin {

    my $refhStruct = shift;

    # --------------------------------------------------------------------
    # when we have UNKNOWN the exit code and the text can
    # be overwritten from the command line with the options
    # -UnknownExit and -UnknownText
    #
    # Example for CRITICAL (code=2):
    #
    # ...itd_check_xxxxx.pl -UnknownExit 2 -UnknownText "Error getting data"
    #
    if ($refhStruct->{ExitCode} == $ERRORS{'UNKNOWN'}) {
        $refhStruct->{ExitCode} = $refhStruct->{UnknownExit};
        $refhStruct->{Text}     = $refhStruct->{UnknownText};
    }

    print $refhStruct->{Text};
    print "|";
    ($basetime) and print "Interface_global::check_interface_table_global::" .
                "time=${TimeDiff}s;;;; " .
                "uptime=$grefhCurrent->{MD}->{sysUpTime}s;;;; " .
                "watched=${gNumberOfPerfdataInterfaces};;;; " .
                "useddelta=${gUsedDelta}s;;;; " .
                "ports=${gNumberOfInterfacesWithoutTrunk};;;; " .
                "freeports=${gNumberOfFreeInterfaces};;;; " .
                "adminupfree=${gNumberOfFreeUpInterfaces};;;; ";
    print "$gPerfdata\n";

    exit $refhStruct->{ExitCode};
}

# ------------------------------------------------------------------------------
# Append Buttons
# ------------------------------------------------------------------------------
sub HtmlLinks {

    my $refhStruct          = shift;
    my $Text                = shift;
    my $InterfaceStateFile  = "$refhStruct->{ResetTable}";
    my $HTML;

    # nice font
    $HTML.='<span style="font-size:8pt" style="font-family:monospace">'."\n";

    # back button
    if ($refhStruct->{Back}) {
        $HTML.='<a href="JavaScript:history.back();">[ back ]</a>'."\n";
    }

    # reset button to remove file
    if ($InterfaceStateFile) {
        if (-f "$InterfaceStateFile") {
            $HTML.="<a href=\"$ghOptions{reseturl}/InterfaceTableReset_v3t.cgi?Command=rm&What=$InterfaceStateFile\">[ reset table ]</a>";
        }
    }

    $HTML.='</span>'."\n";

    return $HTML;
}


# ------------------------------------------------------------------------
# for verbose output
# ------------------------------------------------------------------------
sub logger {
    ################################
    # SUB use: Log and display messages based on loglevel
    # SUB specs: ###################
    # Expected arguments:
    # 0: The loglevel of the message (1-3)
    # 1: The message to be logged
    ################################

    my $loglevel = 0;
    my $msg      = undef;

    $loglevel    = shift;
    $msg         = shift;

    unless($loglevel >= 1 && $loglevel <= 3){die "You passed a message with an invalid loglevel lo logger().\n"}
    unless($ghOptions{verbose} >= 0 && $ghOptions{verbose} <= 3){die "The main loglevel is not set properly (must be 0-3).\n"}

    # define labels for different loglevels
    my %level_labels = ( 1 => "INFO", 2 => "DEBUG", 3 => "TRACE" );

    # fetch the name of the function which called logger()
    my $caller = (caller(1))[3];
    if($caller){
        $caller="|".$caller."| ";
    }else{
        $caller="|main| ";
    }

    if($loglevel <= $ghOptions{verbose}){
        my $space = "";
        if(length($level_labels{$loglevel}) == 4){$space=" "}
        # show the calling function, if loglevel is higher than 2
        if($ghOptions{verbose} > 2){
            print "[$level_labels{$loglevel}]$space $caller";
        }else{
            print "[$level_labels{$loglevel}]$space ";

        }
        print $msg,"\n";
    }
}

# ------------------------------------------------------------------------
# various functions reporting plugin information & usages
# ------------------------------------------------------------------------
sub print_usage () {
  print <<EOUS;

  Usage:
    $PROGNAME [-v] [-t <timeout>] --hostquery=<hostname/IP> [--hostdisplay <host alias to display>]
        [...TODO...]
    $PROGNAME [-h | --help]
    $PROGNAME [--man | --manual]
    $PROGNAME [-V | --version]

  Options:
    --hostdisplay | -h
        host alias to display
    --hostquery | -H
        host to query
    --help | -?
        help page
    --verbose | -v | --debug | --Debug
        verbose mode
    --man | --manual
        manual
    --cachedir | --CacheDir
        caching directory
    --statedir | --StateDir
        interface table state directory
    --accessmethod | AccessMethod
        access method for the link to the host in the HTML page
    --htmldir | --HTMLDir
        interface table HTML directory
    --htmlurl | --HTMLUrl
        interface table URL location
    --enableportperf | --EnablePortPerf
        enable port performance data, default is port perfdata disabled
    --portperfunit | --PortPerfUnit
        bit|octet: in/out traffic in perfdata could be reported in octets or in bits
    --community | -C
        community string
    --delta | --Delta
        interface throuput delta in seconds
    --ifs | --IFS
        input field separator
    --cache
        cache timer
    --reseturl | --ResetUrl
        URL to tablereset program
    --vlan | --VLANs

    --ifloadgradient | --ifLoadGradient
        enable color gradient from green over yellow to red for the load percentage representation
    --track
        list of tracked properties. Values can be:
         * 'ifAdminStatus'      : the administrative status of the interface
         * 'ifOperStatus'       : the operational status of the interface
         * 'ifSpeedReadable'    : the speed of the interface
         * 'ifVlanNames'        : the vlan on which the interface was associated
         * 'IpInfo'             : the ip configuration for the interface
        default is 'ifOperStatus'
    --snapshot

    --version | -V
        plugin version
    --exclude | --Exclude

    --include | --Include

    --timeout

    --warning | -w

    --critical | -c


EOUS

}
sub print_help () {
  print "Copyright (c) 2011 Yannick Charton\n\n";
  print "\n";
  print "  Check various statistics of network interfaces \n";
  print "\n";
  print_usage();
  support();
}
sub print_revision ($$) {
  my $commandName = shift;
  my $pluginRevision = shift;
  $pluginRevision =~ s/^\$Revision: //;
  $pluginRevision =~ s/ \$\s*$//;
  print "$commandName ($pluginRevision)\n";
  print "This nagios/icinga plugin comes with ABSOLUTELY NO WARRANTY. You may redistribute\ncopies of this plugin under the terms of the GNU General Public License.\n";
}
sub support () {
  my $support='Send email to tontonitch-pro@yahoo.fr if you have questions\nregarding use of this plugin. \nPlease include version information with all correspondence (when possible,\nuse output from the -V option of the plugin itself).\n';
  $support =~ s/@/\@/g;
  $support =~ s/\\n/\n/g;
  print $support;
}

# ------------------------------------------------------------------------
# command line options processing
# ------------------------------------------------------------------------
sub check_options () {
    my %commandline = ();
    my @params = (
        'hostdisplay|h=s',
        'hostquery|H=s',
        'help|?',
        'verbose|v|debug|Debug+',
        'man|manual',
        'cachedir|CacheDir=s',              # caching directory
        'statedir|StateDir=s',              # interface table state directory
        'accessmethod|AccessMethod=s',      # access method for the link to the host in the HTML page
        'htmldir|HTMLDir=s',                # interface table HTML directory
        'htmlurl|HTMLUrl=s',                # interface table URL location
        'enableportperf|EnablePortPerf',    # enable port performance data, default is port perfdata disabled
        'excludeportperf|ExcludePortPerf=s',# list of port for which performance data are NOT generated
        'includeportperf|IncludePortPerf=s',# list of port for which performance data are generated
        'portperfunit|PortPerfUnit=s',      # bit|octet: in/out traffic in perfdata could be reported in octets or in bits
        'community|C=s',                    # community string
        'delta|Delta=i',                    # interface throuput delta in seconds
        'ifs|IFS=s',                        # input field separator
        'cache=s',                          # cache timer
        'reseturl|ResetUrl=s',              # URL to tablereset program
        'vlan|VLANs',
        'ifloadgradient|ifLoadGradient',    # color gradient from green over yellow to red representing the load percentage
        'human|Human',                      # translate bandwidth usage in human readable format (G/M/K bps)
        'track=s',                          # list of exclued properties
        'snapshot',
        'version|V',
        'exclude|Exclude=s',
        'include|Include=s',
        'regexp|Regexp',
        'timeout=i',
        'warning|w=i',
        'critical|c=i',
        'ifloadwarn|ifLoadWarn=i',
        'ifloadcrit|ifLoadCrit=i'
        );
    # Default option values
    %ghOptions = (
        'help'              => 0,
        'verbose'           => 0,
        'hostquery'         => '',
        'hostdisplay'       => '',
        'cachedir'          => "$TMPDIR/.ifCache",
        'statedir'          => "$TMPDIR/.ifState",
        'accessmethod'      => "ssh",
        'htmldir'           => "/usr/local/icinga/share/addons/interfacetables",
        'htmlurl'           => "http://monitor/icinga/addons/interfacetables",
        'enableportperf'    => 0,
        'excludeportperf'   => undef,
        'includeportperf'   => undef,
        'portperfunit'      => "bit",
        'community'         => "public",
        'delta'             => 600,
        'ifs'               => ',',
        'cache'             => 3600,
        'reseturl'          => "/icinga/cgi-bin",
        'vlan'              => 0,
        'ifloadgradient'    => 1,
        'human'             => 1,
        'snapshot'          => 0,
        'track'             => ['ifOperStatus'],        # can be compared: ifAdminStatus,ifOperStatus,ifSpeedReadable,ifVlanNames,IpInfo
        'exclude'           => undef,
        'include'           => undef,
        'regexp'            => 0,
        'timeout'           => $TIMEOUT,
        'warning'           => 0,
        'critical'          => 0,
        'ifloadwarn'        => 101,
        'ifloadcrit'        => 101
    );
    # gathering commandline options
    if (! GetOptions(\%commandline, @params)) {
        print_help();
        exit $ERRORS{UNKNOWN};
    }
    ### mandatory commandline options: hostquery
    # applying commandline options
    if (exists $commandline{verbose}) {
        $ghOptions{'verbose'} = $commandline{verbose};
    }
    if (exists $commandline{version}) {
        print_revision($PROGNAME, $REVISION);
        exit $ERRORS{OK};
    }
    if (exists $commandline{help}) {
        print_help();
        exit $ERRORS{OK};
    }
    if (exists $commandline{man}) {
        pod2usage(1);
        exit $ERRORS{OK};
    }
    if (exists $commandline{timeout}) {
        $ghOptions{'timeout'} = $commandline{timeout};
        $TIMEOUT = $ghOptions{'timeout'};
    }
    if (exists $commandline{ifs}) {
        $ghOptions{'ifs'} = "$commandline{ifs}";
    }
    if (! exists $commandline{'hostquery'}) {
        print "host to query not defined (-H)\n";
        print_help();
        exit $ERRORS{UNKNOWN};
    } else {
        $ghOptions{'hostquery'} = "$commandline{hostquery}";
    }
    if (exists $commandline{hostdisplay}) {
        $ghOptions{'hostdisplay'} = "$commandline{hostdisplay}";
    } else {
        $ghOptions{'hostdisplay'} = "$commandline{hostquery}";
    }
    if (exists $commandline{cachedir}) {
        $ghOptions{'cachedir'} = "$commandline{cachedir}";
    }
	$ghOptions{'cachedir'} = "$ghOptions{'cachedir'}/$commandline{hostquery}";
    -d "$ghOptions{'cachedir'}" or MyMkdir ("$ghOptions{'cachedir'}");
    if (exists $commandline{statedir}) {
        $ghOptions{'statedir'} = "$commandline{statedir}";
    }
	$ghOptions{'statedir'} = "$ghOptions{'statedir'}/$commandline{hostquery}";
    -d "$ghOptions{'statedir'}" or MyMkdir ("$ghOptions{'statedir'}");
    if (exists $commandline{accessmethod} && ($commandline{accessmethod} ne "ssh" && $commandline{accessmethod} ne "telnet")) {
        $ghOptions{'accessmethod'} = "$commandline{accessmethod}";
    }
    if (exists $commandline{enableportperf}) {
        $ghOptions{'enableportperf'} = 1;
    }
    # organizing excluded/included interfaces for performance data
    if (exists $commandline{excludeportperf}) {
        my @tmparray = split("$ghOptions{ifs}", join("$ghOptions{ifs}",$commandline{excludeportperf}));
        $ghOptions{'excludeportperf'} = \@tmparray;
    } 
    if (exists $commandline{includeportperf}) {
        my @tmparray = split("$ghOptions{ifs}", join("$ghOptions{ifs}",$commandline{includeportperf}));
        $ghOptions{'includeportperf'} = \@tmparray;
    }
    if (exists $commandline{portperfunit} && ($commandline{portperfunit} ne "bit" && $commandline{portperfunit} ne "octet")) {
        $ghOptions{'portperfunit'} = "bit";
    }
    # organizing not tracked fields
    if (exists $commandline{track}) {
        my @tmparray = split("$ghOptions{ifs}", join("$ghOptions{ifs}",$commandline{track}));
        $ghOptions{'track'} = \@tmparray;
    }
    # organizing excluded/included interfaces
    if (exists $commandline{exclude}) {
        my @tmparray = split("$ghOptions{ifs}", join("$ghOptions{ifs}",$commandline{exclude}));
        $ghOptions{'exclude'} = \@tmparray;
    } 
    if (exists $commandline{include}) {
        my @tmparray = split("$ghOptions{ifs}", join("$ghOptions{ifs}",$commandline{include}));
        $ghOptions{'include'} = \@tmparray;
    }
    if (exists $commandline{regexp}) {
        $ghOptions{'regexp'} = 1;
    }
    if (exists $commandline{htmldir}) {
        $ghOptions{'htmldir'} = "$commandline{htmldir}";
    }
    if (exists $commandline{htmlurl}) {
        $ghOptions{'htmlurl'} = "$commandline{htmlurl}";
    }
    if (exists $commandline{community}) {
        $ghOptions{'community'} = "$commandline{community}";
    }
    if (exists $commandline{delta}) {
        $ghOptions{'delta'} = "$commandline{delta}";
    }
    if (exists $commandline{cache}) {
        $ghOptions{'cache'} = "$commandline{cache}";
    }
    if (exists $commandline{reseturl}) {
        $ghOptions{'reseturl'} = "$commandline{reseturl}";
    }
    if (exists $commandline{ifloadgradient}) {
        $ghOptions{'ifloadgradient'} = 1;
    }
    if (exists $commandline{human}) {
        $ghOptions{'human'} = 1;
    }
    if (exists $commandline{vlan}) {
        $ghOptions{'vlan'} = 1;
    }
    if (exists $commandline{snapshot}) {
        $ghOptions{'snapshot'} = 1;
    }
    if (exists $commandline{warning}) {
        $ghOptions{'warning'} = "$commandline{warning}";
    }
    if (exists $commandline{critical}) {
        $ghOptions{'critical'} = "$commandline{critical}";
    }
    if (exists $commandline{ifloadwarn}) {
        $ghOptions{ifloadwarn} = "$commandline{ifloadwarn}";
    }
    if (exists $commandline{ifloadcrit}) {
        $ghOptions{ifloadcrit} = "$commandline{ifloadcrit}";
    }

    # print the options in command line, and the resulting full option hash
    logger(3, "commandline\n".Dumper(\%commandline));
    logger(3, "options\n".Dumper(\%ghOptions));
}
