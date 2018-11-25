**Troubleshooting**
===================

### Table of contents

[\[Show/Hide\]](javascript:toggleToc())

*   [Troubleshooting](#Troubleshooting)
    *   [Known errors/bugs](#Known_errors_bugs)
    *   [Debug mode explanation](#Debug_mode_explanation)
    *   [Common situations](#Common_situations)

Troubleshooting
===============

Known errors/bugs
-----------------

*   NetApp Data OnTap known problems

With the NetApp Release 8.1.1 7-Mode at least, the ifErrors counter and all the related counters in the Netapp MIB behave incorrectly, producing absurd results for that specific statistic.  
![Image](tiki-download_file.php?fileId=180&display)

*   XXXX

CRITICAL - (2 errors) - May 30 16:45:42 rubeus ido2db: Error: database query failed for 'UPDATE icinga\_servicestatus SET instance\_id=1, service\_object\_id=2600, status\_update\_time=FROM\_UNIXTIME(1369925142), output='OK - 223 port(s), 82 free, 52 AdminUp and free, 225 graphed \[details\]', long\_output='', perfdata='Interface\_global::check\_interface\_table\_global::time=2.15s:::: uptime=640315926s:::: watched=225:::: useddelta=600s:::: ports=223:::: freeports=82:::: ...

*   \[KB1001\] AAAAAA

fjklmhgmioehb

*   \[KB1002\] BBBBBB

fjklmhgmioehb

Debug mode explanation
----------------------

*   No debug (as default)

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost
6 interface(s), 5 free <a href="/interfacetable\_v3t/tables/localhost-Interfacetable.html">\[details\]</a>|\[icinga@myserver libexec\]$
\[icinga@myserver libexec\]$

When debug/verbosity is not activated, only the critical error messages are reported.

*   Debug activated (level 1 of debug)

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -v
\[INFO\]  Set ShortCacheTimer = 3600 and LongCacheTimer = 7200
\[INFO\]  Clean/select historical datasets
\[INFO\]   now (1313498617) - comparetimestamp (1313498609) = used delta (8)
\[INFO\]  ifDescr: lo     FreeUp: 0       WithoutTrunk: 0
\[INFO\]  ifDescr: eth0   FreeUp: 0       WithoutTrunk: 1
\[INFO\]  ifDescr: eth6   FreeUp: 0       WithoutTrunk: 2
\[INFO\]  ifDescr: eth1   FreeUp: 0       WithoutTrunk: 3
\[INFO\]  ifDescr: eth7   FreeUp: 0       WithoutTrunk: 4
\[INFO\]  ifDescr: eth2   FreeUp: 0       WithoutTrunk: 5
\[INFO\]  ifDescr: eth3   FreeUp: 0       WithoutTrunk: 6
\[INFO\]  ifDescr: eth4   FreeUp: 0       WithoutTrunk: 6
\[INFO\]  ifDescr: eth5   FreeUp: 0       WithoutTrunk: 6
\[INFO\]  Wrote interface data to file: /tmp/.ifState/localhost/localhost-Interfacetable.txt
\[INFO\]  ---->>> ports: 6, free: 5
\[INFO\]  Differences: 0
\[INFO\]  HTML table file created: /usr/local/nagios/interfacetable\_v3t/share/tables/localhost-Interfacetable.html
6 interface(s), 5 free <a href="/interfacetable\_v3t/tables/localhost-Interfacetable.html">\[details\]</a>|
\[icinga@myserver libexec\]$

Note: the verbosity level can be increased up to 5 times (max: -vvvvv)

Common situations
-----------------

*   "No valid historical dataset..." and how to configure the delta option correctly

  
Each time the plugin runs, it backups a set of data. These sets are used to calculate the interface loads and packet errors/discards rates.  
When launched for the first time, there are no dataset available, so no calculation is done, and a message "first run - initializing interface table now" is displayed.  
Then, for the subsequent launchs of the plugin, there should be some dataset to compare with. In case you receive the message "No valid historical dataset...", the delta parameter of the plugin is not adequate for the check\_interval nagios property associated to the service using the plugin.  
To be valid for the plugin, a dataset should fit to the following rule:  
dataset\_time <= current\_time - (delta + delta / 3)  
Every dataset older that that are purged by the plugin. Consequently, if no dataset remains, you receive the message "No valid historical dataset..."

By default, the deta used by the plugin is delta=600 (10 min)  
With that delta, a dataset\_time must be less than current time - 800s, so 13min20s  
Consequently, the check interval must be less than 13min20s

In case you change the check interval to 15min, you need to change also the delta used by the plugin. For example, set it to 1200 using --delta 1200.

*   "No more variables left in this MIB View"

Symptoms:

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user2 -x user2password -L md5
\[ERROR\] The snmp response seems to be problematic: .1.3.6.1.2.1.2.2.1.8 No more variables left in this MIB View (It is past the end of the MIB tree)

Possible cause 1:  
You're using snmpv2c/v3, and the user is not allowed to browse to the OID .1.3.6.1.2.1.2.2.1.8. Check your snmpd.conf and snmp user permissions.  
Note: you can do some verifications by launching the Unix snmpbulkwalk. To know exactly the command used by the plugin, use debug mode and pipe to tail:

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user2 -x user2password -L md5 -vvv | tail
\[...\]
\[TRACE\] |SnmpUtils::ExecuteCommand| ExecuteCommand: executing the following unix command:
snmpbulkwalk -Oqn -v 3 -t 15 -u user2 -l authNoPriv -a md5 -A user2password localhost:161 .1.3.6.1.2.1.2.2.1.8
\[TRACE\] |SnmpUtils::ExecuteCommand| ExecuteCommand: executed "snmpbulkwalk -Oqn -v 3 -t 15 -u user2 -l authNoPriv -a md5 -A user2password localhost:161 .1.3.6.1.2.1.2.2.1.8" and got ExitCode "0"
\[ERROR\] |SnmpUtils::GetDataWithUnixSnmpWalk| The snmp response seems to be problematic: .1.3.6.1.2.1.2.2.1.8 No more variables left in this MIB View (It is past the end of the MIB tree)

Possible cause 2:  
Maybe bad cached data. Check with better debug level:

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user2 -x user2password -L md5 -vvv | tail
\[...\]
\[DEBUG\] |main::Get\_OperStatus\_Description\_Index| Now="down" File="down"
\[TRACE\] |SnmpUtils::ExecuteCommand| ExecuteCommand: got data from cache /tmp/.ifCache/localhost/ExecuteCommand/snmpbulkwalkQ20Q2DOqnQ20Q2DvQ203Q20Q2DtQ2015Q20Q2DuQ20user
2Q20Q2DlQ20authNoPrivQ20Q2DaQ20md5Q20Q2DAQ20user2password
Q20localhostQ3A161Q20Q2E1Q2E3Q2E6Q2E1Q2E2Q2E1Q2E4Q2E20Q2E1Q2E3
\[ERROR\] |SnmpUtils::GetDataWithUnixSnmpWalk| The snmp response seems to be problematic: .1.3.6.1.2.1.4.20.1.3 No more variables left in 
this MIB View (It is past the end of the MIB tree)

Remove the wrong cache file:

\[icinga@myserver libexec\]$ rm /tmp/.ifCache/localhost/ExecuteCommand/snmpbulkwalkQ20Q2DOqnQ20Q2DvQ203Q20Q2DtQ2015Q20Q2DuQ20user
2Q20Q2DlQ20authNoPrivQ20Q2DaQ20md5Q20Q2DAQ20user2password
Q20localhostQ3A161Q20Q2E1Q2E3Q2E6Q2E1Q2E2Q2E1Q2E4Q2E20Q2E1Q2E3
\[icinga@myserver libexec\]$

Relaunch the plugin:

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user2 -x user2password -L md5
6 interface(s), 5 free, 1 change(s): ifOperStatus - eth4 <a href="/interfacetable\_v3t/tables/localhost-Interfacetable.html">\[details\]</a>|\[icinga@myserver libexec\]$
\[icinga@myserver libexec\]$

*   "SNMP session establishment problem: Received usmStatsWrongDigests.0 Report-PDU with value 1 during synchronization"

Symptoms: [ERROR](ERROR) SNMP session establishment problem: Received usmStatsWrongDigests.0 Report-PDU with value 1 during synchronization  
Cause: bad snmpv3 user password

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user2 -x user2passwor -L md5
\[ERROR\] SNMP session establishment problem: Received usmStatsWrongDigests.0 Report-PDU with value 1 during synchronization
\[ERROR\] Could not read sysUpTime information from host "localhost" with snmp

*   "Could not read sysUpTime information from host"

Symptoms: encryption (-X) and [ERROR](ERROR) Could not read sysUpTime information from host "localhost" with snmp  
Possible cause: privpass no correct

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user3 -x user3password -X user3encryptio -L md5,des
\[ERROR\] Could not read sysUpTime information from host "localhost" with snmp

*   "SNMP session establishment problem: Received usmStatsWrongDigests.0 Report-PDU with value 2 during synchronization"

Symptoms: [ERROR](ERROR) SNMP session establishment problem: Received usmStatsWrongDigests.0 Report-PDU with value 2 during synchronization  
Possible cause: user password not correct

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user3 -x user3passwor -X user3encryption -L md5,des
\[ERROR\] SNMP session establishment problem: Received usmStatsWrongDigests.0 Report-PDU with value 2 during synchronization
\[ERROR\] Could not read sysUpTime information from host "localhost" with snmp

*   "SNMP session establishment problem: Received usmStatsUnknownUserNames.0 Report-PDU with value 2 during synchronization"

Symptoms: [ERROR](ERROR) SNMP session establishment problem: Received usmStatsUnknownUserNames.0 Report-PDU with value 2 during synchronization  
Possible cause: user name not correct

\[icinga@myserver libexec\]$ ./check\_interface\_table\_v3t.pl -H localhost -l user -x user3password -X user3encryption -L md5,des
\[ERROR\] SNMP session establishment problem: Received usmStatsUnknownUserNames.0 Report-PDU with value 2 during synchronization
\[ERROR\] Could not read sysUpTime information from host "localhost" with snmp

* * *

  
The original document is available at [http://www.tontonitch.com/tiki/tiki-index.php?page=Nagios+plugins+-+interfacetable\_v3t+-+documentation+-+0.05+-+Troubleshooting](http://www.tontonitch.com/tiki/tiki-index.php?page=Nagios+plugins+-+interfacetable_v3t+-+documentation+-+0.05+-+Troubleshooting)
