#!/bin/sh

certdir="${workdir}/../ipmi_certificates/"

KEYFILE="${certdir}/${host}-key.pem"
CERTFILE="${certdir}/${host}.pem"
CHAINFILE="${certdir}/${host}-chain.pem"

if ! [ -f "$CERTFILE" ]; then
    echo "Could not find certificate file for this server!"
    exit 1
fi

case "$model" in
    M1000e)
        $racadm sslcertupload -t 1 -f "$CHAINFILE"
    ;;
    iDRAC[789])
        $racadm sslkeyupload -t  1 -f "$KEYFILE"
        $racadm sslcertupload -t 1 -f "$CHAINFILE"
    ;;
esac

