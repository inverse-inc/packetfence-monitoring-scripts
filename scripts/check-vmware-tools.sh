#!/bin/bash
#fname:check-vmware-tools.sh

if ! which vmware-toolbox  ; then
  echo "VMware(R) Tools are not installed"
  exit 1
fi
