#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

case "$model" in
    M1000e)
        tf=$(mktemp)

        cat > $tf << EOF
[cfgRemoteHosts]
cfgRhostsNtpEnable=1
cfgRhostsNtpServer1=$DEP_NTP1
cfgRhostsNtpServer2=$DEP_NTP2

cfgRhostsSyslogEnable=1
cfgRhostsSyslogServer1=$DEP_SYSLOG

cfgRhostsSyslogPowerLoggingEnabled=1
cfgRhostsSyslogPowerLoggingInterval=1

[cfgRacTuning]
cfgRacTuneIdracDNSLaunchEnable=1
cfgRacTuneTimezoneOffset=$DEP_TIMEOFFSET
cfgRacTuneDaylightOffset=$DEP_DAYLIGHTOFFSET
cfgRacTuneTLSProtocolVersionEnable=2

[cfgChassisPower]
cfgChassisPowerCapPercent=100 %
cfgChassisPowerCapFPercent=100 %
cfgChassisRedundancyPolicy=1
cfgChassisPerformanceOverRedundancy=0
cfgChassisDynamicPSUEngagementEnable=0

[cfgLanNetworking]
cfgDNSServer1=$DEP_DNS

[cfgOobSnmp]
cfgOobSnmpAgentEnable=0
EOF
        $racadm config -f $tf
        rm $tf
        $racadm setchassisname $host
    ;;
    iDRAC6-*)
        tf=$(mktemp)

    cat > $tf << EOF
[cfgRemoteHosts]
cfgRhostsSyslogEnable=1
cfgRhostsSyslogServer1=$DEP_SYSLOG
EOF
        $racadm config -f $tf
        rm $tf
    ;;
    iDRAC[789])
        tf=$(mktemp)

    cat > $tf << EOF
<SystemConfiguration Model="" ServiceTag="" TimeStamp="">
<Component FQDD="iDRAC.Embedded.1">
<Attribute Name="IPMILan.1#Enable">Enabled</Attribute>
<Attribute Name="IPMILan.1#PrivLimit">Administrator</Attribute>
<Attribute Name="SysLog.1#SysLogEnable">Enabled</Attribute>
<Attribute Name="SysLog.1#Server1">$DEP_SYSLOG</Attribute>
<Attribute Name="NTPConfigGroup.1#NTPEnable">Enabled</Attribute>
<Attribute Name="NTPConfigGroup.1#NTP1">$DEP_NTP1</Attribute>
<Attribute Name="NTPConfigGroup.1#NTP2">$DEP_NTP2</Attribute>
<Attribute Name="Time.1#TimeZone">$DEP_TZ</Attribute>
<Attribute Name="IPv4Static.1#DNS1">$DEP_DNS</Attribute>
<Attribute Name="WebServer.1#Http2Enable">Enabled</Attribute>
<Attribute Name="WebServer.1#LowerEncryptionBitLength">Disable</Attribute>
<Attribute Name="WebServer.1#SSLEncryptionBitLength">256-Bit or higher</Attribute>
<Attribute Name="WebServer.1#TLSProtocol">TLS 1.3 Only</Attribute>
<Attribute Name="WebServer.1#CustomCipherString">ECDH+AESGCM:DH+AESGCM:ECDH+AES256:RSA+AESGCM:RSA+AES:!DH+AES256:CDH+AES128:!DH+AES:!aNULL:!MD5:!DSS</Attribute>
<Attribute Name="SNMP.1#AgentEnable">Enabled</Attribute>
<Attribute Name="SNMP.1#AgentCommunity">$DEP_MONPASS</Attribute>
<Attribute Name="SNMP.1#SNMPProtocol">SNMPv3</Attribute>
<Attribute Name="SSHCrypto.1#Ciphers">aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com</Attribute>
<Attribute Name="SSHCrypto.1#HostKeyAlgorithms">ssh-rsa,rsa-sha2-512,rsa-sha2-256,ecdsa-sha2-nistp256,ssh-ed25519</Attribute>
<Attribute Name="SSHCrypto.1#KexAlgorithms">curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256</Attribute>
<Attribute Name="SSHCrypto.1#MACs">umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512</Attribute>
</Component>
</SystemConfiguration>
EOF
        $racadm set -f $tf -t xml
        rm $tf
    ;;

    *)
        echo "Can not view $host because of its hardware model '$model'!"
    ;;
esac

