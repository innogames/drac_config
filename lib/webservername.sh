#!/bin/sh

# In the case of setting the Webserver name, we must use an IP address, because
# using the hostname always returns a 400 error.
# As the default $racadm already contains the hostname, we must use a custom
# one.
case "$model" in
    iDRAC[89])
        IP=$(getent hosts "$host" | awk '{ print $1 }')
        $RACADM -u ${USER} -p ${PASS} -r $IP set idrac.webserver.ManualDNSEntry "$host"
    ;;
    *)
        echo "This iDRAC model doesn't support setting the Webserver name"
    ;;
esac
