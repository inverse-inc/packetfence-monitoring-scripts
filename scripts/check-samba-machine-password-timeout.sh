#!/bin/bash
#fname:check-samba-machine-password-timeout.sh

domains=`perl -I/usr/local/pf/lib_perl/lib/perl5 -I/usr/local/pf/lib -Mpf::config -e "print join(' ', keys(%pf::config::ConfigDomain))"`

error=0

for domain in $domains; do
  if ! grep --quiet '^machine password timeout = 0' /etc/samba/$domain.conf; then
    echo "Machine password timeout isn't disabled for $domain"
    error=1
  fi
done

exit $error

