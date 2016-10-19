#!/bin/bash
#fname:check-vm.sh

osdetect

if [ $DistroBasedOn == "redhat" ]; then
   if ! [ -z "$(dmesg |grep -i 'Hypervisor detected')" ]; then
       # check if it's a VMWare Hypervisor
       if dmesg |grep -i "Hypervisor detected" | grep -q "VMware"; then
         # check if the VMware(R) Tools are installed
         if ! which vmware-toolbox-cmd  ; then
           echo "VMware(R) Tools are not installed."
           exit 1
         fi
         # check if the RAM memory is reserved
         if vmware-toolbox-cmd stat memres | grep -q "0 MB"; then
           echo "The RAM memory is not reserved on the Virtual Machine."
           exit 1
         fi
       fi
       # check if it's a Microsoft HyperV Hypervisor
       if dmesg |grep -i "Hypervisor detected" | grep -q "Microsoft HyperV"; then
          echo "You are running on a Microsoft HyperV Hypervisor."
       fi
   fi
fi
