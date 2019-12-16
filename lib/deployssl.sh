#!/bin/sh

certdir="${workdir}/../ca-utils/ipmi_certificates/"

KEYFILE="${certdir}/${host}_key.pem"
CERTFILE="${certdir}/${host}_cert.pem"
CHAINFILE="${certdir}/${host}_cert_chain.pem"

if ! [ -f "$CERTFILE" ]; then
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
	iDRAC[789])
		$racadm sslkeyupload -t  1 -f "$KEYFILE"
		$racadm sslcertupload -t 1 -f "$CHAINFILE"
		$racadm racreset
	;;
esac

