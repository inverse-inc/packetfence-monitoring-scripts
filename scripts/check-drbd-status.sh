#!/bin/bash
#fname:check-drbd-status.sh

# Get DRBD status
status=$(egrep "(Primary\/Secondary|Secondary\/Primary)" /proc/drbd | egrep -o UpToDate/UpToDate | wc -l)
cat /proc/drbd >> $drbd_output

# Check if returned matching line is 1
if [ ! $status -eq 1 ] ; then
    echo "DRBD state does not appear to be sane."
    echo $drbd_output
    exit 1
fi
