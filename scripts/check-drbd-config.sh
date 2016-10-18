#!/bin/bash
#fname:check-drbd-config.sh

# Check for automatic splitbrain resolution configuration parameter
if grep -qR "discard-secondary" /etc/drbd.d/; then
    echo "DRBD seems to be configuration to automatically resolve splitbrain..."
    exit 1
fi
