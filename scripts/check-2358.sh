#!/bin/bash
#fname:check-2358.sh

pfversion

if [ "$MAINTENANCE_VERSION" = "7.0" ]; then
  if /usr/local/pf/bin/pfcmd pfconfig show config::Pfmon | grep "'rotate'" | egrep '(Y|enabled)' > /dev/null; then
    if ! grep 'rotate_' /usr/local/pf/lib/pfconfig/namespaces/config/Pfmon.pm > /dev/null; then
      echo "ip4log or ip6log rotation is enabled and the setup is affected by bugs #2358 and #2359\n"
      echo "Apply the maintenance branch (/usr/local/pf/addons/pf-maint.pl) and restart packetfence-config and pfmon to fix this issue"
      exit 1
    fi
  fi
fi

exit 0
