### -*- Autoconf -*-
### Process this file with autoconf to produce a configure script.

AC_PREREQ(2.60)
AC_INIT(interfacetable_v3t, 0.05-1, tontonitch-pro@yahoo.fr)

### For later filesystem permissions
AC_DEFINE([DEFAULT_USER], [nagios], [Default User])
AC_DEFINE([DEFAULT_GROUP], [nagios], [Default Group])
AC_SUBST(DEFAULT_USER)
AC_SUBST(DEFAULT_GROUP)
AC_PREFIX_DEFAULT(/usr/local/interfacetable_v3t)
# $prefix variable initialisation seems to be tricky
if test "x$prefix" = "xNONE" ; then
    prefix=$ac_default_prefix
fi
if test "x$exec_prefix" = "xNONE" ; then
    exec_prefix=$prefix
fi

### What OS are we running
AC_CANONICAL_HOST

### Some information about the project
PKG_NAME=interfacetable_v3t
PKG_VERSION="0.05-1"
PKG_HOME_URL="http://www.tontonitch.com"
PKG_REL_DATE="27-12-2013"
AC_SUBST(PKG_NAME)
AC_SUBST(PKG_VERSION)
AC_SUBST(PKG_HOME_URL)
AC_SUBST(PKG_REL_DATE)

### Checks for programs.
AC_PROG_MAKE_SET # @SET_MAKE@ needed in each Makefile.in
AC_PATH_PROG([STRIP],[strip],[true])
AC_PATH_PROG(CP,cp)
AC_PATH_PROG(TOUCH,touch)
AC_PATH_PROG(GREP,grep)
AC_PATH_PROG(PERL,perl)
AC_PATH_PROG(SNMPGET,snmpget)
if test -n "$SNMPGET"
then
	AC_DEFINE_UNQUOTED(SNMPGET,"$SNMPGET",[path to snmpget binary])
else
	AC_MSG_WARN([snmpget is required if you want to use the snmp binaries instead of the Perl bindings (--unixsnmp). Get it from http://net-snmp.sourceforge.net])
fi
AC_PATH_PROG(SNMPWALK,snmpwalk)
if test -n "$SNMPWALK"
then
	AC_DEFINE_UNQUOTED(SNMPWALK,"$SNMPWALK",[path to snmpwalk binary])
else
	AC_MSG_WARN([snmpwalk is required if you want to use the snmp binaries instead of the Perl bindings (--unixsnmp). Get it from http://net-snmp.sourceforge.net])
fi
AC_PATH_PROG(SUDO,sudo)
if test -n "$SUDO"
then
	AC_DEFINE_UNQUOTED(SUDO,"$SUDO",[path to sudo binary])
else
	AC_MSG_WARN([sudo is required! Get it from http://net-snmp.sourceforge.net])
fi

dnl Figure out how to invoke "install" and what install options to use.
AC_PROG_INSTALL # set INSTALL_PROGRAM and INSTALL_SCRIPT to ‘${INSTALL}’ and INSTALL_DATA to ‘${INSTALL} -m 644’
AC_SUBST(INSTALL)

### Checks for libraries.
dnl Checking Net::SNMP
AC_MSG_CHECKING(for Net::SNMP perl module)
if ( $PERL -M"Net::SNMP" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Net::SNMP perl module or use the Netsnmp binaries])
fi

dnl Checking Config::General
AC_MSG_CHECKING(for Config::General perl module)
if ( $PERL -M"Config::General" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Config::General perl module!])
fi

dnl Checking Data::Dumper
AC_MSG_CHECKING(for Data::Dumper perl module)
if ( $PERL -M"Data::Dumper" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Data::Dumper perl module!])
fi

dnl Checking Getopt::Std
AC_MSG_CHECKING(for Getopt::Std perl module)
if ( $PERL -M"Getopt::Std" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Getopt::Std perl module!])
fi

dnl Checking CGI
AC_MSG_CHECKING(for CGI perl module)
if ( $PERL -M"CGI" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install CGI module!])
fi

dnl Checking Storable
AC_MSG_CHECKING(for Storable perl module)
if ( $PERL -M"Storable" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Storable module!])
fi

dnl Checking Sort::Naturally
AC_MSG_CHECKING(for Sort::Naturally perl module)
if ( $PERL -M"Sort::Naturally" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Sort::Naturally module!])
fi

dnl Checking Exception::Class
AC_MSG_CHECKING(for Exception::Class perl module)
if ( $PERL -M"Exception::Class" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Exception::Class module!])
fi

dnl Checking Time::HiRes
AC_MSG_CHECKING(for Time::HiRes perl module)
if ( $PERL -M"Time::HiRes" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Time::HiRes perl module!])
fi

dnl Checking Encode
AC_MSG_CHECKING(for Encode perl module)
if ( $PERL -M"Encode" -e 'exit' 2>/dev/null  )
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Encode perl module!])
fi

### Checks for header files.

### Checks for typedefs, structures, and compiler characteristics.

### Checks for library functions.

### Checks for file permissions 

dnl Installation user/group
AC_ARG_WITH(nagios_user,[  --with-nagios-user=<user>                      Sets the owner of installed files],nagios_user=$withval,nagios_user=nagios)
AC_ARG_WITH(nagios_group,[  --with-nagios-group=<grp>                      Sets group of installed files],nagios_grp=$withval,nagios_grp=nagios)
AC_SUBST(nagios_user)
AC_SUBST(nagios_grp)
AC_DEFINE_UNQUOTED(DEFAULT_USER,"$nagios_user")
AC_DEFINE_UNQUOTED(DEFAULT_GROUP,"$nagios_grp")
INSTALL_OPTS="-o $nagios_user -g $nagios_grp"
AC_SUBST(INSTALL_OPTS)

dnl Installation options
AC_ARG_WITH(nagios_base,   [  --with-nagios-base=/path/to/nagios/dir         Sets the nagios base directory],nagios_base=$withval,nagios_base=/usr/local/nagios)
AC_ARG_WITH(nagios_libexec,[  --with-nagios-libexec=/path/to/nagios/dir      Sets the nagios libexec directory, if not standard],nagios_libexec=$withval,nagios_libexec=${nagios_base}/libexec)
AC_ARG_WITH(nagios_etc,   [  --with-nagios-etc=/path/to/nagios/dir          Sets the nagios etc directory, if not standard],nagios_etc=$withval,nagios_etc=${nagios_base}/etc)
AC_ARG_WITH(cachedir,     [  --with-cachedir=/path/to/cache/dir             Sets the directory where snmp responses are cached],cachedir=$withval,cachedir=/tmp/.ifCache)
AC_ARG_WITH(statedir,     [  --with-statedir=/path/to/cache/dir             Sets the directory where the interface states are stored],statedir=$withval,statedir=/tmp/.ifState)
AC_ARG_WITH(htmlurl,      [  --with-htmlurl=<local-url>                     Sets interface table URL location],htmlurl=$withval,htmlurl=/interfacetable_v3t)
AC_ARG_WITH(cgidir,       [  --with-cgidir=/path/to/cgi/dir                 Sets software cgi programs directory],cgidir=$withval,cgidir=${prefix}/sbin)
AC_ARG_WITH(cgiurl,       [  --with-cgiurl=<local-url>                      Sets URL for interfacetable_v3t cgi programs],cgiurl=$withval,cgiurl=/interfacetable_v3t/cgi-bin)
AC_ARG_WITH(grapher,      [  --with-grapher=<solution name>                 Sets the graphing solution which will be in charge of processing the performance data. Possible values are pnp4nagios, nagiosgrapher, netwaysgrapherv2, ingraph],grapher=$withval,grapher=pnp4nagios)
AC_ARG_WITH(grapher_url,  [  --with-grapher-url=<grapher-url>               Sets URL to the graphing solution web interface],grapher_url=$withval,grapher_url=none)
AC_ARG_WITH(max_plugin_output_length, [  --with-max-plugin-output-length=<length>       Sets the maximum plugin output length as used during the nagios/icinga core compilation. Default is 8192. If you used a different value, specify it here so the plugin would correctly detect the oversized plugin outputs.],max_plugin_output_length=$withval,max_plugin_output_length=8192)
AC_ARG_WITH(portperfunit, [  --with-portperfunit=<unit>                     Sets the unit used to report traffic statistics. could be reported in bits (counters) or in bps (calculated value, new and default since v0.05). Can be 'bit' or 'bps'.],portperfunit=$withval,portperfunit=bps)
AC_ARG_ENABLE(testing,    [  --enable-testing                               Testing mode. All files and directories will be installed in <prefix>])

dnl Testing mode
if test x$enable_testing = xyes; then
  nagios_base=${prefix}/nagios
  nagios_libexec=${nagios_base}/libexec
  cgidir=${nagios_base}/sbin
  cgiurl=/interfacetable_v3t_testing/cgi-bin
  htmlurl=/interfacetable_v3t_testing
  cachedir=${prefix}/tmp/.ifCache
  statedir=${prefix}/tmp/.ifState
fi
AC_SUBST(nagios_base)
AC_SUBST(nagios_libexec)
AC_SUBST(nagios_etc)
AC_SUBST(cachedir)
AC_SUBST(statedir)
AC_SUBST(htmlurl)
AC_SUBST(cgidir)
AC_SUBST(cgiurl)
AC_SUBST(grapher)
AC_SUBST(testing)
AC_SUBST(max_plugin_output_length)

dnl In case not specified, adapt the grapher url depending on the selected grapher
if test x$grapher_url = xnone; then
	if test x$grapher = xpnp4nagios; then
		grapher_url="/pnp4nagios"
	elif test x$grapher = xnagiosgrapher; then
		grapher_url="/nagios/cgi-bin"
	elif test x$grapher = xnetwaysgrapherv2; then
		grapher_url="/nagios/cgi-bin"
	elif test x$grapher = xingraph; then
		grapher_url="/ingraph"
	fi
fi
AC_SUBST(grapher_url)

dnl Check the validity of the portperfunit variable
if test x$portperfunit != xbit; then
	if test x$portperfunit != xbps; then
		portperfunit="bps"
	fi
fi
AC_SUBST(portperfunit)

dnl Check for location of Apache conf.d directory
HTTP_CONF=no
AC_ARG_WITH(httpd_conf,[  --with-httpd-conf=<path_to_conf>               Sets path to Apache conf.d directory],httpd_conf=$withval,httpd_conf=no)
if test x$httpd_conf = xno; then
	if test -d /etc/httpd/conf.d; then
		httpd_conf="/etc/httpd/conf.d"
	elif test -d /etc/apache2/conf.d; then
		httpd_conf="/etc/apache2/conf.d"
	elif test -d /etc/apache/conf.d; then
		httpd_conf="/etc/apache/conf.d"
	else
		httpd_conf="$sysconfdir/apache-conf.d/"
	fi
fi
if test x$enable_testing = xyes; then
    httpd_conf="${prefix}/httpd/conf.d"
fi
AC_SUBST(httpd_conf)

dnl Check for Apache user
apache_user=no
AC_ARG_WITH(apache_user,[  --with-apache-user=<user>                      Sets path Apache runs with],apache_user=$withval,apache_user=no)
if test x$apache_user = xno; then
if grep -e "^apache:" /etc/passwd >/dev/null ; then
	# RedHat, Fedora, CentOS
	apache_user="apache"
elif grep -e "^www-data:" /etc/passwd >/dev/null ; then
	# Debian, Ubuntu, derivates of them
	apache_user="www-data"
elif grep -e "^wwwrun:" /etc/passwd >/dev/null ; then
	# SuSE
	apache_user="wwwrun"
else
	apache_user="root"
fi
fi
AC_SUBST(apache_user)

dnl AuthName directive in apache config
apache_authname="Nagios Access"
AC_ARG_WITH(apache_authname,[  --with-apache-authname=<authname>              Sets value of AuthName directive in Apache config],apache_authname=$withval,apache_authname="Nagios Access")
if test $(echo $nagios_base | grep -i icinga | wc -l) -gt 0 -a "x$apache_authname" = "xNagios Access"; then
	apache_authname="Icinga Access"
fi
AC_SUBST(apache_authname)

dnl Check for location of sudoers file
sudoers=no
AC_ARG_WITH(sudoers,[  --with-sudoers=<path_to_sudoers>               Sets path to sudoers file],sudoers=$withval,sudoers=no)
if test x$sudoers = xno; then
if test -e /etc/sudoers; then
	# Redhat, Debian, Ubuntu, derivates of them
	sudoers="/etc/sudoers"
elif test -e /opt/sfw/etc/sudoers; then
	# Solaris
	sudoers="/opt/sfw/etc/sudoers"
fi
fi
AC_SUBST(sudoers)

AC_CONFIG_FILES(
	subst
	Makefile 
	sbin/Makefile
	etc/Makefile 
	lib/Makefile 
	libexec/Makefile
	share/Makefile)

AC_OUTPUT

$PERL subst sbin/InterfaceTableReset_v3t.cgi
$PERL subst lib/Settings.pm
$PERL subst lib/GeneralUtils.pm
$PERL subst lib/SnmpUtils.pm
$PERL subst libexec/check_interface_table_v3t.pl
$PERL subst etc/settings.cfg-sample
$PERL subst etc/interfacetable_v3t.conf.httpd
$PERL subst contrib/test/test_snmp.pl

dnl Review options
echo ""
echo ""
AC_MSG_RESULT([*** Configuration summary for $PKG_NAME $PKG_VERSION $PKG_REL_DATE ***:])

if test x$enable_testing = xyes; then
  echo ""
  echo "                               --- TESTING MODE ENABLED ---"
  echo " Note: due to the testing mode, you will need to"
  echo "    * copy the generated interfacetable_v3t.conf httpd config file from the testing apache conf.d dir"
  echo "      to the httpd configuration directory on the system, renamed as you want"
  echo ""
fi

echo ""
echo " Global installation directories:"
echo " --------------------------------"
AC_MSG_RESULT([                           \${prefix}:  ${prefix}])
AC_MSG_RESULT([                      \${exec_prefix}:  $exec_prefix])
AC_MSG_RESULT([         libdir (for perl libraries):  ${libdir}])
AC_MSG_RESULT([        sysconfdir (for config file):  ${sysconfdir}])
AC_MSG_RESULT([ datarootdir (for html, css, js,...):  ${datarootdir}])
AC_MSG_RESULT([ Note: exec_prefix, libdir, sysconfdir and datadir can be changed for fine tuned installations])

echo ""
echo " Nagios & related options:"
echo " -------------------------"
AC_MSG_RESULT([                  Install user/group:  $nagios_user,$nagios_grp])
AC_MSG_RESULT([                     Nagios base dir:  $nagios_base])
AC_MSG_RESULT([                  Nagios libexec dir:  $nagios_libexec])
AC_MSG_RESULT([                      Nagios etc dir:  $nagios_etc])
AC_MSG_RESULT([    InterfaceTable_v3t addon CGI dir:  $cgidir])
AC_MSG_RESULT([    InterfaceTable_v3t addon CGI url:  $cgiurl])
AC_MSG_RESULT([   InterfaceTable_v3t addon HTML url:  $htmlurl])
AC_MSG_RESULT([                     Cache files dir:  $cachedir])
AC_MSG_RESULT([                     State files dir:  $statedir])

echo ""
echo " Graphing options:"
echo " -----------------"
AC_MSG_RESULT([              Graphing solution name:  $grapher])
AC_MSG_RESULT([               Graphing solution url:  $grapher_url])

echo ""
echo " Apache & sudo options:"
echo " ----------------------"
AC_MSG_RESULT([                   Apache conf.d dir:  $httpd_conf])
AC_MSG_RESULT([                         Apache User:  $apache_user])
AC_MSG_RESULT([                     Apache AuthName:  $apache_authname])
AC_MSG_RESULT([                        Sudoers file:  $sudoers])

echo ""
echo " Other options:"
echo " ----------------------"
AC_MSG_RESULT([          Port performance data unit:  $portperfunit])
AC_MSG_RESULT([            MAX_PLUGIN_OUTPUT_LENGTH:  $max_plugin_output_length])
echo ""
echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! WARNING - PLEASE READ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo " !! Interfacetable_v3t release 0.05 introduces some important changes in the way traffic      !!"
echo " !! statistics are calculated and reported.                                                   !!"
echo " !! In previous versions, the statistics were collected from counters and were written as     !!"
echo " !! counters in the performance data. The graphing solution, in charge of processing the      !!"
echo " !! performance data, had to insertcounters in the rrd files. During this rrd update, the     !!"
echo " !! traffic rate (in bits/octets per second) was calculated. With this method, there is no    !!"
echo " !! way to avoid abnormal statistics to be inserted in the rrd files.                         !!"
echo " !! In this new 0.05 release, the statistics are still collected from counters, but the rates !!"
echo " !! (usually bps) are calculated and transmitted to performance data (no more as counters).   !!"
echo " !! The graphing solution, in charge of processing the performance data, have to insert bps   !!"
echo " !! values in the rrd files. With this method, abnormal statistics are not transmitted to the !!"
echo " !! graphing solution, leaving the rrd files only with consistent statistics.                 !!"
echo " !! This new method is now default one in this new release of the plugin. The old method is   !!"
echo " !! still available but should be removed in future versions of the plugin.                   !!"
echo " !!                                                                                           !!"
echo " !! Important notes:                                                                          !!"
echo " !!  * if you are proceeding to a new installation of the interfacetable_v3t plugin,          !!"
echo " !!    everything should be okay, the new default method will be used.                        !!"
echo " !!  * if you are upgrading an existing installation of the interfacetable_v3t plugin:        !!"
echo " !!    - by default, the new method will be used.                                             !!"
echo " !!      YOU WILL NEED TO CONVERT THE EXISTING RRD FILES! See the upgrade procedure at        !!"
echo " !!      http://www.tontonitch.com/tiki/tiki-index.php?page=Nagios+plugins+-+interfacetable_v !!"
echo " !!      3t+-+documentation+-+0.05+-+Upgrade&structure=Nagios+plugins+-+interfacetable_v3t+-+ !!"
echo " !!      documentation+-+0.05                                                                 !!"
echo " !!    - or you can still use the old method                                                  !!"
echo " !!       a) during the installation by using the configure option --with-portperfunit=bit    !!"
echo " !!       b) or when running the plugin by using the plugin option --portperfunit=bit         !!"
echo " !!      Please KEEP IN MIND that switching from one method to another imply the conversion   !!"
echo " !!      of the rrd files as a prerequisite!!!                                                !!"
echo " !!      Please KEEP IN MIND that the old method returning counters as performance data will  !!"
echo " !!      be REMOVED from future releases                                                      !!"
echo " !!  * the option --portperfunit cannot take the value 'octet' anymore. This option has been  !!"
echo " !!    removed as not used, for better maintenance, and in the forcast of the unique unit     !!"
echo " !!    'bps' in future releases. If you use it, please contact me.                            !!"
echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! WARNING - PLEASE READ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo ""
echo ""
echo "Review the options above for accuracy. If they look okay,"
echo "type 'make install' to install the software."
echo "type 'make fullinstall' to install the software and environment configs (apache, sudo)."
echo ""
