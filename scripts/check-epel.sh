#!/bin/bash
#fname:check-epel.sh

if ! [ -z "$(command -v yum)" ]; then
  if yum repolist | grep -i epel > /dev/null; then
    echo "The EPEL repository is enabled. This can cause disastrous issues by having the wrong versions of certain packages installed."
    echo "It is recommended to disable it using the following command:"
    echo "sed -i 's/enabled\s*=\s*1/enabled = 0/g' /etc/yum.repos.d/epel.repo"
    exit 1
  fi
fi

exit 0
