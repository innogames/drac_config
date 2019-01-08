#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

#$racadm get iDrac.NTPConfigGroup

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

[cfgRacTuning]
cfgRacTuneIdracDNSLaunchEnable=1
cfgRacTuneTimezoneOffset=$DEP_TIMEOFFSET
cfgRacTuneDaylightOffset=$DEP_DAYLIGHTOFFSET
EOF
        $racadm config -f $tf
        rm $tf
	;;
	iDRAC6)
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
<Attribute Name="SysLog.1#SysLogEnable">Disabled</Attribute>
<Attribute Name="SysLog.1#Server1">$DEP_SYSLOG</Attribute>
<Attribute Name="NTPConfigGroup.1#NTPEnable">Enabled</Attribute>
<Attribute Name="NTPConfigGroup.1#NTP1">$DEP_NTP1</Attribute>
<Attribute Name="NTPConfigGroup.1#NTP2">$DEP_NTP2</Attribute>
<Attribute Name="Time.1#TimeZone">$DEP_TZ</Attribute>
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

