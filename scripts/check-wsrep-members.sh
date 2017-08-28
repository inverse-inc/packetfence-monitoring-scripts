#!/bin/bash
#fname:check-wsrep-members.sh

if ! [ -z "$(command -v mysql)" ]; then

    # is MariaDB running? meaning we are the live packetfence
    # We check for the packetfence-mariadb PID which means only versions 7.0 and above will use this script
    # We also check if Galera is enabled
    if [ -f /var/lib/mysql/`hostname`.pid ] && galera_enabled; then
        dbparams
        cluster_members_count
        MEMBERS=`mysql -h $DB_HOST -u $DB_USER -p$DB_PWD -D $DB_NAME -s -N -e "show status like 'wsrep_incoming_addresses';" | awk '{ print $2 }'`
        COUNT=`grep -o ',' <<< $MEMBERS | wc -l`
        COUNT=`expr $COUNT + 1`
        if [ $COUNT -lt $CLUSTER_MEMBERS_COUNT ]; then
            echo "Wrong amount of WSREP cluster members $COUNT vs required $CLUSTER_MEMBERS_COUNT \n"
            echo "List of current members: $MEMBERS"
            exit 1
        fi
    fi
fi

exit 0
