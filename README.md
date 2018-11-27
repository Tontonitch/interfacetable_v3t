README
======

description
-----------

Interfacetable_v3t (formerly check_interface_table_v3t) is a Nagios(R) addon
that allows you to monitor the network interfaces of a node (e.g. router, switch,
server) without knowing each interface in detail. Only the hostname (or ip address)
and the snmp community string are required. It generates a html page gathering some
info on the monitored node and a table of all interfaces/ports and their status.

Interfacetable_v3t (or check_interface_table_v3t.pl, which is the name of the plugin
script) comes from:

* `check_interface_table.pl`: plugin released by ITdesign Software Projects & Consulting.
this is the first version of the plugin, extracted from the commercial suite proposed
by ITdesign.
* `check_interface_table_v2.pl`: plugin released by NETWAYS GmbH, it adds the performance
data related to bandwidth usage.

This new version, called `Interfacetable_v3t`, provides some enhancements:

* externalization of the html page design in css stylesheets and js files
* extended interface inclusion/exclusion system
* full documentation
* code review and cleaned, following the nagios plugin development guidelines
* installer
* snmp v2c/v3 and 64bits counters support
* error/discard packet tracking, duplex status tracking
* and much more ! (see changelogs)

See the [TODO](TODO) file for future features.

Support the check of the following node types: Brocade fiberchannel switches, Cisco routers and switches, Linux hosts, Windows hosts, Solaris hosts, Netapp filers

documentation
-------------

Complete documentation: [here](doc/00-toc.md)

Changelog: [here](https://raw.githubusercontent.com/Tontonitch/interfacetable_v3t/documentation/CHANGELOG)
