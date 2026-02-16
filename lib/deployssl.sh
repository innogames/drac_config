#!/bin/sh

CERT_DIR=$(realpath $workdir/../ipmi_certificates)

KEYFILE="${CERT_DIR}/${host}-key.pem"
CERTFILE="${CERT_DIR}/${host}.pem"
CHAINFILE="${CERT_DIR}/${host}-chain.pem"

if ! [ -f "$KEYFILE" ] || ! [ -f "$CERTFILE" ] || ! [ -f "$CHAINFILE" ]; then
    echo "Could not find certificate file for this server!"
    exit 1
fi

case "$model" in
    M1000e)
        $racadm sslcertupload -t 1 -f "$CHAINFILE"
    ;;
    iDRAC6-*)
        # iDRAC6 reboots automatically but does not support chains.
        $racadm sslcertupload -t 1 -f "$CERTFILE"
    ;;
    iDRAC[78])
	# iDRAC 7 and 8 must be rebooted to use the new certificate.
        $racadm sslkeyupload -t  1 -f "$KEYFILE"
        $racadm sslcertupload -t 1 -f "$CHAINFILE"
        $racadm racreset
    ;;
    iDRAC[9])
	# iDRAC does not need to reboot, it reboots its own web server.
        $racadm sslkeyupload -t  1 -f "$KEYFILE"
        $racadm sslcertupload -t 1 -f "$CHAINFILE"
    ;;
esac

