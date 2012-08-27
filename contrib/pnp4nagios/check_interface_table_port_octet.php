<?php

#
# Pnp template for check_interface_table, port perfdata part, output in octets
# Includes the possibility to choose what to display
# By Yannick Charton (tontonitch-pro@yahoo.fr)
# For pnp4nagios v0.6.11 and above
#

#
# Define some variables ..
#

$_WARNRULE  = '#FFFF00';
$_CRITRULE  = '#FF0000';
$_MAXRULE   = '#000000';
$_AREA_PRCT = '#256aef';
$_AREA_BYTE = '#8FBC8F';
$_LINE      = '#000000';
$colors     = array("#CC3300","#CC3333","#CC3366","#CC3399","#CC33CC",
"#CC33FF","#336600","#336633","#336666","#336699","#3366CC","#3366FF",
"#33CC33","#33CC66","#609978","#922A99","#997D6D","#174099","#1E9920",
"#E88854","#AFC5E8","#57FA44","#FA6FF6","#008080","#D77038","#272B26",
"#70E0D9","#0A19EB","#E5E29D","#930526","#26FF4A","#ABC2FF","#E2A3FF",
"#808000","#000000","#00FAFA","#E5FA79","#F8A6FF","#FF36CA","#B8FFE7",
"#CD36FF","#CC3300","#CC3333","#CC3366","#CC3399","#CC33CC","#CC33FF",
"#336600","#336633","#336666","#336699","#3366CC","#3366FF","#33CC33",
"#33CC66","#609978","#922A99","#997D6D","#174099","#1E9920","#E88854",
"#AFC5E8","#57FA44","#FA6FF6","#008080","#D77038","#272B26","#70E0D9",
"#0A19EB","#E5E29D","#930526","#26FF4A","#ABC2FF","#E2A3FF","#808000",
"#000000","#00FAFA","#E5FA79","#F8A6FF","#CC3300","#CC3333","#CC3366",
"#CC3399","#CC33CC","#CC33FF","#336600","#336633","#336666","#336699",
"#3366CC","#3366FF","#33CC33","#33CC66","#609978","#922A99","#997D6D",
"#174099","#1E9920","#E88854","#AFC5E8","#57FA44","#FA6FF6","#008080",
"#D77038","#272B26","#70E0D9","#0A19EB","#E5E29D","#930526","#26FF4A",
"#ABC2FF","#E2A3FF","#808000","#000000","#00FAFA","#E5FA79","#F8A6FF",
"#FF36CA","#B8FFE7","#CD36FF");

## Parameters
$display_traffic    = 1; # 0/1: disable/enable the traffic graph
$display_errors     = 1; # 0/1: disable/enable the error graph
$display_operstatus = 1; # 0: disable the operational status info in graphs
                         # 1: generate a new graph for operstatus
                         # 2: add a red/orange/green line on the top of the traffic graph depending on the operstatus

#
# Initial Logic ...
#

$num_graph = 0;

###############################
# Traffic graph
###############################

if($display_traffic == 1){
    $num_graph++;
    $ds_name[$num_graph] = 'Interface traffic';
    $opt[$num_graph] = " --vertical-label \"bits/s\" -b 1000 --slope-mode --title \"Interface Traffic for $hostname / $servicedesc\" ";
    $opt[$num_graph] .= "--watermark=\"Template: check_interface_table_port_octet.php by Yannick Charton\" ";
    $def[$num_graph] = "";
    $def[$num_graph] .= rrd::def     ("octets_in", $RRDFILE[2], $DS[2], "AVERAGE");
    $def[$num_graph] .= rrd::def     ("octets_out", $RRDFILE[3], $DS[3], "AVERAGE");
    if(($display_operstatus == 2) && (isset($RRDFILE[7]))){
        $def[$num_graph] .= rrd::def     ("oper_status", $RRDFILE[1], $DS[1], "AVERAGE");
        $def[$num_graph] .= rrd::ticker  ("oper_status", 1.1, 2.1, -0.02,"ff","#00ff00","#ff0000","#ff8c00");
    }
    $def[$num_graph] .= rrd::cdef    ("bits_in",  "octets_in,8,*" );
    $def[$num_graph] .= rrd::cdef    ("bits_out", "octets_out,8,*" );
    $def[$num_graph] .= rrd::cdef    ("bits_in_redef", "bits_in,UN,PREV,bits_in,IF");
    $def[$num_graph] .= rrd::cdef    ("bits_out_redef", "bits_out,UN,PREV,bits_out,IF");
    $def[$num_graph] .= rrd::area    ("bits_in_redef",  '#32CD32', 'in_bps        ');
    $def[$num_graph] .= rrd::gprint  ("bits_in_redef",  array("LAST","MAX","AVERAGE"), "%8.2lf%Sbps");
    $def[$num_graph] .= rrd::line1   ("bits_out_redef", '#0000CD', 'out_bps       ');
    $def[$num_graph] .= rrd::gprint  ("bits_out_redef", array("LAST","MAX","AVERAGE"), "%8.2lf%Sbps");
    # Total Values in
    $def[$num_graph] .= rrd::vdef    ("total_in", "octets_in,TOTAL");
    $def[$num_graph] .= "GPRINT:total_in:\"Total in  %3.0lf %sB total\\n\" ";
    # Total Values out
    $def[$num_graph] .= rrd::vdef    ("total_out", "octets_out,TOTAL");
    $def[$num_graph] .= "GPRINT:total_out:\"Total out %3.0lf %sB total\\n\" ";
}

###############################
# Error/discard packets graph
###############################

if(($display_errors == 1) && (isset($RRDFILE[4]))){
    $num_graph++;
    $ds_name[$num_graph] = 'Error/discard packets';
    $opt[$num_graph] = " --vertical-label \"pkts/s\" -b 1000 --title \"Error/discard packets for $hostname / $servicedesc\" ";
    $opt[$num_graph] .= "--watermark=\"Template: check_interface_table_port_octet.php by Yannick Charton\" ";
    $def[$num_graph] = "";
    $def[$num_graph] .= rrd::def     ("pkt_in_err", $RRDFILE[4], $DS[4], "AVERAGE");
    $def[$num_graph] .= rrd::def     ("pkt_out_err", $RRDFILE[5], $DS[5], "AVERAGE");
    $def[$num_graph] .= rrd::def     ("pkt_in_discard", $RRDFILE[6], $DS[6], "AVERAGE");
    $def[$num_graph] .= rrd::def     ("pkt_out_discard", $RRDFILE[7], $DS[7], "AVERAGE");
    $def[$num_graph] .= rrd::area    ("pkt_in_err",      '#FFD700', 'in_err              ');
    $def[$num_graph] .= rrd::gprint  ("pkt_in_err", array("LAST","MAX","AVERAGE"), "%5.1lf%S");
    $def[$num_graph] .= rrd::area    ("pkt_out_err",     '#FF8C00', 'out_err             ', 'STACK');
    $def[$num_graph] .= rrd::gprint  ("pkt_out_err", array("LAST","MAX","AVERAGE"), "%5.1lf%S");
    $def[$num_graph] .= rrd::area    ("pkt_in_discard",  '#7B68EE', 'in_discard          ', 'STACK');
    $def[$num_graph] .= rrd::gprint  ("pkt_in_discard", array("LAST","MAX","AVERAGE"), "%5.1lf%S");
    $def[$num_graph] .= rrd::area    ("pkt_out_discard", '#BA55D3', 'out_discard         ', 'STACK');
    $def[$num_graph] .= rrd::gprint  ("pkt_out_discard", array("LAST","MAX","AVERAGE"), "%5.1lf%S");
}

if($display_operstatus == 1){
    $num_graph++;
    $ds_name[$num_graph] = 'Operational status';
    $opt[$num_graph] = " --vertical-label \"\"  --title 'Operational status' --y-grid none --units-length 8";
    $opt[$num_graph] .= " --watermark=\"Template: check_interface_table_port_octet.php by Yannick Charton\" ";
    $def[$num_graph] = "";
    $def[$num_graph] .= rrd::def     ("oper_status", $RRDFILE[1], $DS[1], "AVERAGE");
    $def[$num_graph] .= rrd::ticker  ("oper_status", 1.1, 2.1, 0.33,"ff","#00ff00","#ff0000","#ff8c00");
}

?>

