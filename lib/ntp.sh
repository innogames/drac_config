#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

#$racadm get iDrac.NTPConfigGroup

case "$model" in
	M1000e)
		$racadm config -g cfgRemoteHosts -o cfgRhostsNtpEnable 1
		$racadm config -g cfgRemoteHosts -o cfgRhostsNtpServer1 10.30.0.250
		$racadm config -g cfgRemoteHosts -o cfgRhostsNtpServer2 10.14.0.250
	;;
	iDRAC*)
#cat > /tmp/drac_config_ntp << EOF
#[iDrac.NTPConfigGroup]
#NTP1=10.30.0.250
#NTP2=10.14.0.250
#NTP3=
#NTPEnable=Enabled
#NTPMaxDist=16
#EOF
		$racadm get iDrac.NTPConfigGroup
	;;
	*)
		echo "Can not view $host because of its hardware model '$model'!"
	;;
esac

