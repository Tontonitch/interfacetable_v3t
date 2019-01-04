# **Plugin usage**

### Table of contents

*   [Plugin usage](#Plugin_usage)
    *   [General usage](#General_usage)
    *   [Command line parameters](#Command_line_parameters)
        *   [General options](#General_options)
        *   [Plugin common options](#Plugin_common_options)
        *   [Global interface inclusions/exclusions](#Global_interface_inclusions_exclusions)
        *   [Traffic checks (load & packet errors/discards)](#Traffic_checks_load_packet_errors_discards_)
        *   [Property checks (interface property changes)](#Property_checks_interface_property_changes_)
        *   [Snmp options](#Snmp_options)
        *   [Graphing options](#Graphing_options)
        *   [Other options](#Other_options)
    *   [Examples](#Examples)
        *   [Generalities](#Generalities)
        *   [Basis](#Basis)
        *   [Common](#Common)
        *   [Different snmp versions](#Different_snmp_versions)

# Plugin usage

## General usage

*   basic usage:

```
./check_interface_table_v3t.pl [-vvvvv] -H "hostname/IP" [-h "host alias"]
[-2] [-C "community string"]
[--exclude "globally excluded interface list"] [--include "globally included interface list"]
[--warning "warning load prct","warning pkterr/s","warning pktdiscard/s"]
[--critical "critical load prct","critical pkterr/s","critical pktdiscard/s"]
[--track-property "tracked property list"]
[--include-property "property tracking interface inclusion list"]
[--exclude-property "property tracking interface exclusion list"]
[--warning-property "warning property change counter"]
[--critical-property "critical property change counter"] [-r] [-f]
```

*   advanced usage:

```
./check_interface_table_v3t.pl [-vvvvv] [-t <timeout>] -H <hostname/IP> [-h <host alias>]
[-2] [-C <community string>] [--domain <transport domain>] [-P <port>] [--nodetype <type>]
[-e <globally excluded interface list>] [-i <globally included interface list>]
[--et <traffic tracking interface excl list>] [--it <traffic tracking interface incl list>]
[--wt <warning load prct>,<warning pkterr/s>,<warning pktdiscard/s>]
[--ct <critical load prct>,<critical pkterr/s>,<critical pktdiscard/s>]
[--tp <property list>] [--ip <property tracking interface incl list>]
[--ep <property tracking interface excl list>] [--wp <warning property change counter>]
[--cp <critical property change counter>] [-r] [-f] [--cachedir <caching directory>]
[--statedir <state files directory>] [--(no)duplex] [--(no)stp] [--(no)vlan]
[--accessmethod <method>[:<target>]] [--htmltabledir <system path to html interface tables>]
[--htmltableurl <url to html interface tables>] [--htmltablelinktarget <target window>]
[-d <delta>] [--ifs <separator>] [--cache <cache retention time>] [--reseturl <url to reset cgi>]
[--(no)ifloadgradient] [--(no)human] [--(no)snapshot] [-g <grapher solution>]
[--grapherurl <url to grapher>] [--portperfunit <unit>] [--perfdataformat <format>]
[--perfdatathreshold <format>] [--outputshort] [--snmp-timeout <timeout>]
[--snmp-retries <number of retries>] [--(no)configtable] [--(no)unixsnmp]
[--debugfile=/path/to/file.debug] [--(no)pkt] [--(no)type]
```

*   other usages:

```
./check_interface_table_v3t.pl [--help | -?]
./check_interface_table_v3t.pl [--version | -V]
./check_interface_table_v3t.pl [--showdefaults | -D]
```

## Command line parameters

### General options

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| -?, --help | Show this help page |  |
| -V, --version | Plugin version |  |
| -v, --verbose | Verbose mode. Can be specified multiple times to increase the verbosity (max 5 times). Verbose levels are INFO, DEBUG, TRACE1, TRACE2, and DUMP |  |
| -D, --showdefaults | Print the option default values |  |  

### Plugin common options

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| -H, --hostquery **(required)** | Specifies the remote host to poll. |  |
| -h, --hostdisplay | Specifies the remote host to display in the HTML link. If omitted, it defaults to the host with -H | It takes by default the value of the --host option |
| -r, --regexp | Interface names and property names for some other options will be interpreted as regular expressions. |  |
| --outputshort | Reduce the verbosity of the plugin output. If used, the plugin only returns general counts (nb ports, nb changes,...). This is close to the way the previous versions of the plugin was working. | In this version of the plugin, by default the plugin returns: <br>+ general counts (nb ports, nb changes,...) <br>+ what changes has been detected <br>+ what interface(s) suffer(s) from high load |

### Global interface inclusions/exclusions

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| -e, --exclude | \* Comma separated list of interfaces globally excluded from the monitoring. Excluding an interface from that tracking is usually done for the interfaces that we don't want any tracking. For example: <br>+ virtual interfaces <br>+ loopback interfaces <br>\* Excluded interfaces are represented by black overlayed rows in the interface table or are listed in the config table if enabled <br>\* Excluding an interface globally will also exclude it from any tracking (traffic and property tracking). |  |
| -i, --include | \* Comma separated list of interfaces globally included in the monitoring. <br>\* By default, all the interfaces are included. <br>\* There are some cases where you need to include an interface which is part of a group of previously excluded interfaces. |  |

### Traffic checks (load & packet errors/discards)

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| --et, --exclude-traffic | \* Comma separated list of interfaces excluded from traffic checks (load & packet errors/discards). Can be used to exclude: <br>+ interfaces known as problematic (high traffic load) <br>\* Excluded interfaces are represented by a dark grey (css dependent) cell style in the interface table <br>\* Excluded interfaces are listed in the config table if enabled |  |
| --it, --include-traffic | \* Comma separated list of interfaces included for traffic checks (load & packet errors/discards). <br>\* By default, all the interfaces are included. <br>\* There are some case where you need to include an interface which is part of a group of previously excluded interfaces. |  |
| --wt, --warning-traffic, --warning | \* Interface traffic load percentage leading to a warning alert <br> \* Format: <br> \--warning-traffic "load%","pkterr/s","pktdiscard/s" <br>ex: --warning-traffic 70,100,100 <br>\* For "load", a threshold >100 means no threshold <br>\* For "pkterr/s" and "pktdiscard/s", a threshold set to -1 means no threshold | 101,1000,1000 |
| --ct, --critical-traffic, --critical | \* Interface traffic load percentage leading to a critical alert <br>\* Format: <br>\--critical-traffic "load%","pkterr/s","pktdiscard/s"  <br>ex: --critical-traffic 95,1000,1000  <br>\* For "load", a threshold >100 means no threshold <br>\* For "pkterr/s" and "pktdiscard/s", a threshold set to -1 means no threshold | 101,5000,5000 |
| --(no)pkt | Unicast/non-unicast pkt stats for each interface. | _disabled_ |
| --(no)trafficwithpkt | Enable traffic calculation using pkt counters instead of octet counters. Useful when using 32-bit counters to track the load on > 1GbE interfaces. | _disabled_ |

### Property checks (interface property changes)

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| --tp, --track-property | Comma separated list of tracked properties. Values can be: <br>.Standard:  <br>\* 'ifAlias' : the interface alias  <br>\* 'ifAdminStatus' : the administrative status of the interface   <br>\* 'ifOperStatus' : the operational status of the interface <br>\* 'ifSpeedReadable' : the speed of the interface <br>\* 'ifStpState' : the Spanning Tree state of the interface <br>\* 'ifDuplexStatus' : the operation mode of the interface (duplex mode) <br>\* 'ifVlanNames' : the vlan on which the interface was associated <br>\* 'ifIpInfo' : the ip configuration for the interface <br>.Netscreen specific: <br>\* 'nsIfZone' : the security zone name an interface belongs to <br>\* 'nsIfVsys' : the virtual system name an interface belongs to <br>\* 'nsIfMng' : the management protocols permitted on the interface <br>Default is 'ifOperStatus' only <br>Example: --tp='ifOperStatus,nsIfMng' | ifOperStatus |
| --ep, --exclude-property | \* Comma separated list of interfaces excluded from the property tracking. <br>\* For the 'ifOperStatus' property, the exclusion of an interface is usually done when the interface can be down for normal reasons (ex: interfaces connected to printers sometime in standby mode) <br>\* Excluded interfaces are represented by a dark grey (css dependent) cell style in the interface table <br>\* Excluded interfaces are listed in the config table if enabled |  |
| --ip, --include-property | \* Comma separated list of interfaces included in the property tracking. <br>\* By default, all the interfaces that are tracked are included. <br>\* There are some case where you need to include an interface which is part of a group of previously excluded interfaces. |  |
| --wp, --warning-property | Number of property changes leading to a warning alert | 0 _(disactivated)_ |
| --cp, --critical-property | Number of property changes leading to a critical alert | 0 _(disactivated)_ |

### Snmp options

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| -C, --community **(required)** | Specifies the snmp v1/v2c community string. |  |
| -2, --v2c | Use snmp v2c |  |
| -l, --login=LOGIN | Auth login for snmpv3 authentication. If no priv password exists, implies AuthNoPriv |  |
| -x, --passwd=PASSWD | Auth password for snmpv3 authentication. If no priv password exists, implies AuthNoPriv |  |
| -X, --privpass=PASSWD | Priv password for snmpv3 (AuthPriv protocol) |  |
| -L, --protocols="authproto","privproto" | \* "authproto": Authentication protocol (md5&#124;sha) <br>\* "privproto": Priv protocole (des&#124;aes) | md5,des |
| --domain="transport domain" | SNMP transport domain. <br>Can be: udp (default), tcp, udp6, tcp6. <br>Specifying a transport domain also change the default port according to that selected transport domain. Use --port to overwrite the port. | udp |
| --contextname="context name" | Context name for the snmp requests (snmpv3 only) |  |
| -P, --port=PORT | SNMP port | 161 |
| --64bits | Use SNMP 64 bits counters |  |
| --max-repetitions=integer | Available only for snmp v2c/v3. Increasing this value may enhance snmp query performances by gathering more results at one time. Setting it to 1 would disable the use of get-bulk. | Automatically set by the system |
| --snmp-timeout | Define the Transport Layer timeout in seconds for the snmp queries. Value can be from 1 to 60. Note: multiply it by the snmp-retries+1 value to calculate the complete timeout. | 2 |
| --snmp-retries | Define the number of times to retry sending a SNMP message. Value can be from 0 to 20. | 2 |
| --snmp-maxmsgsize | Size of the SNMP message in octets, usefull in case of too Long responses. Be carefull with network filters. Range 484 - 65535. Apply only to netsnmp perl bindings. | The default is 1472 octets for UDP/IPv4, 1452 octets for UDP/IPv6, 1460 octets for TCP/IPv4, and 1440 octets for TCP/IPv6 |
| --(no)unixsnmp | Use unix snmp utilities for snmp requests (table/bulk requests), in place of perl bindings. | Default is to use perl bindings. |

### Graphing options

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| -f, --enableperfdata | Enable port performance data, default is port perfdata disabled | _disabled_  |
| --perfdataformat | Define which performance data will be generated. Can be: <br>\* 'full': generated performance data include plugin related stats, interface status, interface load stats, and packet error stats <br>\* 'loadonly': generated performance data include plugin related stats, interface status, and interface load stats <br>\* 'globalonly': generated performance data include only plugin related stats. <br>'loadonly' should be used in case of too many interfaces and consequently too much performance data which cannot fit in the nagios plugin output buffer. By default, its size is 8k and can be extended by modifying MAX\_PLUGIN\_OUTPUT\_LENGTH in the nagios sources. | full |
| --perfdatathreshold | Define which thresholds are printed in the generated performance data. Can be: <br>\* 'full' : thresholds in the generated performance data are generated for include plugin related stats, interface load stats, and packet error stats <br>\* 'loadonly' : thresholds in the generated performance data include plugin related stats and interface load stats <br>\* 'globalonly' : thresholds in the generated performance data include only plugin related stats <br>Default is 'full'. 'loadonly' or 'globalonly' could be used in case of a too long plugin output producing problems with nagios/icinga's buffers. | full |
| --perfdatadir | When specified, the performance data are written directly to a file in the specified location instead of transmitted to Icinga/Nagios. Please use the same hostname as in Icinga/Nagios for -H or -h. | /usr/local/pnp4nagios/var/spool |
| --perfdataservicedesc | (only used when using --perfdatadir and --grapher pnp4nagios). Service description to use in the generated performance data. Should match what is used in the Nagios/Icinga configuration. Optional if environment macros are enabled in nagios.cfg/icinga.cfg (enable\_environment\_macros=1). | "Interface status" |
| -g, --grapher | Specify the used graphing solution. Can be: <br>\* pnp4nagios <br>\* nagiosgrapher <br>\* netwaysgrapherv2 | pnp4nagios |
| --grapherurl | Graphing system url | /pnp4nagios |
| --portperfunit | In/out traffic in perfdata could be reported in bits (counters) or in bps (calculated value). <br>Using bps avoid abnormal load values to be plotted on the graphs. <br>_!!! WARNING !!! <br>switching from one mode to the other require the change of the Data Source Type (DST) in the rrd files already generated by pnp4nagios (or similar action for the other graphing solutions) <br>!!! WARNING !!!_ <br>Possible values: bit or bps (default) <br>Note that the 'octet' choice has been removed. Please contact me if you used it | bps _(or installation related)_ |

### Other options

| Keyword | Description | Default value |
| ------- | ----------- | ------------- |
| --cachedir | Sets the directory where snmp responses are cached. | _Installation related_ |
| --statedir | Sets the directory where the interface states are stored. | _Installation related_ |
| --nodetype="type" | Specify the node type, for specific information to be printed / specific oids to be used. <br>Possible nodetypes are: standard (default), cisco, hp, netscreen, netapp, netapp-cdot, bigip, bluecoat, brocade, brocade-nos, nortel, hpux, datadomain | standard |
| --(no)duplex | Add the duplex mode property for each interface in the interface table. | _disabled_ |
| --(no)stp | Add the stp state property for each interface in the interface table. <br>BE AWARE that it based on the dot1base mib, which is incomplete in specific cases: <br>\* Cisco device using pvst / multiple vlan stp | _disabled_ |
| --(no)vlan | Add the vlan attribution property for each interface in the interface table. This option is available only for the following nodetypes: cisco, hp, nortel | _disabled_ |
| --(no)ipinfo | Add the ip information for each interface in the interface table. | _enabled_ |
| --(no)alias | Add the alias information for each interface in the interface table. | _disabled_ |
| --accessmethod | Allow you to generate links in the HTML page to access your device. Access method for the link to the host in the HTML page. <br>Format: method\[:link\]\[,method\[:link\]\] <br>\* Method can be: ssh, telnet, http or https <br>\* Link is by default the hostaddress, but can be an http address for example. <br>Example: <br>\--accessmethod telnet,http:http://$HOSTADDRESS$/na\_admin <br>will produce 2 links: <br>1\. a telnet link (default is to $HOSTADDRESS$) <br>2\. a http link to [http://$HOSTADDRESS$/na\_admin](http://$HOSTADDRESS$/na_admin) <br>Note: <br>"," is the multiple link definition separator (same as some other options) <br>":" separate the method and the custom link (custom link can include the : character) | none |
| --htmltabledir | Specifies the directory in the file system where HTML interface table are stored. | _Installation related_ |
| --htmltableurl | Specifies the URL by which the interface table are accessible. | _Installation related_ |
| --htmltablelinktarget | Specifies the windows or the frame where the \[details\] link will load the generated html page. <br>Possible values are: \_blank, \_self, \_parent, \_top, or a frame name. <br>For exemple, exemple, can be set to \_blank to open the details view in a new window. | \_self |
| --delta, -d | Set the delta used for interface throuput calculation. In seconds. | 600 |
| --ifs | Input field separator. The specified separator is used for all options allowing a list to be specified. | , |
| --cache | Define the retention time of the cached data. In seconds. | 3600 |
| --reseturl | Specifies the URL to the tablereset program. | _Installation related_ |
| --(no)ifloadgradient | Enable color gradient from green over yellow to red for the load percentage representation. | _enabled_ |
| --(no)human | Translate bandwidth usage in human readable format (G/M/K bps). | _enabled_ |
| --(no)snapshot | Force the plugin to run like if it was the first launch. Cached data will be ignored. | _disabled_ |
| --timeout, -t | Define the timeout limit of the plugin. | 15 |
| --css | Define the css stylesheet used by the generated html files. Can be: <br>\* classical <br>\* icinga <br>\* nagiosxi <br>\* icinga-alternate1 | icinga |
| --config | Specify a config file to load. |  |
| --(no)configtable | Enable/disable configuration table on the generated HTML page. <br>Also, if enabled, the globally excluded interfaces are not shown in the interface table anymore (interesting in case of lots of excluded interfaces) | _enabled_ |
| --default-table-sorting | Default table sorting, can be 'index' or 'name'. | index |
| --table-split | Generate multiple interface tables, one per interface type. | _disabled_ |
| --(no)type  | Interface type for each interface. | _disabled_ |

Notes:

*   Generally, it is better to use the following option (and particulary in case the hostnames are different from the host address): -h $HOSTNAME$  
    That will permit to the script to generate a correct link to the pnp4nagios graphs.
*   For options --exclude, --include, --exclude-traffic, --include-traffic, --track-property, --exclude-property and --include-property:
    *   These options can be used multiple times, the lists of interfaces/properties will be concatenated.
    *   The separator can be changed using the --ifs option.
*   All these default values can be easily changed to fit your environment, by changing the definition of the '%ghOptions' hash in the script itself.

## Examples

### Generalities

*   Print plugin usage

Lots of changes has been done on the plugin. The plugin usage has consequently changed. Look at the help for a complete explanation of each option:

```
# su - nagios
nagios$ cd /usr/local/nagios/libexec
nagios$ ./check_interface_table_v3t.pl --help
```

*   Print the default option values

```
snoopy:/usr/local/nagios/libexec# ./check_interface_table_v3t.pl -D

Default option values:
----------------------

General options:

$VAR1 = {
          'accessmethod' => undef,
          'alias-matching' => 0,
          'cache' => 3600,
          'cachedir' => '/tmp/.ifCache',
          'config' => '',
          'configtable' => 1,
          'critical-property' => 0,
          'critical-traffic' => '101,5000,5000',
          'css' => 'icinga',
          'delta' => 600,
          'duplex' => 0,
          'enableperfdata' => 0,
          'exclude' => undef,
          'exclude-property' => undef,
          'exclude-traffic' => undef,
          'grapher' => 'pnp4nagios',
          'grapherurl' => '/pnp4nagios',
          'help' => 0,
          'hostdisplay' => '',
          'hostquery' => '',
          'htmltabledir' => '/Monitoring/icinga-addons/interfacetable_v3t/share/tables',
          'htmltableurl' => 'http://snoopy/interfacetable_v3t/tables',
          'human' => 1,
          'ifdetails' => 0,
          'ifloadgradient' => 1,
          'ifs' => ',',
          'include' => undef,
          'include-property' => undef,
          'include-traffic' => undef,
          'nodetype' => 'standard',
          'outputshort' => 0,
          'perfdatadir' => undef,
          'perfdataformat' => 'full',
          'portperfunit' => 'bit',
          'regexp' => 0,
          'reseturl' => '/interfacetable_v3t/cgi-bin',
          'showdefaults' => 0,
          'snapshot' => 0,
          'statedir' => '/tmp/.ifState',
          'stp' => 0,
          'timeout' => 15,
          'track-property' => [
                                'ifOperStatus'
                              ],
          'usemacaddr' => 0,
          'verbose' => 0,
          'vlan' => 0,
          'warning-property' => 0,
          'warning-traffic' => '101,1000,1000'
        };

Snmp options:

$VAR1 = {
          '64bits' => 0,
          'authproto' => 'md5',
          'community' => 'public',
          'domain' => 'udp',
          'login' => '',
          'max-repetitions' => undef,
          'passwd' => '',
          'port' => 161,
          'privpass' => '',
          'privproto' => 'des',
          'retries' => 2,
          'timeout' => 2,
          'unixsnmp' => 0,
          'version' => '1'
        };
```

### Basis

* Simple local test using default option values

```
nagios$ ./check_interface_table_v3t.pl -H localhost -2 -C public
Initial run... <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|
nagios$
```

Wait a couple of seconds...

```
nagios$ ./check_interface_table_v3t.pl -H localhost -2 -C public
1 interface(s), 0 free <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|
nagios$
```
* With performance data

```
nagios$ ./check_interface_table_v3t.pl -H localhost -2 -C public -f
1 interface(s), 0 free, 4 graphed <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|Interface_global::check_interface_table_global::time=1s;;;; uptime=1296910s;;;; watched=4;;;; useddelta=248s;;;; ports=1;;;; freeports=0;;;; adminupfree=0;;;;  If_lo::check_interface_table_port_bit::OperStatus=1;;;0; BitsIn=169424c;;;0; BitsOut=169424c;;;0; PktsInErr=0c;;;0; PktsOutErr=0c;;;0; PktsInDiscard=0c;;;0; PktsOutDiscard=0c;;;0;  If_eth0::check_interface_table_port_bit::OperStatus=1;;;0; BitsIn=110180152c;;;0; BitsOut=8776488c;;;0; PktsInErr=0c;;;0; PktsOutErr=0c;;;0; PktsInDiscard=0c;;;0; PktsOutDiscard=0c;;;0;  If_vboxnet0::check_interface_table_port_bit::OperStatus=2;;;0; BitsIn=0c;;;0; BitsOut=0c;;;0; PktsInErr=0c;;;0; PktsOutErr=0c;;;0; PktsInDiscard=0c;;;0; PktsOutDiscard=0c;;;0;  If_pan0::check_interface_table_port_bit::OperStatus=2;;;0; BitsIn=0c;;;0; BitsOut=0c;;;0; PktsInErr=0c;;;0; PktsOutErr=0c;;;0; PktsInDiscard=0c;;;0; PktsOutDiscard=0c;;;0;
nagios$
```

* Look at generated html pages

Open your browser and test the access to the generated interface page: [http://myserver/interfacetable\_v3t/tables/localhost-Interfacetable.html](http://myserver/interfacetable_v3t/tables/localhost-Interfacetable.html)

An index page is available, to switch easily between interface tables: [http://myserver/interfacetable\_v3t/tables/index.php](http://myserver/interfacetable_v3t/tables/index.php)

### Common

* Simple check using default option values

```
icinga$ ./check_interface_table_v3t.pl -H localhost -C public
1 interface(s), 1 free, 1 AdminUp and free <a href="/interfacetable_v3t_testing/tables/localhost-Interfacetable.html">[details]</a>|
icinga$
```

* Selecting some interfaces for the property checks

Target: localhost SNMP version: 2c SNMP community: public Excluded interfaces: lo Only include following interfaces in property tracking: eth0, eth6 and eth7 Activate performance data

```
icinga$ ./check\_interface\_table\_v3t.pl -H localhost -C public -2 -f --exclude lo --exclude-property ALL --include-property eth0,eth5,eth6
```

* Define traffic thresholes

Target: localhost SNMP version: 2c SNMP community: public Excluded interfaces (regexp): lo, vbox\*, pan\* Traffic warning thresholds: 50% bandwidth usage, 10pkts/s erroneous/discared Traffic critical thresholds: 80% bandwidth usage, 100pkts/s erroneous/discared No interface property changes will be tracked Performance data activated

```
icinga@snoopy:/usr/local/nagios/libexec$ ./check_interface_table_v3t.pl -H localhost -C public -2 -r --exclude lo,vbox*,pan* --warning 50,10,10 --critical 80,100,100 -f --track-property ''
1 interface(s), 0 free, 1 graphed <a href="/interfacetable_v3t_testing/tables/localhost-Interfacetable.html">[details]</a>|Interface_global::check_interface_table_global::time=1s;;;; uptime=1461028s;;;; watched=1;;;; useddelta=712s;;;; ports=1;;;; freeports=0;;;; adminupfree=0;;;;  If_eth0::check_interface_table_port_bit::OperStatus=1;;;0; BitsIn=62358712c;;;0; BitsOut=4500696c;;;0; PktsInErr=0c;;;0; PktsOutErr=0c;;;0; PktsInDiscard=0c;;;0; PktsOutDiscard=0c;;;0;
icinga@snoopy:/usr/local/nagios/libexec$
```

* 64 bits counters (support of >= 10Gbps interfaces)

Target: localhost SNMP version: 2c SNMP community: public Included interfaces: eth7 only Operstatus interface property changes will be tracked (default) 64bits counters activated Performance data activated

```
[icinga@agrid libexec]$ ./check_interface_table_v3t.pl -H localhost -2 -C public --64bits --exclude ALL --include eth7 -f
1 interface(s), 0 free, 1 graphed, 1 critical load(s) (>101%): eth7 <a href="/interfacetable_v3t_testing/tables/localhost-Interfacetable.html">[details]</a>|Interface_global::check_interface_table_global::time=1s;;;; uptime=144779s;;;; watched=1;;;; useddelta=217s;;;; ports=1;;;; freeports=0;;;; adminupfree=0;;;;  If_eth7::check_interface_table_port_bit::OperStatus=1;;;0; BitsIn=10638480367760c;;;0; BitsOut=16818905928968c;;;0; PktsInErr=0c;;;0; PktsOutErr=0c;;;0; PktsInDiscard=0c;;;0; PktsOutDiscard=0c;;;0;
[icinga@agrid libexec]$
```

Note: in case you already used the plugin without the --64bits option, the load calculation will be wrong for a short period (as in the previous exemple). Indeed, non 64 bits oids are still in cache.

### Different snmp versions

* Snmp **v1** (as default)

```
[icinga@myserver libexec]$ ./check_interface_table_v3t.pl -H localhost
6 interface(s), 5 free <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|[icinga@myserver libexec]$
[icinga@myserver libexec]$
```

* Snmp **v2c**

```
[icinga@myserver libexec]$ ./check_interface_table_v3t.pl -H localhost -l user2 -x user2password -L md5
6 interface(s), 5 free, 1 change(s): ifOperStatus - eth4 <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|
[icinga@myserver libexec]$
```

* Snmp **v3**

    * securityLevel authNoPriv (authorisation is required but collected data sent over the network is not encrypted)

    ```
    [icinga@myserver libexec]$ ./check_interface_table_v3t.pl -H localhost -l user3 -x user3password -L md5
    6 interface(s), 5 free, 1 change(s): ifOperStatus - eth4 <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|
    [icinga@myserver libexec]$
    ```

    * securityLevel authPriv (authorisation is required and everthing sent over the network is encrypted)

    ```
    [icinga@myserver libexec]$ ./check_interface_table_v3t.pl -H localhost -l user3 -x user3password -X user3encryption -L md5,des
    6 interface(s), 5 free, 1 change(s): ifOperStatus - eth4 <a href="/interfacetable_v3t/tables/localhost-Interfacetable.html">[details]</a>|
    [icinga@myserver libexec]$
    ```

    Note: as non-secure, the securityLevel noAuthNoPriv is not supported
