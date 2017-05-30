
#
# This file is not needed for review, and is only used for the
# shell API plugin. No need to modify it or anything.
#

declare -f +x module
PATH=/bin:/usr/bin:/sbin/:/usr/sbin

declare -A FR_FLAGS
FR_FLAGS[EXARCH]=''
FR_FLAGS[DISTTAG]=''
FR_FLAGS[EPEL5]=''
FR_FLAGS[BATCH]=''
FR_FLAGS[EPEL6]=''

declare -A FR_SETTINGS 
FR_SETTINGS[resultdir]=""
FR_SETTINGS[verbose]=""
FR_SETTINGS[no_report]=""
FR_SETTINGS[session_log]="/home/luke/.cache/fedora-review.log"
FR_SETTINGS[list_flags]=""
FR_SETTINGS[list_checks]=""
FR_SETTINGS[single]=""
FR_SETTINGS[rpm_spec]=""
FR_SETTINGS[plugins]=""
FR_SETTINGS[exclude]=""
FR_SETTINGS[configdir]=""
FR_SETTINGS[log_level]="20"
FR_SETTINGS[log]="<logging.RootLogger object at 0x7f90501d1850>"
FR_SETTINGS[init_done]="True"
FR_SETTINGS[cache]=""
FR_SETTINGS[mock_config]=""
FR_SETTINGS[version]=""
FR_SETTINGS[uniqueext]=""
FR_SETTINGS[flags]=""
FR_SETTINGS[bz_url]="https://bugzilla.redhat.com"
FR_SETTINGS[mock_options]="--no-cleanup-after --no-clean"
FR_SETTINGS[list_plugins]=""
FR_SETTINGS[other_bz]=""
FR_SETTINGS[plugins_arg]=""
FR_SETTINGS[repo]=""
FR_SETTINGS[use_colors]="True"
FR_SETTINGS[bug]="1452649"
FR_SETTINGS[prebuilt]=""
FR_SETTINGS[name]="python-exabgp"
FR_SETTINGS[url]=""
FR_SETTINGS[checksum]="sha256"
FR_SETTINGS[nobuild]=""

export FR_REVIEWDIR='/home/luke/repos/ExaBGP-Packaging/1452649-python-exabgp'
export HOME=$FR_REVIEWDIR
cd $HOME

export FR_NAME='python-exabgp'
export FR_VERSION='4.0.0'
export FR_RELEASE='1.fc25'
export FR_GROUP='Unspecified'
export FR_LICENSE='BSD'
export FR_URL='https://github.com/Exa-Networks/'

export Source0="https://github.com/Exa-Networks/exabgp/archive/4.0.0.tar.gz"



export FR_PREP='cd '\''/home/luke/rpmbuild/BUILD'\''
rm -rf '\''exabgp-4.0.0'\''
/usr/bin/tar -xof /home/luke/rpmbuild/SOURCES/4.0.0.tar.gz
cd '\''exabgp-4.0.0'\''
/usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .'
export FR_BUILD='/usr/bin/python2 setup.py build'
export FR_INSTALL='/usr/bin/python2 setup.py install -O1 --root ${RPM_BUILD_ROOT}
install bin/healthcheck ${RPM_BUILD_ROOT}/usr/bin
mv ${RPM_BUILD_ROOT}/usr/bin ${RPM_BUILD_ROOT}/usr/sbin
mv ${RPM_BUILD_ROOT}/usr/sbin/healthcheck ${RPM_BUILD_ROOT}//usr/sbin/exabgp-healthcheck
install -d -m 744 ${RPM_BUILD_ROOT}//etc/
install -d -m 755 ${RPM_BUILD_ROOT}//etc/exabgp/examples
mv ${RPM_BUILD_ROOT}/usr/share/exabgp/etc/* ${RPM_BUILD_ROOT}//etc/exabgp/examples
install -d /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//usr/lib/systemd/system
install etc/systemd/exabgp.service /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//usr/lib/systemd/system/
install -d /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//usr/share/man/man1
install doc/man/exabgp.1 /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//usr/share/man/man1
install -d /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//usr/share/man/man5
install doc/man/exabgp.conf.5 /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//usr/share/man/man5
# Sample .conf
ln -s /etc/exabgp/examples/api-api.conf /home/luke/rpmbuild/BUILDROOT/python-exabgp-4.0.0-1.fc25.x86_64//etc/exabgp/exabgp.conf'

declare -A FR_FILES
FR_FILES[python-exabgp]='/usr/lib/python2.7/site-packages/*
%doc CHANGELOG README.md
%license COPYRIGHT'
FR_FILES[exabgp]='%defattr(-,root,root,-)
%attr(755, root, root) /usr/sbin/exabgp
%attr(755, root, root) /usr/sbin/exabgp-healthcheck
%dir /etc/exabgp
%dir /etc/exabgp/examples
%attr(744, root, root) /usr/share/exabgp/processes/*
/usr/lib/systemd/system/exabgp.service
%doc CHANGELOG README.md
%license COPYRIGHT
/usr/share/man/man1/*
/usr/share/man/man5/*
%config(noreplace) /etc/exabgp/exabgp.conf
%config(noreplace) /etc/exabgp/examples/*'

declare -A FR_DESCRIPTION


export FR_FILES FR_DESCRIPTION

export FR_PASS=80
export FR_FAIL=81
export FR_PENDING=82
export FR_NOT_APPLICABLE=83


function get_used_rpms()
# returns (stdout) list of used rpms if found, else returns 1
{
    cd $FR_REVIEWDIR
    if test  "${FR_SETTINGS[prebuilt]}" = True
    then
        files=( $(ls ../*.rpm 2>/dev/null | grep -v .src.rpm) )                || files=( '@@' )
    else
        files=( $(ls results/*.rpm 2>/dev/null | grep -v .src.rpm) )                || files=( '@@' )
    fi
    test -e ${files[0]} || return 1
    echo "${files[@]}"
    cd $OLDPWD
}

function unpack_rpms()
# Unpack all non-src rpms in results into rpms-unpacked, one dir per rpm.
{
    [ -d rpms-unpacked ] && return 0
    rpms=( $( get_used_rpms ) ) || return 1
    mkdir rpms-unpacked
    cd rpms-unpacked
    retval=0
    for rpm_path in ${rpms[@]};  do
        rpm=$( basename $rpm_path)
        mkdir $rpm
        cd $rpm
        rpm2cpio ../../$rpm_path | cpio -imd &>/dev/null
        cd ..
    done
    cd ..
}

function unpack_sources()
# Unpack sources in upstream into upstream-unpacked
# Ignores (reuses) already unpacked items.
{
    sources=( $(cd upstream; ls) ) || sources=(  )
    if [[ ${#sources[@]} -eq 0 || ! -e "upstream/${sources[0]}" ]]; then
       return $FR_NOT_APPLICABLE
    fi
    for source in "${sources[@]}"; do
        mkdir upstream-unpacked/$source 2>/dev/null || continue
        rpmdev-extract -qfC  upstream-unpacked/$source upstream/$source ||            cp upstream/$source upstream-unpacked/$source
    done
}

function attach()
# Usage: attach <sorting hint> <header>
# Reads attachment from stdin
{
    startdir=$(pwd)
    cd $FR_REVIEWDIR
    for (( i = 0; i < 10; i++ )); do
        test -e $FR_REVIEWDIR/.attachments/*$i || break
    done
    if [ $i -eq 10 ]; then
        echo "More than 10 attachments! Giving up" >&2
        exit 1
    fi
    sort_hint=$1
    shift
    title=${*//\/ }
    file="$sort_hint;${title/;/:};$i"
    cat > .attachments/"$file"
    cd $startdir
}

