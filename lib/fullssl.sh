#!/bin/sh

case "$model" in
    M1000e)
        echo "Requesting CSR"
        sh $libdir/requestssl.sh
        echo "Signing CSR"
        $workdir/../ca-utils/scripts/generate_ipmi_cert.sh $host
        echo "Deploying certificate"
        sh $libdir/deployssl.sh
    ;;
    iDRAC[789])
        sh $libdir/deployssl.sh
        $racadm racreset
    ;;
esac
