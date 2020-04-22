#!/bin/bash
#fname:check-currently-at.sh

# handle PF versions v10 and later
if grep advanced.configurator /usr/local/pf/conf/pf.conf.defaults; then
    if ! egrep "^configurator[[:blank:]]?=[[:blank:]]?disabled" /usr/local/pf/conf/pf.conf ; then
        echo "Configurator opened. Disable access by setting configurator=disabled in pf.conf"
        exit 1
    fi

# handle PF versions prior to v10
else

    if ! [ -f /usr/local/pf/conf/currently-at ]; then
      echo "/usr/local/pf/conf/currently-at is missing. This will leave the configurator opened."
      echo "Complete the upgrade using the upgrade guide, then execute: cat /usr/local/pf/conf/pf-release > /usr/local/pf/conf/currently-at"
      exit 1
    fi

    if ! cat /usr/local/pf/conf/pf-release | grep "`cat /usr/local/pf/conf/currently-at`"; then
      echo "/usr/local/pf/conf/currently-at wasn't updated after performing an upgrade. This will leave the configurator opened."
      echo "Complete the upgrade using the upgrade guide, then execute: cat /usr/local/pf/conf/pf-release > /usr/local/pf/conf/currently-at"
      exit 1
    fi
fi

exit 0
