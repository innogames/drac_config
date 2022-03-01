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
    iDRAC[789])
        tf=$(mktemp)
        cat > $tf << EOF
<SystemConfiguration>
<Component FQDD="iDRAC.Embedded.1">
 <Attribute Name="Security.1#CsrCommonName">$host</Attribute>
 <Attribute Name="Security.1#CsrOrganizationName">InnoGames GmbH</Attribute>
 <Attribute Name="Security.1#CsrOrganizationUnit">System Administration</Attribute>
 <Attribute Name="Security.1#CsrLocalityName">Hamburg</Attribute>
 <Attribute Name="Security.1#CsrStateName">Hamburg</Attribute>
 <Attribute Name="Security.1#CsrCountryCode">DE</Attribute>
 <Attribute Name="Security.1#CsrEmailAddr">it@innogames.com</Attribute>
 <Attribute Name="Security.1#CsrKeySize">2048</Attribute>
 <Attribute Name="Security.1#CsrSubjectAltName">$host</Attribute>
</Component>
</SystemConfiguration>
EOF
        $racadm set -f $tf -t xml
        rm $tf
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
