#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

#$racadm get iDrac.NTPConfigGroup

case "$model" in
	M1000e)
        tf=$(mktemp)

        echo "[cfgRemoteHosts]" >> $tf

        if [ -n "$DEP_NTP1" ] || [ -n "$DEP_NTP2" ]; then
            [ -n "$DEP_NTP1" ] && echo "cfgRhostsNtpServer1=$DEP_NTP1" >> $tf
            [ -n "$DEP_NTP2" ] && echo "cfgRhostsNtpServer2=$DEP_NTP2" >> $tf
            echo "cfgRhostsNtpEnable=1" >> $tf
        fi

        if [ -n "$DEP_SYSLOG1" ] || [ -n "$DEP_SYSLOG2" ]; then
            [ -n "$DEP_SYSLOG1" ] && echo "cfgRhostsSyslogServer1=$DEP_SYSLOG1" >> $tf
            [ -n "$DEP_SYSLOG2" ] && echo "cfgRhostsSyslogServer2=$DEP_SYSLOG2" >> $tf
		    echo "cfgRhostsSyslogEnable=1" >> $tf
        fi

        echo "[cfgRacTuning]" >> $tf
        echo "cfgRacTuneTimezoneOffset=$DEP_TIMEOFFSET" >> $tf
        echo "cfgRacTuneDaylightOffset=$DEP_DAYLIGHTOFFSET" >> $tf

        $racadm config -f $tf
        rm $tf
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

