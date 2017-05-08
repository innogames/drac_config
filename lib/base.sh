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
	iDRAC6)
        tf=$(mktemp)

        echo "[cfgRemoteHosts]" >> $tf

        # iDRAC 6 seems to have no NTP client

        if [ -n "$DEP_SYSLOG1" ] || [ -n "$DEP_SYSLOG2" ]; then
            [ -n "$DEP_SYSLOG1" ] && echo "cfgRhostsSyslogServer1=$DEP_SYSLOG1" >> $tf
            [ -n "$DEP_SYSLOG2" ] && echo "cfgRhostsSyslogServer2=$DEP_SYSLOG2" >> $tf
		    echo "cfgRhostsSyslogEnable=1" >> $tf
        fi

        $racadm config -f $tf
        rm $tf
	;;
	iDRAC[78])
        tf=$(mktemp)

        echo '<SystemConfiguration Model="" ServiceTag="" TimeStamp="">' >> $tf
        echo '<Component FQDD="iDRAC.Embedded.1">' >> $tf

        if [ -n "$DEP_SYSLOG1" ] || [ -n "$DEP_SYSLOG2" ]; then
            echo '<Attribute Name="SysLog.1#SysLogEnable">Disabled</Attribute>' >> $tf
            [ -n "$DEP_SYSLOG1" ] && echo '<Attribute Name="SysLog.1#Server1">'$DEP_SYSLOG1'</Attribute>' >> $tf
            [ -n "$DEP_SYSLOG2" ] && echo '<Attribute Name="SysLog.1#Server1">'$DEP_SYSLOG2'</Attribute>' >> $tf
        fi

        if [ -n "$DEP_NTP1" ] || [ -n "$DEP_NTP2" ]; then
            echo '<Attribute Name="NTPConfigGroup.1#NTPEnable">Enabled</Attribute>' >>  $tf
            [ -n "$DEP_NTP1" ] && echo '<Attribute Name="NTPConfigGroup.1#NTP1">'$DEP_NTP1'</Attribute>' >> $tf
            [ -n "$DEP_NTP2" ] && echo '<Attribute Name="NTPConfigGroup.1#NTP2">'$DEP_NTP2'</Attribute>' >> $tf
        fi
        echo '<Attribute Name="Time.1#TimeZone">'$DEP_TZ'</Attribute>' >> $tf

        echo '</Component>' >> $tf
        echo '</SystemConfiguration>' >> $tf

        $racadm set -f $tf -t xml
        rm $tf
	;;

	*)
		echo "Can not view $host because of its hardware model '$model'!"
	;;
esac

