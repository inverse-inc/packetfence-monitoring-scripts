#!/bin/bash
#fname:check-galera-max-conn.sh

if ! [ -z "$(command -v mysql)" ]; then

    # is MySQL running? meaning we are the live packetfence
    # We check for the packetfence-mariadb PID which means only versions 7.0 and above will use this script
    # We also check if Galera is enabled
    if [ -f /var/lib/mysql/`hostname`.pid ] && galera_enabled; then
        dbparams
        MAX_CONN=`mysql -h $DB_HOST -u $DB_USER -p$DB_PWD -D $DB_NAME -e "show variables like 'max_connections'" | tail -1 | awk '{ print $2 }'`
        if [ $MAX_CONN -lt 1000 ]; then
          echo "You are using less than 1000 connections ($MAX_CONN) for MySQL while having Galera cluster enabled\n"
          echo "This is know to cause potential issues under high load.\n"
          echo "We suggest you up the amount of connections in database_advanced.max_connections and restart packetfence-mariadb"
          exit 1
        fi
        echo $MAX_CONN
    fi
fi

exit 0
