#!/bin/sh

#$racadm set iDrac.Security.CsrKeySize 4096

case "$model" in
	iDRAC6)
        tf=$(mktemp)
        echo "[cfgRacSecurityData]" >> $tf
        echo "cfgRacSecCsrIndex=1" >> $tf
        echo "cfgRacSecCsrCommonName=$host" >> $tf
        $racadm config -f $tf
        rm $tf

        $racadm sslcsrgen -g -f /tmp/$host.req
	;;
esac
