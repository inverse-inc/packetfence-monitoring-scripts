#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Signing all script in : $DIR"

find $DIR -type f ! -name '*.sig' -exec gpg -u 0xE3A28334 --batch --yes --passphrase-file /root/gpg-monit-passphrase --output {}.sig --sign {} \;

