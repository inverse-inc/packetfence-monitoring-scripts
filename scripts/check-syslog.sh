#!/bin/bash
#fname:check-syslog.sh


SYSLOG_FILE="/etc/rsyslog.conf"

if ! grep "\-/var/log/messages" $SYSLOG_FILE &> /dev/null; then
  echo "Syslog is not in asynchronous mode"
  exit 1
fi

exit 0
