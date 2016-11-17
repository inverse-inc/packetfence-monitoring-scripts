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
error=($(awk '!/^0$/' /usr/local/pf/var/logrotate.status))
if [ $error ]; then
    echo "PacketFence logrotate script '$FILENAME' exited with status '$error'"
    exit 1
fi

# Check for PacketFence logrotate script update against maintenance branch
# Checks the '/etc/logrotate.d/packetfence' file
pf_version=($(awk '{ print $2 }' /usr/local/pf/conf/pf-release))
maintenance_version="${pf_version%.*}"
base_url="https://raw.githubusercontent.com/inverse-inc/packetfence/maintenance/$maintenance_version"
osdetect
if [ $DistroBasedOn == "redhat" ] ; then
    latest=$(curl -s -L $base_url/addons/logrotate)
    current=`cat $FILENAME`
else
    latest=$(curl -s -L $base_url/debian/packetfence.logrotate)
    current=`cat $FILENAME`
fi
if [ "$current" != "$latest" ] ; then
    echo "PacketFence logrotate script '$FILENAME' is not up to date compared to maintenance for '$pf_version'"
    exit 1
fi

exit 0
