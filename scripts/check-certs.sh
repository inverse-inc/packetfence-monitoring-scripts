#!/bin/bash
#fname:check-certs.sh

# Will raise alert if certificate is no longer valid is less than a week (7 days)
VALIDITY_THRESHOLD=7
CERTS=()    # Will hold "due to expire" certificates

# RADIUS certificates
# Checks for 'certificate_file =' in '/usr/local/pf/raddb/mods-enabled/eap'
files=($(awk '/certificate_file =/{print substr($0, index($0,$3))}' /usr/local/pf/raddb/mods-enabled/eap))

# HTTPd certificates
# Checks for 'SSLCertificateFile' in '/usr/local/pf/var/conf/ssl-certificates.conf'
files+=($(awk '/SSLCertificateFile/{print substr($0, index($0,$2))}' /usr/local/pf/var/conf/ssl-certificates.conf))

# Check for validity
for i in "${files[@]}"
do
    enddate=$(cat $i | openssl x509 -noout -enddate)    # Get SSL certificate end date (notAfter=Oct 28 12:34:42 2034 GMT)
    enddate=${enddate//notAfter=}                       # Remove the "notAfter=" part
    enddate=$(date -d "$enddate" +%s)                   # Convert to unix timestamp

    currentdate=$(date +%s)                             # Get current date (unix timestamp format)
    daysofdifference=$((enddate-currentdate))           # Get unix timestamp difference of two dates
    daysofdifference=$(( daysofdifference / 86400 ))    # Convert difference to days (86400 seconds)

    if [ "$daysofdifference" -lt "$VALIDITY_THRESHOLD" ]; then
        CERTS+=($i)
    fi
done

# Alert if needed
if [ ${#CERTS[@]} -ne 0 ]; then
    for i in "${CERTS[@]}"
    do
        echo "Certificate '$i' is due to expire in less than '$VALIDITY_THRESHOLD' days."
    done
    exit 1
fi
