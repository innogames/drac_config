#!/bin/sh

certdir="${workdir}/../ca-utils/ipmi_certificates/"

if [ -f "${certdir}/${host}_csr.pem" ]; then
    echo "CSR for this server already exists"
    exit 0
fi

case "$model" in
    M1000e)
        echo "host is $host"
    tf=$(mktemp)
    cat << EOF > $tf
[cfgRacSecurity]
cfgRacSecCsrKeySize=2048
cfgRacSecCsrCommonName=$host
cfgRacSecCsrOrganizationName=InnoGames GmbH
cfgRacSecCsrOrganizationUnit=System Administration
cfgRacSecCsrLocalityName=Hamburg
cfgRacSecCsrStateName=Hamburg
cfgRacSecCsrCountryCode=DE
cfgRacSecCsrEmailAddr=it@innogames.com
EOF
    $racadm config -f $tf
    rm $tf
    # Generation always "fails" but the file is generated
    # and can be later downloaded.
    $racadm sslcsrgen -g
    $racadm sslcsrgen -f "${certdir}/${host}_csr.pem"
    ;;
    iDRAC6-blade)
    tf=$(mktemp)
    cat << EOF > $tf
[cfgRacSecurityData]
cfgRacSecCsrIndex=1
cfgRacSecCsrKeySize=2048
cfgRacSecCsrCommonName=$host
cfgRacSecCsrOrganizationName=InnoGames GmbH
cfgRacSecCsrOrganizationUnit=System Administration
cfgRacSecCsrLocalityName=Hamburg
cfgRacSecCsrStateName=Hamburg
cfgRacSecCsrCountryCode=DE
cfgRacSecCsrEmailAddr=it@innogames.com
EOF
    $racadm config -f $tf
    rm $tf
    $racadm sslcsrgen -g
    $racadm sslcsrgen -f "${certdir}/${host}_csr.pem"
    ;;
    iDRAC6-standalone)
    tf=$(mktemp)
    cat << EOF > $tf
[cfgRacSecurity]
cfgRacSecCsrKeySize=2048
cfgRacSecCsrCommonName=$host
cfgRacSecCsrOrganizationName=InnoGames GmbH
cfgRacSecCsrOrganizationUnit=System Administration
cfgRacSecCsrLocalityName=Hamburg
cfgRacSecCsrStateName=Hamburg
cfgRacSecCsrCountryCode=DE
cfgRacSecCsrEmailAddr=it@innogames.com
EOF
    $racadm config -f $tf
    rm $tf
    $racadm sslcsrgen -g
    sleep 60 # This shit takes a lot of time
    $racadm sslcsrgen -f "${certdir}/${host}_csr.pem"
    ;;
    *)
        echo "This iDRAC version can work with uploaded keys, no need for CSR"
    ;;
esac
