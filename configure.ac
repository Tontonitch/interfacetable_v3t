### -*- Autoconf -*-
### Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT(interfacetable_v3t, 0.03, tontonitch-pro@yahoo.fr)

### For later filesystem permissions
AC_DEFINE([DEFAULT_USER], [nagios], [Default User])
AC_DEFINE([DEFAULT_GROUP], [nagios], [Default Group])
AC_SUBST(DEFAULT_USER)
AC_SUBST(DEFAULT_GROUP)
AC_PREFIX_DEFAULT(/usr/local/interfacetable_v3t)
# $prefix variable initialisation seems to be tricky
if test "$prefix" = "NONE"; then
   prefix=$ac_default_prefix
fi

### What OS are we running
AC_CANONICAL_HOST

### Some information about the project
PKG_NAME=interfacetable_v3t
PKG_VERSION="0.03"
PKG_HOME_URL="http://www.tontonitch.com"
PKG_REL_DATE="XX-XX-2011"
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
	AC_MSG_WARN([snmpget is required! Get it from http://net-snmp.sourceforge.net])
fi
AC_PATH_PROG(SNMPWALK,snmpwalk)
if test -n "$SNMPWALK"
then
	AC_DEFINE_UNQUOTED(SNMPWALK,"$SNMPWALK",[path to snmpwalk binary])
else
	AC_MSG_WARN([snmpwalk is required! Get it from http://net-snmp.sourceforge.net])
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
if ( $PERL -M"Net::SNMP" -e 'exit' 2>/dev/null  )
AC_MSG_CHECKING(for Net::SNMP perl module)
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Net::SNMP perl module!])
fi

dnl Checking Config::General
if ( $PERL -M"Config::General" -e 'exit' 2>/dev/null  )
AC_MSG_CHECKING(for Config::General perl module)
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Config::General perl module!])
fi

dnl Checking Data::Dumper
if ( $PERL -M"Data::Dumper" -e 'exit' 2>/dev/null  )
AC_MSG_CHECKING(for Data::Dumper perl module)
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Data::Dumper perl module!])
fi

dnl Checking Getopt::Std
if ( $PERL -M"Getopt::Std" -e 'exit' 2>/dev/null  )
AC_MSG_CHECKING(for Getopt::Std perl module)
then
	AC_MSG_RESULT([found])
else
	AC_MSG_WARN([not found - install Getopt::Std perl module!])
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
AC_ARG_WITH(cachedir,     [  --with-cachedir=/path/to/cache/dir             Sets the directory where snmp responses are cached],cachedir=$withval,cachedir=/tmp/.ifCache)
AC_ARG_WITH(statedir,     [  --with-statedir=/path/to/cache/dir             Sets the directory where the interface states are stored],statedir=$withval,statedir=/tmp/.ifState)
AC_ARG_WITH(htmldir,      [  --with-htmldir=/path/to/html/dir               Sets software HTML directory],htmldir=$withval,htmldir=${prefix}/share)
AC_ARG_WITH(htmlurl,      [  --with-htmlurl=<local-url>                     Sets interface table URL location],htmlurl=$withval,htmlurl=/interfacetable_v3t)
AC_ARG_WITH(cgidir,       [  --with-cgidir=/path/to/cgi/dir                 Sets software cgi programs directory],cgidir=$withval,cgidir=${prefix}/sbin)
AC_ARG_WITH(cgiurl,       [  --with-cgiurl=<local-url>                      Sets URL for interfacetable_v3t cgi programs],cgiurl=$withval,cgiurl=/interfacetable_v3t/cgi-bin)
AC_ARG_WITH(grapher,      [  --with-grapher=<solution name>                 Sets the graphing solution which will be in charge of processing the performance data],grapher=$withval,grapher=pnp4nagios)
AC_ARG_WITH(grapher_url,  [  --with-grapher-url=<grapher-url>               Sets URL to the graphing solution web interface],grapher_url=$withval,grapher_url=none)
AC_ARG_ENABLE(testing,    [  --enable-testing                               Testing mode. All files and directories will be installed in <prefix>])

dnl Testing mode
if test x$enable_testing = xyes; then
  nagios_base=${prefix}/nagios/sbin
  nagios_libexec=${prefix}/nagios/libexec
  cachedir=${prefix}/tmp/.ifCache
  statedir=${prefix}/tmp/.ifState
  htmldir=${prefix}/share
  htmlurl=/interfacetable_v3t_testing
  cgidir=${prefix}/sbin
  cgiurl=/interfacetable_v3t_testing/cgi-bin
fi
AC_SUBST(nagios_base)
AC_SUBST(nagios_libexec)
AC_SUBST(cachedir)
AC_SUBST(statedir)
AC_SUBST(htmldir)
AC_SUBST(htmlurl)
AC_SUBST(cgidir)
AC_SUBST(cgiurl)
AC_SUBST(grapher)
AC_SUBST(testing)

dnl In case not specified, adapt the grapher url depending on the selected grapher
if test x$grapher_url = xnone; then
	if test x$grapher = xpnp4nagios; then
		grapher_url="/pnp4nagios"
	elif test x$grapher = xnagiosgrapher; then
		grapher_url="/nagios/cgi-bin"
	elif test x$grapher = xnetwaysgrapherv2; then
		grapher_url="/nagios/cgi-bin"
	fi
fi
AC_SUBST(grapher_url)

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
$PERL subst etc/settings.cfg
$PERL subst etc/interfacetable_v3t.conf.httpd

dnl Review options
echo ""
echo ""
AC_MSG_RESULT([*** Configuration summary for $PKG_NAME $PKG_VERSION $PKG_REL_DATE ***:])

echo ""
echo " General Options:"
echo " -------------------------"

if test x$enable_testing = xyes; then
  echo ""
  echo "                               --- TESTING MODE ENABLED ---"
  echo ""
fi

AC_MSG_RESULT([                  Install user/group:  $nagios_user,$nagios_grp])
AC_MSG_RESULT([                   Install \${prefix}:  ${prefix}])
AC_MSG_RESULT([              Install \${exec_prefix}:  $exec_prefix])
AC_MSG_RESULT([                     Nagios base dir:  $nagios_base])
AC_MSG_RESULT([                  Nagios libexec dir:  $nagios_libexec])
AC_MSG_RESULT([                     Cache files dir:  $cachedir])
AC_MSG_RESULT([                     State files dir:  $statedir])
AC_MSG_RESULT([   InterfaceTable_v3t addon HTML dir:  $htmldir])
AC_MSG_RESULT([   InterfaceTable_v3t addon HTML url:  $htmlurl])
AC_MSG_RESULT([    InterfaceTable_v3t addon CGI dir:  $cgidir])
AC_MSG_RESULT([    InterfaceTable_v3t addon CGI url:  $cgiurl])
AC_MSG_RESULT([                   Apache conf.d Dir:  $httpd_conf])
AC_MSG_RESULT([                         Apache User:  $apache_user])
AC_MSG_RESULT([                     Apache AuthName:  $apache_authname])
AC_MSG_RESULT([                        Sudoers file:  $sudoers])

echo ""
echo " Graphing Options:"
echo " -------------------------"

AC_MSG_RESULT([              Graphing solution name:  $grapher])
AC_MSG_RESULT([               Graphing solution url:  $grapher_url])

echo ""
echo ""
echo "Review the options above for accuracy.  If they look okay,"
echo "type 'make install' to install the software."
echo "type 'make fullinstall' to install the software and environment configs (apache, sudo)."
echo ""
