### -*- Autoconf -*-
### Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(interfacetable_v3t, 0.03, tontonitch-pro@yahoo.fr)

dnl For later filesystem permissions
AC_DEFINE([DEFAULT_USER], [root], [Default User])
AC_DEFINE([DEFAULT_GROUP], [root], [Default Group])

AC_PREFIX_DEFAULT(/usr/local/interfacetable_v3t)

dnl Some information about the project
PKG_NAME=interfacetable_v3t
PKG_VERSION="0.03"
PKG_HOME_URL="http://www.tontonitch.com"
PKG_REL_DATE="XX-06-2011"

AC_SUBST(PKG_NAME)
AC_SUBST(PKG_VERSION)
AC_SUBST(PKG_HOME_URL)
AC_SUBST(PKG_REL_DATE)

### Checks for programs.
AC_PROG_MAKE_SET # @SET_MAKE@ needed in each Makefile.in
AC_PATH_PROG([STRIP],[strip],[true])
AC_PATH_PROG(CP,cp)
AC_PATH_PROG(TOUCH,touch)
AC_PATH_PROG(PERL,perl)

dnl Figure out how to invoke "install" and what install options to use.
AC_PROG_INSTALL # set INSTALL_PROGRAM and INSTALL_SCRIPT to ‘${INSTALL}’ and INSTALL_DATA to ‘${INSTALL} -m 644’
AC_SUBST(INSTALL)

### Checks for libraries.

### Checks for header files.

### Checks for typedefs, structures, and compiler characteristics.

### Checks for library functions.

### Checks for file permissions 

dnl Installation user/group
AC_ARG_WITH(nagios_user,[  --with-nagios-user=<user> sets the owner of installed files],nagios_user=$withval,nagios_user=nagios)
AC_ARG_WITH(nagios_group,[  --with-nagios-group=<grp> sets group of installed files],nagios_grp=$withval,nagios_grp=nagios)
AC_SUBST(nagios_user)
AC_SUBST(nagios_grp)
AC_DEFINE_UNQUOTED(DEFAULT_USER,"$nagios_user")
AC_DEFINE_UNQUOTED(DEFAULT_GROUP,"$nagios_grp")
INSTALL_OPTS="-o $nagiosbp_user -g $nagiosbp_grp"
AC_SUBST(INSTALL_OPTS)

dnl Installation options
AC_ARG_WITH(cgiurl,[  --with-cgiurl=<local-url> sets URL for cgi programs],cgiurl=$withval,cgiurl=/nagios/cgi-bin)
AC_ARG_WITH(htmurl,[  --with-htmurl=<local-url> sets URL for public html],htmurl=$withval,htmurl=/nagios)
AC_ARG_WITH(nagetc,[  --with-nagetc=/path/to/nagios/etc sets path to nagios etc directory],nagetc=$withval,nagetc=/usr/local/nagios/etc)
AC_ARG_WITH(naghtmurl,[  --with-naghtmurl=<local-url> sets URL for Nagios HTM URL],naghtmurl=$withval,naghtmurl=/nagios)
AC_ARG_WITH(nagcgiurl,[  --with-nagcgiurl=<local-url> sets URL for Nagios cgi programs],nagcgiurl=$withval,nagcgiurl=/nagios/cgi-bin)
AC_SUBST(htmurl)
AC_SUBST(cgiurl)
AC_SUBST(nagetc)
AC_SUBST(naghtmurl)
AC_SUBST(nagcgiurl)


dnl Check for location of Apache conf.d directory
HTTP_CONF=no
AC_ARG_WITH(httpd_conf,[  --with-httpd-conf=<path_to_conf> sets path to Apache conf.d directory],HTTPD_CONF=$withval,HTTPD_CONF=no)
if test x$HTTPD_CONF = xno; then
if test -d /etc/httpd/conf.d; then
	HTTPD_CONF="/etc/httpd/conf.d"
elif test -d /etc/apache2/conf.d; then
	HTTPD_CONF="/etc/apache2/conf.d"
elif test -d /etc/apache/conf.d; then
	HTTPD_CONF="/etc/apache/conf.d"
else
	HTTPD_CONF="$sysconfdir/apache-conf.d/"
fi
fi
AC_SUBST(HTTPD_CONF)

dnl Check for Apache user
apache_user=no
AC_ARG_WITH(apache_user,[  --with-apache-user=<user> sets path Apache runs with],apache_user=$withval,apache_user=no)
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
AC_ARG_WITH(apache_authname,[  --with-apache-authname=<authname> sets value of AuthName directive in Apache config],apache_authname=$withval,apache_authname="Nagios Access")
if test $(echo $naghtmurl | grep -i icinga | wc -l) -gt 0 -a "x$apache_authname" = "xNagios Access"; then
	apache_authname="Icinga Access"
fi
AC_SUBST(apache_authname)

AC_SUBST(LIB_DIR)
AC_SUBST(CFG_DIR)

AC_CONFIG_FILES(
	subst
	Makefile 
	sbin/Makefile
	etc/Makefile 
	etc/apache-conf.d/Makefile 
	lib/Makefile 
	libexec/Makefile)

AC_OUTPUT

$PERL subst sbin/InterfaceReset_v3t.cgi
$PERL subst lib/bsutils.pm
$PERL subst lib/settings.pm
$PERL subst libexec/check_interface_table_v3t.pl
$PERL subst etc/settings.cfg
$PERL subst etc/apache-conf.d/interfacetable_v3t.conf

dnl Review options
echo ""
echo ""
AC_MSG_RESULT([*** Configuration summary for $PKG_NAME $PKG_VERSION $PKG_REL_DATE ***:])

echo ""
echo " General Options:"
echo " -------------------------"

AC_MSG_RESULT([       Install user/group:  $nagiosbp_user,$nagiosbp_grp])
AC_MSG_RESULT([        Install \${prefix}:  $prefix])
AC_MSG_RESULT([   Install \${exec_prefix}:  $exec_prefix])
AC_MSG_RESULT([                  LIB Dir:  $libdir])
AC_MSG_RESULT([               Config Dir:  $sysconfdir])
AC_MSG_RESULT([                 Data Dir:  $datadir])
AC_MSG_RESULT([                  HTM URL:  $htmurl])
AC_MSG_RESULT([                  CGI URL:  $cgiurl])
AC_MSG_RESULT([        Nagios Config Dir:  $nagetc])
AC_MSG_RESULT([           Nagios HTM URL:  $naghtmurl])
AC_MSG_RESULT([           Nagios CGI URL:  $nagcgiurl])
AC_MSG_RESULT([        Apache conf.d Dir:  $HTTPD_CONF])
AC_MSG_RESULT([              Apache User:  $apache_user])
AC_MSG_RESULT([          Apache AuthName:  $apache_authname])
echo ""
echo ""
echo "Review the options above for accuracy.  If they look okay,"
echo "type 'make install' to install."
echo ""
