#!/bin/bash
#fname:check-domain-join.sh
#as-root

error=0

# by default, we check domain in chroot
CHECK_CHROOT_JOIN="${CHECK_CHROOT_JOIN:-"1"}"
CHECK_SYSTEM_JOIN="${CHECK_SYSTEM_JOIN:-"0"}"

function check_domain_join_in_chroot {
    domains=$(perl -I/usr/local/pf/lib -Mpf::config -e "print join(' ', keys(%pf::config::ConfigDomain))")
    for domain in $domains; do
        /sbin/ip netns exec $domain /usr/sbin/chroot /chroots/$domain wbinfo -t > /dev/null 2>&1
        rc=$?
        # check return code of wbinfo -t
        if [ "$rc" -ne 0 ]; then
            echo "$domain domain: wbinfo -t failed";
            error=1
        fi
    done
}

# if we check directly on OS, there is only one domain
function check_domain_join {
        wbinfo -t > /dev/null 2>&1
        rc=$?
        # check return code of wbinfo -t
        if [ "$rc" -ne 0 ]; then
            echo "$domain domain: wbinfo -t failed";
            error=1
        fi
}

if [ "$CHECK_CHROOT_JOIN" -eq 1 ]; then
  check_domain_join_in_chroot
fi

if [ "$CHECK_SYSTEM_JOIN" -eq 1 ]; then
  check_domain_join
fi

exit $error
