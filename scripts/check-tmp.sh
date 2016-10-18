#!/bin/bash
#fname:check-tmp.sh

MAX_TMP_FILES="${MAX_TMP_FILES:-"1000"}"

if [ `find /tmp/ depth 1 -type f | wc -l` -gt $MAX_TMP_FILES ] ; then
  echo "There are too much temp files in /tmp"
  exit 1
fi
