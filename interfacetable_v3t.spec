Name:		interfacetable_v3t
Version:	1.00
Release:	1%{?dist}
Summary:	Interfacetable_v3t allows you to monitor the network interfaces of a node

Group:		Applications/System	
License:	GPLv2 and GPLv3
URL:		https://github.com/Tontonitch/interfacetable_v3t/archive/v1.00.tar.gz
Source0:	v1.00.tar.gz	

BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root

%if "%{_vendor}" == "redhat"
BuildRequires:	net-snmp-utils
BuildRequires:	perl 
BuildRequires:	perl-CGI
BuildRequires:	perl-Config-General 
BuildRequires:	perl-Sort-Naturally 
BuildRequires:	perl-Exception-Class 
%if 0%{?el6}
BuildRequires:	perl-Time-HiRes
%endif
Requires:	net-snmp-utils
Requires:	sudo 
Requires:	perl 
Requires:	perl-CGI
Requires:	perl-Config-General 
Requires:	perl-Sort-Naturally 
Requires:	perl-Exception-Class 
Requires:	perl-Time-HiRes
Requires:	icinga 
%define pluginpath %{_libdir}/nagios/plugins
%define sudodir %{_sysconfdir}/sudoers.d
%define sudoers %{sudodir}/%{name}
%define apacheauthname 'Icinga Access'
%define apacheauthfile /etc/icinga/passwd
%define apachename httpd
%define apacheuser apache
%define apacheconf %{_sysconfdir}/%{apachename}/conf.d
%define pnp4nagiostemplates %{_datadir}/pnp4nagios/html/templates
%endif

%if "%{_vendor}" == "suse"
BuildRequires:	net-snmp
BuildRequires:	perl-TermReadKey
BuildRequires:	perl 
BuildRequires:	perl-CGI
BuildRequires:	perl-FastCGI
BuildRequires:	perl-Config-General 
BuildRequires:	perl-Sort-Naturally 
BuildRequires:	perl-Exception-Class 
Requires:	net-snmp
Requires:	perl-TermReadKey
Requires:	sudo 
Requires:	perl 
Requires:	perl-CGI
Requires:	perl-FastCGI
Requires:	perl-Config-General 
Requires:	perl-Sort-Naturally 
Requires:	perl-Exception-Class 
Requires:	icinga 
%define pluginpath /usr/lib/nagios/plugins
%define sudodir %{_sysconfdir}/sudoers.d
%define sudoers %{sudodir}/%{name}
%define apacheauthname 'Icinga Access'
%define apacheauthfile /etc/icinga/passwd
%define apachename apache2
%define apacheuser wwwrun
%define apacheconf %{_sysconfdir}/%{apachename}/conf.d
%define pnp4nagiostemplates %{_datadir}/pnp4nagios/html/templates
%endif

%description

Interfacetable_v3t (formerly check_interface_table_v3t) is a Nagios(R) addon
that allows you to monitor the network interfaces of a node (e.g. router, 
switch, server) without knowing each interface in detail. Only the hostname 
(or ip address) and the snmp community string are required. It generates a 
html page gathering some info on the monitored node and a table of all 
interfaces/ports and their status. 

%package pnp4nagios
Summary: Pnp4nagios support for %{name}
Group: Applications/System
Requires: pnp4nagios >= 0.6
Requires: %{name} = %{version}

%description pnp4nagios
This package contains the templates for pnp4nagios for %{name}


%prep
%setup -q -n interfacetable_v3t-1.00


%build
%configure --sysconfdir=%{_sysconfdir}/%{name} \
  --datarootdir=%{_datadir}/%{name} \
  --libdir=%{_libdir}/%{name} \
  --with-nagios-base=%{_sysconfdir}/icinga \
  --with-nagios-libexec=%{pluginpath} \
  --with-httpd-conf=%{apacheconf} \
  --with-apache-user=%{apacheuser} \
  --with-apache-authname=%{apacheauthname} \
  --with-apache-authfile=%{apacheauthfile} \
  --with-cgidir=%{_libdir}/%{name}/cgi \
  --with-cachedir=%{_localstatedir}/cache/%{name}/cache \
  --with-statedir=%{_localstatedir}/cache/%{name}/state \
  --with-sudoers=%{sudoers}
make %{?_smp_mflags}


%install
mkdir -p %{buildroot}%{sudodir}
touch %{buildroot}%{sudoers}
make fullinstall DESTDIR=%{buildroot} INSTALL_OPTS=""
mkdir -p %{buildroot}%{_localstatedir}/cache/%{name}/cache
mkdir -p %{buildroot}%{_localstatedir}/cache/%{name}/state
mkdir -p %{buildroot}%{_defaultdocdir}/%{name} 
mv %{buildroot}%{_sysconfdir}/%{name}/settings.cfg-sample %{buildroot}%{_defaultdocdir}/%{name}/settings.cfg-sample
mkdir -p %{buildroot}%{pnp4nagiostemplates} 
cp contrib/pnp4nagios/* %{buildroot}%{pnp4nagiostemplates}/


%files
%defattr(-,root,root,-)
%config(noreplace) %{apacheconf}/%name.conf
%{_datadir}/%{name}
%{_libdir}/%{name}
%{pluginpath}/check_interface_table_v3t.pl
%config(noreplace) %{sudoers}
%attr(-,icinga,icinga) %{_localstatedir}/cache/%{name}
%doc %{_defaultdocdir}/%{name}/settings.cfg-sample

%files pnp4nagios
%defattr(-,root,root,-)
%{pnp4nagiostemplates}/*

%changelog
* Fri Jan 04 2019 Yannick Charton <tontonitch-pro@yahoo.fr> - 1.00
- update to 1.00
* Fri May 23 2014 Dirk Goetz <dirk.goetz@netways.de> - 0.05.1-1
- inital build
