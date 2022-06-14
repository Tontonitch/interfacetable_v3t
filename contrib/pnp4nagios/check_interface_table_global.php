<?php

#
# Pnp template for check_interface_table_global checkcommand. It is part of the 2 templates for
# the check_interface_table_v2t0.1 plugin (check_interface_table_v2 adapted by myself):
#  - check_interface_table_global: plots the general performance data
#  - check_interface_table_port: plots the performance data for each port/interface
# By Yannick Charton (tontonitch-pro@yahoo.fr)
# Based on Joerg Linge templates
#

#
# Performance data sample
#

# Interface_global::check_interface_table_global::time=7s;;;; uptime=2766006585s;;;; 
# watched=10;;;; useddelta=3601s;;;; ports=6;;;; freeports=2;;;; adminupfree=0;;;; 
# If_FastEthernet0/0::check_interface_table_port::OctetsIn=2186507033c OctetsOut=1889399468c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_FastEthernet0/1::check_interface_table_port::OctetsIn=0c OctetsOut=0c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_FastEthernet0/1/0::check_interface_table_port::OctetsIn=3263342587c 
# OctetsOut=2662039638c OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_FastEthernet0/1/1::check_interface_table_port::OctetsIn=1071615638c OctetsOut=179983824c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_FastEthernet0/1/2::check_interface_table_port::OctetsIn=0c OctetsOut=0c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_FastEthernet0/1/3::check_interface_table_port::OctetsIn=17988486c OctetsOut=2952977800c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_Serial0/0/0::check_interface_table_port::OctetsIn=0c OctetsOut=0c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_Null0::check_interface_table_port::OctetsIn=0c OctetsOut=0c OctetsInErr=0c 
# OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_Vlan1::check_interface_table_port::OctetsIn=17780022c OctetsOut=3541307c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c 
# If_Vlan2::check_interface_table_port::OctetsIn=1636997791c OctetsOut=1495434843c 
# OctetsInErr=0c OctetsOutErr=0c OctetsInDiscard=0c OctetsOutDiscard=0c

# global perfdata details
# name        num     usage
# time        1
# uptime      2       not plotted, already on the interface table
# watched     3       not plotted, already on the interface table
# useddelta   4       not plotted, already on the interface table
# ports       5
# freeports   6
# adminupfree 7

# port related perfdata: not plotted by this template

$_WARNRULE  = '#FFFF00';
$_CRITRULE  = '#FF0000';
$_MAXRULE   = '#000000';
$_LINE      = '#000000';

#
# Define some variables ..
#
$for_check_command="check_interface_table_v2tX.pl";

#
# Initial Logic ...
#

$ds_name[1] = "Interface status";
$opt[1] = '--vertical-label "Status" -X0 --title "Interface status" --rigid --lower-limit=0';
$opt[1] .= ' --watermark="Template for '.$for_check_command.' by Yannick Charton"';
$def[1] = "";

$def[1] .= rrd::def     ("ports", $RRDFILE[5], $DS[5], "AVERAGE");
$def[1] .= rrd::def     ("freeports", $RRDFILE[6], $DS[6], "AVERAGE");
$def[1] .= rrd::def     ("adminupfree", $RRDFILE[7], $DS[7], "AVERAGE");
$def[1] .= rrd::cdef    ("admindownfree",  "freeports,adminupfree,-" );
$def[1] .= rrd::cdef    ("usedports",  "ports,freeports,-" );
$def[1] .= rrd::area    ("usedports", '#8470FF', "used              ");
$def[1] .= rrd::gprint  ("usedports", array("LAST","MAX","AVERAGE"), "%5.1lf");
$def[1] .= rrd::area    ("admindownfree", '#A52A2A', "free (admin down) ", 'STACK');
$def[1] .= rrd::gprint  ("admindownfree", array("LAST","MAX","AVERAGE"), "%5.1lf");
$def[1] .= rrd::area    ("adminupfree", '#90EE90', "free (admin up)   ", 'STACK');
$def[1] .= rrd::gprint  ("adminupfree", array("LAST","MAX","AVERAGE"), "%5.1lf");

$ds_name[2] = "Interface statistics gathering time";
$opt[2] = '--vertical-label "seconds" -X0 --title "Interface statistics gathering time" --rigid --lower-limit=0';
$opt[2] .= ' --watermark="Template for '.$for_check_command.' by Yannick Charton"';
$def[2] = "";

$def[2] .= rrd::def     ("time", $RRDFILE[1], $DS[1], "AVERAGE");
$def[2] .= rrd::area    ("time", '#8470FF', "time       ");
$def[2] .= rrd::line1   ("time", $_LINE );
$def[2] .= rrd::gprint  ("time", array("LAST","MAX","AVERAGE"), "%6.2lf");

?>
