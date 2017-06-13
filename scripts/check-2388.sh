#!/bin/bash
#fname:check-2388.sh

pfversion

if [ "$MAINTENANCE_VERSION" = "7.0" ] || [ "$MAINTENANCE_VERSION" = "7.1" ]; then
  if [ -f /var/lib/mysql/grastate.dat ]; then
    if ! grep IS_CLUSTER addons/database-backup-and-maintenance.sh > /dev/null; then
      echo "Database script may freeze Galera cluster during nightly backups (see #2388)\n"
      echo "Apply the maintenance branch (/usr/local/pf/addons/pf-maint.pl) to fix this issue"
      exit 1
    fi
  fi
fi

exit 0

