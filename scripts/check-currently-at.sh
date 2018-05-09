#!/bin/bash
#fname:check-currently-at.sh

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

exit 0
