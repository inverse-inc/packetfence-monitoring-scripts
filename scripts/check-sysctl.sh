#!/bin/bash
#fname:check-sysctl.sh

# Passthrough test
if [ `perl -I/usr/local/pf/lib -Mpf::db -e 'print scalar(keys(%pf::config::ConfigDomain))'` -ge 1 ] ; then
    if [ `sysctl -e -n net.ipv4.ip_forward` -eq 0 ] ; then
      echo "The passthroughs and the Multi-domain configuration won't work, net.ipv4.ip_forward = 0"
      exit 1
    fi
fi
# Active-Active mode test
if [ `perl -I/usr/local/pf/lib -Mpf::db -e 'print scalar(@pf::cluster::cluster_hosts)'` -ge 1 ] ; then
    if [ `sysctl -e -n net.ipv4.ip_nonlocal_bind` -eq 0 ] ; then
      echo "Server not configured properly for Active-Active Cluster, net.ipv4.ip_nonlocal_bind = 0"
      exit 1
    fi
fi

exit 0
