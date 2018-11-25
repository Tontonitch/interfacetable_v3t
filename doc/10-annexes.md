**Annexes**
===========

### Table of contents

[\[Show/Hide\]](javascript:toggleToc())

*   [Annexes](#Annexes)
    *   [Testing the plugin](#Testing_the_plugin)
    *   [Taking a MIB snapshot](#Taking_a_MIB_snapshot)
    *   [Screenshots](#Screenshots)

Annexes
=======

Testing the plugin
------------------

To be able to test non stable released of the plugin (alpha, beta, release candidate versions), you may want to use a special installation type: "testing". Installing in such a way create a separate directory tree for the plugin, and avoid the replacement of an existing one. After such an installation, you will be able to test **in command line** the plugin against your different node types. In command line only because you certainly don't want to process the generated performance data.

  
Installation in testing mode

Upload the interface\_table\_XXX archive to your server and uncompress it in a temporary directory (ex: /var/tmp/install/icinga/plugins/it-0.05-rc2)

Make the configure file executable:

\# cd /var/tmp/install/icinga/plugins/it-0.05-rc2
# chmod a+x ./configure

Note: all options descriptions are available via

./configure --help

Install the software in testing mode with the option **\--enable-testing**. This mode is simply a shortcut for installing everything in a selected directory (specified with the **\--prefix** option). In this way, there will be no impact on a running installation of this addon.

\[root@snoopy it\_v3t-0.05-rc2\]# ./configure --prefix /var/tmp/tests/it\_v3t-0.05-rc2 --enable-testing
\[...\]
\*\*\* Configuration summary for interfacetable\_v3t 0.05-rc2 XX-XX-2013 \*\*\*:

                               --- TESTING MODE ENABLED ---
 Note: due to the testing mode, you will need to
    \* copy the generated interfacetable\_v3t.conf httpd config file from the testing apache conf.d dir to the httpd configuration directory on the system, renamed as you want


 Global installation directories:
 --------------------------------
                           ${prefix}:  /var/tmp/tests/it\_v3t-0.05-rc2
                      ${exec\_prefix}:  /var/tmp/tests/it\_v3t-0.05-rc2
         libdir (for perl libraries):  ${exec\_prefix}/lib
        sysconfdir (for config file):  ${prefix}/etc
 datarootdir (for html, css, js,...):  ${prefix}/share
 Note: exec\_prefix, libdir, sysconfdir and datadir can be changed for fine tuned installations

 Nagios & related options:
 -------------------------
                  Install user/group:  nagios,nagios
                     Nagios base dir:  /var/tmp/tests/it\_v3t-0.05-rc2/nagios
                  Nagios libexec dir:  /var/tmp/tests/it\_v3t-0.05-rc2/nagios/libexec
    InterfaceTable\_v3t addon CGI dir:  /var/tmp/tests/it\_v3t-0.05-rc2/nagios/sbin
    InterfaceTable\_v3t addon CGI url:  /interfacetable\_v3t\_testing/cgi-bin
   InterfaceTable\_v3t addon HTML url:  /interfacetable\_v3t\_testing
                     Cache files dir:  /var/tmp/tests/it\_v3t-0.05-rc2/tmp/.ifCache
                     State files dir:  /var/tmp/tests/it\_v3t-0.05-rc2/tmp/.ifState

 Graphing options:
 -----------------
              Graphing solution name:  pnp4nagios
               Graphing solution url:  /pnp4nagios

 Apache & sudo options:
 ----------------------
                   Apache conf.d dir:  /var/tmp/tests/it\_v3t-0.05-rc2/httpd/conf.d
                         Apache User:  apache
                     Apache AuthName:  Nagios Access
                        Sudoers file:  /etc/sudoers

 Other options:
 ----------------------
          Port performance data unit:  bps
            MAX\_PLUGIN\_OUTPUT\_LENGTH:  8192
\[...\]
\[root@snoopy it\_v3t-0.05-rc2\]#

Install the files

\# make install

  
Apache configuration

Install the apache config file

\# make install-apache-config

The generated config file will be located in the test directory tree, in this case in /var/tmp/tests/it-0.05-rc2/httpd/conf.d

\# ls /var/tmp/tests/it-0.03b1/httpd/conf.d
interfacetable\_v3t.conf

Copy and rename it to the correct http conf dir:

\# \[debian flavor\] # cp /var/tmp/tests/it-0.03b1/httpd/conf.d/interfacetable\_v3t.conf /etc/apache2/conf.d/interfacetable\_v3t\_testing.conf

or

\# \[redhat flavor\] # cp /var/tmp/tests/it-0.03b1/httpd/conf.d/interfacetable\_v3t.conf /etc/httpd/conf.d/interfacetable\_v3t\_testing.conf

Then edit the file and comment all the following lines:

AuthType ...
AuthUserFile ...
Require ...

Reload the apache configuration

\# /etc/init.d/apache2 reload
Reloading web server config: apache2.
#

  
Sudo configuration

This is like the normal installation:

\# make install-sudo-config
\[...\]
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
Sudo configuration updated.
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

The addon is now ready for testing ![biggrin](img/smiles/icon_biggrin.gif)  
Test that the plugin works

Check that all the requirements are well installed by launching the script as the nagios/icinga user:

\[icinga@snoopy libexec\]$ ./check\_interface\_table\_v3t.pl -V
./check\_interface\_table\_v3t.pl (0.05-rc2)
This nagios plugin comes with ABSOLUTELY NO WARRANTY. You may redistribute
copies of this plugin under the terms of the GNU General Public License version 3 (GPLv3).
\[icinga@snoopy libexec\]$

Taking a MIB snapshot
---------------------

Procedure to take a MIB snapshot: On a windows workstation, 1. download and uncompress the snmpsim recorder package from the "other downloads" part at the [plugin page](tiki-index.php?page=Nagios+plugins+-+interfacetable_v3t "Nagios plugins - interfacetable_v3t"). 2. in command line, go to the "snmpsim recorder" directory, and execute the take\_full\_record.bat as following:

take\_full\_record.bat <agent\_address> <agent\_port> <snmp\_version> <snmp\_community> <device\_name>

where

*   agent\_address: IP address of the target device
*   agent port: usually 161
*   snmp\_version: can be v1 or v2c
*   snmp\_community: snmp community of the target device
*   device\_name: this is just a base for the generated file

This will generate a .snmprec file in devices. This is a snapshot of the snmp mib of the device. This file can be used to simulate the device and speedup any development/troubleshooting.

Screenshots
-----------

* * *

  
The original document is available at [http://www.tontonitch.com/tiki/tiki-index.php?page=Nagios+plugins+-+interfacetable\_v3t+-+documentation+-+0.05+-+Annexes](http://www.tontonitch.com/tiki/tiki-index.php?page=Nagios+plugins+-+interfacetable_v3t+-+documentation+-+0.05+-+Annexes)
