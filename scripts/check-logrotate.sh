#!/bin/bash
#fname:check-logrotate.sh

FILENAME="/etc/logrotate.d/packetfence"
EXPECTED_OCTAL=644
EXPECTED_OWNER="root.root"

# Check for PacketFence logrotate script permissions
# Checks the '/etc/logrotate.d/packetfence' file
if [ -f $FILENAME ] ; then
    octal=($(stat -c "%a" $FILENAME))
    owner=($(ls -l $FILENAME | awk '{ print $3"."$4 }'))
    if [ $octal -ne $EXPECTED_OCTAL ] ; then
        echo "PacketFence logrotate script '$FILENAME' does not have the right rights (644) vs. '$octal'"
        exit 1
    fi
    if [ $owner != $EXPECTED_OWNER ] ; then
        echo "PacketFence logrotate script '$FILENAME' does not have the right ownership (root.root) vs. '$owner'"
        exit 1
    fi
else
    echo "PacketFence logrotate script '$FILENAME' does not exists"
    exit 1
fi

# Check PacketFence logrotate script status
# Checks the '/usr/local/pf/var/logrotate.status' file
if ! [ -f /usr/local/pf/var/logrotate.status ]; then
  echo "PacketFence logrotate status file does not exists"
  exit 1
fi
error=($(awk '!/^0$/' /usr/local/pf/var/logrotate.status))
if [ $error ]; then
    echo "PacketFence logrotate script '$FILENAME' exited with status '$error'"
    exit 1
fi

# Check for PacketFence logrotate script update against maintenance branch
# Checks the '/etc/logrotate.d/packetfence' file
if ! github_is_reachable; then
    exit 0
fi

pfversion
latest_url="https://raw.githubusercontent.com/inverse-inc/packetfence/maintenance/$MAINTENANCE_VERSION/packetfence.logrotate"
latest=$(curl -s -L $latest_url)
current=`cat $FILENAME`
if [ "$current" != "$latest" ] ; then
    echo "PacketFence logrotate script '$FILENAME' is not up to date compared to maintenance for '$PF_VERSION' which can be found at '$latest_url'"
    exit 1
fi

exit 0
