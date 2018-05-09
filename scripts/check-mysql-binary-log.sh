#!/bin/bash
#fname:check-mysql-binary-log.sh

if ! [ -z "$(command -v mysql)" ]; then
    # check if MySQL or MariaDB is installed
    if mysql -V | grep -q "MariaDB"; then
        SQL_ENGINE="mariadb"
    else
        SQL_ENGINE="mysqld"
    fi


    # is MySQL running? meaning we are the live packetfence
    if [ -f /var/run/$SQL_ENGINE/$SQL_ENGINE.pid ]; then
        dbparams
        INNODB=`mysql -h $DB_HOST -u $DB_USER -p$DB_PWD -D $DB_NAME -e "select 1 from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME=\"LOG_BIN\" and VARIABLE_VALUE=\"OFF\";"`
        if [ -z "$INNODB" ]; then
            echo "BINARY LOG FILE is enabled, it is suggested to disable this by commenting out log-bin=mysql-bin in /usr/local/pf/conf/mariadb/mariadb.conf.tt and restarting packetfence-mariadb"
            exit 1
        fi
    fi
fi

exit 0
