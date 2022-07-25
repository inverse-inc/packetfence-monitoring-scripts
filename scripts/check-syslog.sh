#!/bin/bash
#fname:check-syslog.sh


SYSLOG_FILE="/etc/rsyslog.conf"

if ! grep "\-/var/log/messages" $SYSLOG_FILE &> /dev/null; then
  echo "The rsyslog daemon is not using the asynchronous mode for /var/log/messages \n"
  echo "To fix this, run: \n"
  echo "  sed -i 's#\s/var/log/messages# -/var/log/messages#' /etc/rsyslog.conf \n"
  echo "  systemctl restart rsyslog \n"
  exit 1
fi

exit 0
