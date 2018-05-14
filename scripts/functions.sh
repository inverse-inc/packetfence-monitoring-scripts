#!/bin/bash
#fname:functions.sh
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

export -f lowercase

osdetect(){
    OS=`lowercase \`uname\``
    KERNEL=`uname -r`
    MACH=`uname -m`

    if [ "{$OS}" == "windowsnt" ]; then
        OS=windows
    elif [ "{$OS}" == "darwin" ]; then
        OS=mac
    else
        OS=`uname`
        if [ "${OS}" = "SunOS" ] ; then
            OS=Solaris
            ARCH=`uname -p`
            OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
        elif [ "${OS}" = "AIX" ] ; then
            OSSTR="${OS} `oslevel` (`oslevel -r`)"
        elif [ "${OS}" = "Linux" ] ; then
            if [ -f /etc/redhat-release ] ; then
                DistroBasedOn='RedHat'
                DIST=`cat /etc/redhat-release |sed s/\ release.*//`
                PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
                REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
            elif [ -f /etc/SuSE-release ] ; then
                DistroBasedOn='SuSe'
                PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
                REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
            elif [ -f /etc/mandrake-release ] ; then
                DistroBasedOn='Mandrake'
                PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
                REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
            elif [ -f /etc/debian_version ] ; then
                DistroBasedOn='Debian'
                if [ -f /etc/lsb-release ] ; then
                    DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
                    PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
                    REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
                fi
            fi
            if [ -f /etc/UnitedLinux-release ] ; then
                DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
            fi
            OS=`lowercase $OS`
            DistroBasedOn=`lowercase $DistroBasedOn`
            export OS
            export DIST
            export DistroBasedOn
            export PSUEDONAME
            export REV
            export KERNEL
            export MACH
        fi

    fi
}

export -f osdetect

dbparams(){
    DB_USER=$(perl -I/usr/local/pf/lib -Mpf::db -e 'print $pf::db::DB_Config->{user}')
    DB_PWD=$(perl -I/usr/local/pf/lib -Mpf::db -e 'print $pf::db::DB_Config->{pass}')
    DB_NAME=$(perl -I/usr/local/pf/lib -Mpf::db -e 'print $pf::db::DB_Config->{db}')
    DB_HOST=$(perl -I/usr/local/pf/lib -Mpf::db -e 'print $pf::db::DB_Config->{host}')
    export DB_USER
    export DB_PWD
    export DB_NAME
    export DB_HOST
}

export -f dbparams

pfversion() {
    PF_VERSION=($(awk '{ print $2 }' /usr/local/pf/conf/pf-release))
    MAINTENANCE_VERSION="${PF_VERSION%.*}"
    export PF_VERSION
    export MAINTENANCE_VERSION
}

export -f pfversion

github_is_reachable() {
    URLS='
        https://raw.githubusercontent.com
        https://github.com
    '

    for i in $URLS; do
        RC=`wget --server-response $i -O /dev/null 2>&1 | awk '/^  HTTP/{print $2}'`
        if [[ ! "$RC" =~ "200" ]]; then
            return 1
        fi
    done

    return 0
}

export -f github_is_reachable

galera_enabled() {
  if [ -f /var/lib/mysql/grastate.dat ];then
    return 0
  else
    return 1
  fi
}

export -f galera_enabled

cluster_members() {
    CLUSTER_MEMBERS=`perl -I/usr/local/pf/lib -Mpf::cluster -e 'print join(", ", map { $_->{host} . ":" . $_->{management_ip} } @cluster_servers)'`
    export CLUSTER_MEMBERS
}

export -f cluster_members

cluster_members_count() {
    CLUSTER_MEMBERS_COUNT=`perl -I/usr/local/pf/lib -Mpf::cluster -e 'print scalar @cluster_servers'`
    export CLUSTER_MEMBERS_COUNT
}

export -f cluster_members_count

packetfence_mariadb_running() {
    if [ -f /var/lib/mysql/`hostname`.pid ]; then
        return 0
    else 
        return 1
    fi
}

export -f packetfence_mariadb_running
