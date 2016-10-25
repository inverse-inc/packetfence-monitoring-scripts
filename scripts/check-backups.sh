#!/bin/bash
#fname:check-backups.sh
#as-root

BACKUP_DIR="${BACKUP_DIR:-"/root/backup"}"

BACKUP_CHECK_FILES="${BACKUP_CHECK_FILES:-"1"}"
BACKUP_CHECK_DB_DUMP="${BACKUP_CHECK_DB_DUMP:-"1"}"

ERROR_FILE=`mktemp`
echo "0" > $ERROR_FILE

function check_backups {
  pattern="$1"
  find $BACKUP_DIR -name "$pattern" -ctime -1 -print0 | while IFS= read -r -d $'\0' backup; do
    size=`stat --printf="%s" $backup`
    mtime=`stat --printf="%Y" $backup`
    now=`date +%s`
    # We only check backups that haven't been modified in the last 10 minutes
    # We validate they are greater than 1MB
    if [ $mtime -lt `expr $now - 600` ] && [ $size -lt 1048576 ]; then
      echo "Backup $backup is lower than 1MB. This is not normal."
      echo "1" > $ERROR_FILE
    fi
  done
}

if [ $BACKUP_CHECK_FILES -eq 1 ]; then
  check_backups 'packetfence-files-dump-*'
fi

if [ $BACKUP_CHECK_DB_DUMP -eq 1 ]; then 
  check_backups 'packetfence-db-dump-*'
fi

if [ `cat $ERROR_FILE` -ne 0 ]; then
  echo "One or more backup files are problematic"
  rm $ERROR_FILE
  exit 1
fi

rm $ERROR_FILE

