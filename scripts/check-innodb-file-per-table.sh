#!/bin/bash
#fname:check-innodb_file_per_table.sh

if ! [ -z "$(command -v mysql)" ]; then
    # check if MySQL or MariaDB is installed
    if mysql -V | grep -q "MariaDB"; then
        SQL_ENGINE='mariadb'
    else
        SQL_ENGINE="mysqld"
    fi


    # is MySQL running? meaning we are the live packetfence
    if [ -f /var/run/$SQL_ENGINE/$SQL_ENGINE.pid ]; then
        dbparams
        INNODB=`mysql -h $DB_HOST -u $DB_USER -p$DB_PWD -D $DB_NAME -e "select 1 from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME=\"INNODB_FILE_PER_TABLE\" and VARIABLE_VALUE=\"ON\";"`
        if [ -z "$INNODB" ]; then
            echo "INNODB_FILE_PER_TABLE is not enabled"
            exit 1
        fi
    fi
fi

exit 0
