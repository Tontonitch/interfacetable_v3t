# **About the plugin**

### Table of contents

  * About the plugin
    * Overview
    * History
    * Features
    * System requirements
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

List of devices reported as supported: [here](20-supported-devices.md)

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
  interface, and the error/discard packets.  
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

## System requirements

Hereunder are listed the operating system prerequisits to get the plugin running:

  * Nagios >= 2.x or any fork (Icinga,...)   
  Note on Icinga: >= 1.9.3 recommended in case you use ido2db, as in previous versions there is a small non-critical bug affecting the very long plugin outputs during icinga database inserts.

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

Note: most of these requirements are checked during the ./configure step of the installer.

## Download

The last stable and the archived versions are available on GitHub at: [https://github.com/Tontonitch/interfacetable_v3t/releases](https://github.com/Tontonitch/interfacetable_v3t/releases)

The current development can be viewed anytime at https://github.com/Tontonitch/interfacetable_v3t. Clicking on the following links will download an archive containing the lastest snapshot. _Please note that the snapshots of the repository may be not fuctional, and is available for testing purposes. Always use the stable releases on your production monitoring systems!_

  * [interfacetable_v3t (tarball)](https://github.com/Tontonitch/interfacetable_v3t/tarball/master)
  * [interfacetable_v3t (zipball)](https://github.com/Tontonitch/interfacetable_v3t/zipball/master)

## Support

If you have questions regarding the use of this plugin, please open an issue on GitHub.
Please also include the version information with your questions (when possible, use output from the -V option of the plugin itself).
For any confidential communications, you can email me at [tontonitch-pro at yahoo.fr].

## License

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License
[GPLv3](http://www.gnu.org/licenses/gpl-3.0.txt) for more details.
