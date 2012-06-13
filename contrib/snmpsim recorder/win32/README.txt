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

A first batch file, "take_partial_record.bat", is in charge of launching the recorder for gathering only the useful oids (oids normally collected by the interfacetable_v3t plugin).
A second batch file, "take_full_record.bat", is in charge of launching the recorder for gathering all the oids in the .1.3.6.1 tree.

Syntax: take_record.bat <agent IP> <agent port> <snmp version> <snmp community> <device type>
Where
 * allowed snmp versions are v1, v2c
 * device type is only used to name the output file

Example:
 D:\win32>take_partial_record.bat 192.168.1.1 161 v2c public cisco6500
 ..........Done!
 D:\win32>

Note:
 A full snapshot takes some time to be collected, in contrary to the partial snapshot which is faster. However, to work on the integration of new supported devices, some extra oids could be needed, so in that case it is recommended to provide a full snaphot.

-------------------------------------
Written by Yannick Charton (tontonitch-pro@yahoo.fr)