#!/bin/bash
#fname:check-drbd-status.sh

if ! [ -f /proc/drbd ] ; then
    exit 0
fi

# Get DRBD status
drbd_output=""
status=$(egrep "(Primary\/Secondary|Secondary\/Primary)" /proc/drbd | egrep -o UpToDate/UpToDate | wc -l)
cat /proc/drbd >> $drbd_output

# Check if returned matching line is 1
if [ ! $status -eq 1 ] ; then
    echo "DRBD state does not appear to be sane."
    echo $drbd_output
    exit 1
fi

exit 0
