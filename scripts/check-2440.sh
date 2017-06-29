#!/bin/bash
#fname:check-2440.sh

pfversion

if [ "$MAINTENANCE_VERSION" = "7.0" ] || [ "$MAINTENANCE_VERSION" = "7.1" ]; then
  if galera_enabled; then
    if ! grep expire_logs_days /usr/local/pf/var/conf/mariadb.conf > /dev/null; then
      echo "There is no limit for the binary logs of Galera cluster\n"
      echo "This can lead to a lot of disk space usage in /var/lib/mysql/ and potentially to the disk being full\n"
      echo "See this thread for resolution: https://github.com/inverse-inc/packetfence/issues/2440"
      exit 1
    fi
  fi
fi

exit 0
