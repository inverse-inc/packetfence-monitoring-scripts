#!/bin/bash
#fname:check-2502.sh

if ! [ -z "$(command -v mysql)" ]; then

    # is MariaDB running? meaning we are the live packetfence
    # We check for the packetfence-mariadb PID which means only versions 7.0 and above will use this script
    if [ -f /var/lib/mysql/`hostname`.pid ]; then
        dbparams
        MAX_CONN=`mysql -h $DB_HOST -u $DB_USER -p$DB_PWD -D $DB_NAME -e "show variables like 'max_connections'" | tail -1 | awk '{ print $2 }'`
        if [ $MAX_CONN -eq 214 ]; then
          echo "MySQL is using the default number of connections (214) which means the setting database_advanced.max_connections may be ignored\n"
          echo "See this for resolution: https://github.com/inverse-inc/packetfence/issues/2502 or contact the PacketFence support for help"
          exit 1
        fi
        echo $MAX_CONN
    fi
fi

exit 0
