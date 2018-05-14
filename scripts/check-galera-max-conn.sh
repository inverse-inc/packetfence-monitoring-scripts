#!/bin/bash
#fname:check-galera-max-conn.sh

if ! [ -z "$(command -v mysql)" ]; then

    # is MariaDB running? meaning we are the live packetfence
    # We check for the packetfence-mariadb PID which means only versions 7.0 and above will use this script
    # We also check if Galera is enabled
    if [ -f /var/lib/mysql/`hostname`.pid ] && galera_enabled; then
        dbparams
        MAX_CONN=`mysql -h $DB_HOST -u $DB_USER -p$DB_PWD -D $DB_NAME -s -N -e "show variables like 'max_connections'" | awk '{ print $2 }'`
        if [ $MAX_CONN -lt 1000 ]; then
          echo "You are using less than 1000 connections ($MAX_CONN) for MySQL while having Galera cluster enabled\n"
          echo "This is known to cause potential issues under high load.\n"
          echo "We suggest you increase the amount of connections in database_advanced.max_connections and restart packetfence-mariadb"
          echo "On top of this, you should also, update the systemd unit file using the following command: curl https://raw.githubusercontent.com/inverse-inc/packetfence/devel/conf/systemd/packetfence-mariadb.service > /usr/lib/systemd/system/packetfence-mariadb.service && systemctl daemon-reload && systemctl restart packetfence-mariadb"
          exit 1
        fi
    fi
fi

exit 0
