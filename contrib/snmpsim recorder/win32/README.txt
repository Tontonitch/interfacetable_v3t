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

A batch file is in charge of launching the recorder for gathering only the useful oids.

Syntax: take_record.bat <agent IP> <community> <device_type>
Note: device_type is only used to name the output file
Example:
 D:\win32>take_record.bat 192.168.1.1 public cisco6500
 ..........Done!
 D:\win32>


-------------------------------------
Written by Yannick Charton (tontonitch-pro@yahoo.fr)