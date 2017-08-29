# **About the plugin**

### Table of contents

  * About the plugin
    * Overview
    * History
    * Features
    * Supported/unsupported target devices
    * System requirements
    * Changelog
    * Download
    * Support
    * License

# About the plugin

## Overview

check_interface_table is a plugin that allows you to monitor
one network device (e.g. router, switch, server...) without knowing each
interface in detail. Only the hostname (or ip address) and the snmp community
string are required. The main design goal of this plugin is to monitor all
network devices of a node with only one service. It is optimized for speed and
allows the monitoring of large networks with hundreds of switches and routers.

Server systems like UNIX, Windows, Netapp can also be monitored. In a plug and
play manner it walks through lots of snmp mibs and stores all interface
properties in a nice table. If someone changes interface properties the plugin
recognizes it and displays these changes.

## History

This program was demonstrated by ITdesign during the Nagios conference in
Nuernberg (Germany) on the 12th of October 2007. Normally it is part of the
commercial suite of monitoring add ons around Nagios from ITdesign. This
version is free software under the terms and conditions of GPLV3.

Netways had adapted it to include performance data and calculate bandwidth
usage, making some features mentioned in the COMMERCIAL version available in
the GPL version (version 2 of the plugin) available in this GPL version.

The 3rd version (by Yannnick Charton aka Tontonitch) (version v3t, to make the
distinction with other possible v3 versions), named check_interface_table_v3t
then interfacetable_v3t, brings lots of enhancements and new features to the
v2 version. See the README and CHANGELOG files for more information.

Copyright (C) 2007 ITdesign Software Projects & Consulting GmbH
Copyright (C) 2009 Netways GmbH 
Copyright (C) 2011-2017 Yannick Charton

## Features

This plug-in is in charge of the monitoring of all network interfaces on any
kind of nodes. It has been tested on various node types such as Brocade fiber
channel switches (Fabric OS >= 5.3), Cisco routers/switches, Juniper Netscreen
firewalls, Solaris/Sun SPARC hosts, Netapp filers, ...

  * Linux & Windows hosts on various hardware (HP, DELL,...) or virtualized (VMware) 

It should run correctly for any node types for which the main interface/port
information are available via snmp queries on the standard MIB-II
(RFC1213-MIB)

List of devices reported as supported: [link](tiki-
index.php?page=Nagios+plugins+-+interfacetable_v3t+-+supported+devices "Nagios
plugins - interfacetable_v3t - supported devices" )

This v3t plug-in version brings lots of enhancements:

  * a unique service for monitoring the interfaces is configured for the monitored node. No needs to add/manage/remove interfaces from the monitoring system configuration in case of changes on the interfaces of the node. 
  * generation of an interface table which gathers lots of information on the interface states and usages. This table can be easily accessed via a web browser. 
  * permit customization with the externalization of the html page design in css stylesheets and js files 
  * a flexible tracking with an extended interface inclusion/exclusion system 
  * full documentation 
  * code review and cleaned, following the nagios plugin development guidelines 
  * an installer 
  * snmp v2c/v3 and 64bits counters support 
  * error/discard packet tracking, duplex status tracking 
  * and much more ! (see changelogs) 

The new interface inclusion/exclusion system distinguing properties and
traffic load. 3 levels of inclusion/exclusion:

  * global (exclude/include)  
  globally include/exclude interfaces to be monitored  
  by default, all the interfaces are included in this tracking. Excluding an
  interface from that tracking is usually done for the interfaces that we don't
  want any tracking (e.g. loopback interfaces)

  * traffic tracking (exclude-traffic/include-traffic)   
  include/exclude interfaces from traffic tracking  
  traffic tracking consists in a check of the bandwidth usage of the
  interface,and the error/discard packets.  
  by default, all the interfaces are included in this tracking. Excluding an
  interface from that tracking is usually done for the interfaces known as
  problematic (high traffic load) and consequently for which we don't want load
  tracking

  * property tracking (exclude-property/include-property)   
  include/exclude interfaces from property tracking.  
  property tracking consists in the check of any changes in the properties of an
  interface, properties specified via a plugin option.  
  by default, only the "operstatus" property is tracked. For the operstatus
  property, the exclusion of an interface is usually done when the interface can
  be down for normal reasons (ex: interfaces connected to printers sometime in
  standby mode)

So, to summarize:

| Information                    | Traffic tracking | Property tracking | Remarks                                  |
| ------------------------------ | ---------------- | ----------------- | ---------------------------------------- |
| Index                          |                  |                   |                                          |
| Description                    |                  |                   |                                          |
| Alias                          |                  | yes               |                                          |
| Administrative status          |                  | yes               |                                          |
| Operational status             |                  | yes               |                                          |
| Speed configuration            |                  | yes               |                                          |
| Duplex status                  |                  | yes               |                                          |
| Vlan attribution               |                  | yes               |                                          |
| Spanning Tree mode             |                  | yes               | For specific devices                     |
| Zone                           |                  | yes               | Juniper Netscreen specific               |
| Vsys                           |                  | yes               | Juniper Netscreen specific               |
| Permitted management protocols |                  | yes               | Juniper Netscreen specific               |
| Incoming traffic load          | yes              |                   | bps and bandwidth % usage                |
| Outgoing traffic load          | yes              |                   | bps and bandwidth % usage                |
| Incoming packet load           |                  | yes               | unicast and broadcast/multicast packet load |
|                                |                  |                   |                                          |
| Outgoing packet load           |                  | yes               | unicast and broadcast/multicast packet load |
|                                |                  |                   |                                          |
| IP configuration               |                  | yes               |                                          |
| Incoming packet errors         | yes              |                   |                                          |
| Outgoing packet errors         | yes              |                   |                                          |
| Incoming packet discards       | yes              |                   |                                          |
| Outgoing packet discards       | yes              |                   |                                          |
| Incoming packet dropped        |                  | yes               | F5 BigIP specific                        |
| Outgoing packet dropped        |                  | yes               | F5 BigIP specific                        |

Notes:

  * index and description are not trackable, as commonly changed. 

## Supported/unsupported target devices

Supported target devices


The plugin has been successfully tested on the following devices.  
This is a _non-exhaustive_ list which will be completed with user feedbacks.  
You can contribute to this list by posting on the forum a list of your device
targets, for which the interfacetable_v3t plugin is working or not.

**Allied Telesis**

| Device   | Notes                   |
| -------- | ----------------------- |
| AT-8000S | AT-S94 Version 3.0.0.35 |

**BlueCoat**

| Device      | Notes                                    |
| ----------- | ---------------------------------------- |
| Version 5.x |                                          |
| Version 6.x | seems to have an IP-address/Interface mapping issue ? |

**Brocade**

| Device               | Notes                                    |
| -------------------- | ---------------------------------------- |
| Fiber Channel Switch | tested with FabricOS v6.1.1a, 6.2.2.e, 6.4.1.a |

**Cisco**

| Device         | Notes    |
| -------------- | -------- |
| Catalyst 4000  | IOS 12.2 |
| Catalyst 4500  | IOS 12.2 |
| Catalyst 6506  | IOS 12.2 |
| C2800          | IOS 12.4 |
| C3825          | IOS 12.4 |
| C3845          | IOS 12.4 |
| Cisco ASR 1002 | IOS 12.2 |
| C1812          | IOS 12.4 |
| C3560          | IOS 12.2 |
| C2950          | IOS 12.1 |
| C2960S         | IOS 12.2 |
| Catalyst 6509  | IOS 12.2 |
| C3560          | IOS 12.2 |
| C2970          | IOS 12.2 |
| C2950          | IOS 12.1 |
| C2900XL        | IOS 12.0 |
| C2940          | IOS 12.1 |

**Citrix**

| Device    | Notes  |
| --------- | ------ |
| NetScaler | NS10.1 |

**Dell**

| Device  | Notes        |
| ------- | ------------ |
| Force10 | (10Gb) - 1.0 |

**HP**

| Device                                   | Notes                              |
| ---------------------------------------- | ---------------------------------- |
| ProLiant ML570 G3                        |                                    |
| ProLiant DL580 G7                        |                                    |
| ProCurve Switch 5406                     |                                    |
| ProCurve Switch 2910                     |                                    |
| ProCurve Switch 6410                     |                                    |
| ProCurve Switch 2900-48G (J9050A)        | revision T.13.71                   |
| ProCurve Switch 5412zl Intelligent Edge (J8698A) | revision K.15.08.0013, ROM K.15.28 |
**Juniper**

| Device             | Notes               |
| ------------------ | ------------------- |
| Netscreen SSG-350M | firmware 6.3.0r10.0 |
| Netscreen SSG-550  | firmware 6.3.0r9.0  |
| Netscreen SSG-5    |                     |
| Netscreen 5400     |                     |
| NetScreen ISG-2000 |                     |
| SRX-240            | JunOS ver 10.x/9.x  |
| M10i               | JunOS ver 10.x/9.x  |
| MX80               | JunOS ver 10.x/9.x  |
| SRX-650            | JunOS ver 10.x/9.x  |
| M120               | JunOS ver 10.x/9.x  |
| J2320              | JunOS 9.0R1.10      |

**Netapp**

| Device        | Notes                                |
| ------------- | ------------------------------------ |
| FAS 3140      | tested with NetApp release 7.3.5.1P2 |
| FAS 3240      | tested with NetApp release 7.3.5.1P2 |
| NearStore VTL |                                      |

**SUN-Oracle**

| Device                 | Notes                                    |
| ---------------------- | ---------------------------------------- |
| SPARC Sunfire V890     | tested on solaris 10 u8/u9/u10 and ce interfaces |
| SPARC Enterprise M5000 | tested on solaris 10 u8/u9/u10 and bge, sppp interfaces |
| SPARC Enterprise T5120 | tested on solaris 10 u8/u9/u10 and e1000g interfaces |
| SPARC Enterprise T3-1  | tested on solaris 10 u8/u9/u10 and igb interfaces |
**Vmware guests**

| Device                                   | Notes |
| ---------------------------------------- | ----- |
| On esx 3.5 (Windows Server 2000/2003/2008, CentOS, Debian) |       |
| On esx 4 (Windows Server 2000/2003/2008, CentOS, Debian) |       |

Unsupported target devices


The plugin has been recognized as not working with the following devices:

**Cisco**

| Device | Notes |
| ------ | ----- |
| xxx    | xxx   |
| xxx    | xxx   |

_TO UPDATE WHEN DATA AVAILABLE_

## System requirements

Hereunder are listed the operating system prerequisits to get the plugin
running:

  * Nagios >= 2.x or any fork (Icinga,...)   
  Note on Icinga: >= 1.9.3 recommended in case you use ido2db, as in previous
  versions there is a small non-critical bug affecting the very long plugin
  outputs during icinga database inserts.

  * Pnp4Nagios >= 0.6.12 or NagiosGrapherV1 (might work with NetwaysGrapherV2 but not tested)   
  _note: for pnp4nagios, some problems appeared with old rrdtool versions, so keep it up-to-date (no problem with >=1.4.7)_

  * Net-Snmp 
  * Perl >= 5.x 
  * Perl additional modules: 
    * Net::SNMP library 
    * Config::General library 
    * Data::Dumper library 
    * Getopt::Long library 
    * CGI library 
    * Sort::Naturally
    * Exception::Class
    * Time::HiRes
    * Encode
  * Sudo 

Note: most of these requirements are checked during the ./configure step of the intaller.

## Changelog

0.05-1

  * [feature] nagios 4.x support 
  * [feature] added more variants of the pps graph(s) 
  * [bugfix] fix for vlan on hp switches 
  * [bugfix] some other code fixes 
  * [enhancement] looking at other oids for cisco model/serial info when the common ones don't provide the info 

0.05

  * [enhancement] support of ifDescr in HEX-String (i.e. ifDescr used by Windows SNMP-Service in case of umlauts) (by Enfileyb) 
  * [enhancement] snmpsim recorder reorg and update 
  * [enhancement] more tolerancy for unaccessible oids 
  * [enhancement] config table enhancements (exclusions reviewed: no repetitions in non global exclusion for globally excluded interfaces, other messages not displayed for excluded interfaces) 
  * [enhancement] snmp functions merge and standardization: now 2 functions (get and walk), returning a hash of oids and values 
  * [enhancement] snmp functions enhancement: 
    * can receive multiple oids as arguments, 
    * new cache storage methods (based on Storable library), 
    * exceptions (errors) handling, including oid details on error 
    * unixsnmp now use exclusively snmpget/snmpbulkget instead of perl bindings 
    * result hash can be built with indexes as keys (outputhashkeyidx param) 
    * result hash empty check (checkempty param) 
    * results concatened by key when querying multiple oids 
  * [enhancement] link to html table now persistent when exist, even in case of an UNKNOWN error (ex: when target not accessible) 
  * [enhancement] switched to a cleaner and more standard exception handling system (based on the Exception::Class perl library) 
  * [enhancement] lots of functions revamped and cleaned 
  * [enhancement] new option --(no)ipinfo, to enable/disable the ipinfo. Enabled by default 
  * [enhancement] protection against interface descriptions including double-quotes. 
  * [enhancement] extended support of the following nodetypes: 
    * extended netscreen nodetype: ipinfo, nsrp state and corresponding operstatus alarm rule 
  * [enhancement] easier device support extension 
  * [enhancement] nodetype change protection (changing the nodetype will reset the table) 
  * [enhancement] don't use utils.pm anymore (utils.pm deprecated soon) 
  * [enhancement] oids in a hash format with related info (mib, conversion, ...) + renamed lots of oids for quick understanding 
  * [enhancement] most of the properties are now optional (to select only the wanted columns, and also reduce snmp queries). Use the following options: --alias, --ipinfo, --stp, --duplex, --vlan. Note that the use of the option --alias-matching automatically enable the --alias option. 
  * [enhancement] settings.cfg renamed settings.cfg-sample to avoid settings overwrite during upgrades 
  * [feature] option to sort on Name column at first page load (--default-table-sorting) 
  * [feature] option to write the debug in a file (--debugfile=/aaa/bbb/ccc) 
  * [feature] information tooltips to describe some columns (i.e. oper and admin status) 
  * [feature] added interface type property (--type option) 
  * [feature] the interface table can be splitted by interface type (--table-split option) 
  * [feature] add the graph popups directly on the interface tables. 
  * [feature] new support of the following nodetypes: 
    * new bigip nodetype: support of "BIG-IP Local Traffic Manager" (and maybe other devices of that vendor) 
    * new netapp nodetype: support of Netapp filers (model/product node info + 64-bit counters + extended 32-bit counters (low/high)) 
    * new bluecoat nodetype 
    * new brocade nodetype: firmware model, serial, portnames (~ interface alias) (incl/excl possible) 
    * new brocade-nos nodetype 
    * new nortel nodetype: model, serial, vlan ids per port 
  * [feature] notes, recommendations and warnings in the config table 
  * [feature] new option snmp v3 contextname 
  * [feature] convert sysLocation from hex to string when needed 
  * [feature] max bandwidth monitoring capacity, recommendation on switching to 32/64 counters and delta 
  * [feature] added total bytes to graph in pnp4nagios templates 
  * [bugfix] missing snmp session close 
  * [bugfix] speed detection works when having ifHighSpeed only 
  * [bugfix] remove problematic '#' char from perfdata servicename 
  * [bugfix] fix on ipinfo gathering function to garantee correct ip (mainly for Bluecoat device) 
  * [bugfix] pipe removed from snmp results via unixsnmp 
  * [bugfix] fix nodenames with " " (idroj) 
  * [bugfix] fix servicename with "." (idroj) 
  * [bugfix] fix for unixsnmp when object not available 
  * [bugfix] fix when pkt errors/discards not all available 
  * [bugfix] fix wrong old variable in settings.cfg 
  * [bugfix] fixing an issue with the speed info and related calculations 

Full changelog including previous versions: link

## Download

The last stable and the archived versions are available in the related plugin
page on this website: link

The current development can be viewed anytime at https://github.com/Tontonitch/interfacetable_v3t. Clicking on the following links will download an archive containing the lastest snapshot. _Please note that the snapshots of the repository may be not fuctional, and is available for testing purposes. Always use the stable releases on your production monitoring systems!_

  * [interfacetable_v3t (tarball)](https://github.com/Tontonitch/interfacetable_v3t/tarball/master)
  * [interfacetable_v3t (zipball)](https://github.com/Tontonitch/interfacetable_v3t/zipball/master)

## Support

If you have questions regarding the use of this plugin, a dedicated forum is
in place at: [forum](http://www.tontonitch.com/phpbb/viewforum.php?f=1). Please read the [Support Policy and Forum
Rules](http://www.tontonitch.com/phpbb/viewtopic.php?f=2&t=1683).

Please also include the version information with your questions (when
possible, use output from the -V option of the plugin itself).

For any confidential communications, you can email me at [tontonitch-pro at
yahoo.fr].

PLEASE PREFER POSTING YOUR QUESTION ON THE FORUM.

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License
[GPLv3](http://www.gnu.org/licenses/gpl-3.0.txt) for more details.
