#!/bin/bash
#fname:check-drbd-config.sh

if ! [ -d /etc/drbd.d ]; then
  exit 0
fi

# Check for automatic splitbrain resolution configuration parameter
if grep -qR "discard-secondary" /etc/drbd.d/; then
    echo "DRBD seems to be configured to automatically resolve splitbrain..."
    exit 1
fi

exit 0
