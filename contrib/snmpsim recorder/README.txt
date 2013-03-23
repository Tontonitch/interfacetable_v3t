=====================
 README
=====================

The snmprec program is a compiled version of a part of the snmpsim project, a SNMP 
simulator written by Ilya Etingof.

Only the recorder has been compiled, to allow the interfacetable_v3t users 
to gather monitored device information in order to simulate the device during 
tests and troubleshooting tasks.

How-to use it
-------------

Currently only a win32 compilation has been done. So you will be able to take an snmp oid tree snapshot only from a windows plateform.

A batch file, "take_full_record.bat", is in charge of launching the recorder for gathering all the oids in the .1.3.6.1 tree.

Syntax: take_full_record.bat <agent_address> <agent_port> <snmp_version> <snmp_community> <device_name>
Where
 * agent_address: IP address of the target device
 * agent port: usually 161
 * snmp_version: can be v1 or v2c
 * snmp_community: snmp community of the target device
 * device_name: this is just a base for the name the output file

The snapshot file is generated in the devices directory.

Example:
 D:\win32>take_partial_record.bat 192.168.1.1 161 v2c public cisco6500
 ..........Done!
 D:\win32>

Note:
 A full snapshot can take some time to be collected.

-------------------------------------
Written by Yannick Charton (tontonitch-pro@yahoo.fr)