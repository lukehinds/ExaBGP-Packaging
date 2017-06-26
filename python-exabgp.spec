%global srcname exabgp

%{!?__python2:        %global __python2 /usr/bin/python2}
%{!?python2_sitelib:  %global python2_sitelib %(%{__python2} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}

Name:           python-%{srcname}
Version:        4.0.1
Release:        1%{?dist}
Summary:        The BGP swiss army knife of networking (Library)

License:        BSD
URL:            https://github.com/Exa-Networks/
Source0:        https://github.com/Exa-Networks/%{srcname}/archive/%{version}.tar.gz
BuildArch:      noarch

BuildRequires:  python2-setuptools 
BuildRequires:  python3-setuptools
BuildRequires:  python-six

Requires:       python2 >= 2.6
Requires:       python-ipaddr
Requires:       python-six

%description
ExaBGP python module

%package -n python2-%{srcname}
Summary:        %{summary}
Group:          Applications/Internet
BuildRequires:  systemd-units
BuildRequires:  python2-devel
Requires:       python2-%{srcname}
Requires:       systemd
Requires: %{name} = %{version}-%{release}
%{?python_provide:%python_provide python2-%{srcname}}

%description -n python2-%{srcname}
ExaBGP allows engineers to control their network from commodity servers.
Think of it as Software Defined Networking using BGP by transforming BGP
messages into friendly plain text or JSON.
It comes with an healthcheck application to help you monitor your daemons and
withdraw dead ones from the network during failures/maintenances.

%package -n python3-%{srcname}
Summary:        %{summary}
Group:          Applications/Internet
BuildRequires:  systemd-units
BuildRequires:  python3-devel
Requires:       python3-%{srcname}
Requires:       systemd
Requires: %{name} = %{version}-%{release}
%{?python_provide:%python_provide python3-%{srcname}}

%description -n python3-%{srcname}
ExaBGP allows engineers to control their network from commodity servers.
Think of it as Software Defined Networking using BGP by transforming BGP
messages into friendly plain text or JSON.
It comes with an healthcheck application to help you monitor your daemons and
withdraw dead ones from the network during failures/maintenances.

%prep
%setup -q -n exabgp-%{version}

%build
%py2_build
%py3_build

%install

%py3_install
%{__python3} setup.py install -O1 --root ${RPM_BUILD_ROOT}

%py2_install
%{__python2} setup.py install -O1 --root ${RPM_BUILD_ROOT}

install bin/healthcheck ${RPM_BUILD_ROOT}%{_bindir}
mv ${RPM_BUILD_ROOT}%{_bindir} ${RPM_BUILD_ROOT}%{_sbindir}
mv ${RPM_BUILD_ROOT}%{_sbindir}/healthcheck ${RPM_BUILD_ROOT}/%{_sbindir}/exabgp-healthcheck

install -d -m 744 ${RPM_BUILD_ROOT}/%{_sysconfdir}/exabgp
install -d -m 755 ${RPM_BUILD_ROOT}/%{_libdir}/exabgp

mv ${RPM_BUILD_ROOT}/usr/share/exabgp/etc/* ${RPM_BUILD_ROOT}/%{_libdir}/exabgp/

install -d %{buildroot}/%{_unitdir}
install etc/systemd/exabgp.service %{buildroot}/%{_unitdir}/

install -d %{buildroot}/%{_mandir}/man1
install doc/man/exabgp.1 %{buildroot}/%{_mandir}/man1

install -d %{buildroot}/%{_mandir}/man5
install doc/man/exabgp.conf.5 %{buildroot}/%{_mandir}/man5

# Sample .conf
ln -s %{_libdir}/exabgp/api-api.conf %{buildroot}/%{_sysconfdir}/exabgp/exabgp.conf

%post -n exabgp
%systemd_post exabgp.service

%preun -n exabgp
%systemd_preun exabgp.service

%postun -n exabgp
%systemd_postun_with_restart exabgp.service

%files -n python2-%{srcname}
%{python2_sitelib}/*
%doc CHANGELOG README.md
%license COPYRIGHT
%attr(755, root, root) %{_sbindir}/exabgp-healthcheck
%dir %{_libdir}/exabgp
%dir %{_datadir}/exabgp
%dir %{_datadir}/exabgp/processes
%dir %{_sysconfdir}/exabgp
%attr(644, root, root) %{_libdir}/exabgp/*
%attr(744, root, root) %{_datadir}/exabgp/processes/*
%{_unitdir}/exabgp.service
%{_mandir}/man1/*
%{_mandir}/man5/*
%config(noreplace) %{_sysconfdir}/exabgp/exabgp.conf

%files -n python3-%{srcname}
%{python3_sitelib}/*
%doc CHANGELOG README.md
%license COPYRIGHT
%attr(755, root, root) %{_sbindir}/exabgp
%attr(755, root, root) %{_sbindir}/exabgp-healthcheck
%dir %{_libdir}/exabgp
%dir %{_datadir}/exabgp
%dir %{_datadir}/exabgp/processes
%dir %{_sysconfdir}/exabgp
%attr(644, root, root) %{_libdir}/exabgp/*
%attr(744, root, root) %{_datadir}/exabgp/processes/*
%{_unitdir}/exabgp.service
%{_mandir}/man1/*
%{_mandir}/man5/*
%config(noreplace) %{_sysconfdir}/exabgp/exabgp.conf

%changelog
* Mon June 26 2017 Luke Hinds <lhinds@redhat.com> - 4.0.1
- Python 3 support and 4.0.1 release
* Fri May 19 2017 Luke Hinds <lhinds@redhat.com> - 4.0.0
- Initial release
