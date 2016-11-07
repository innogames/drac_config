#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

#$racadm get iDrac.NTPConfigGroup

case "$model" in
	iDRAC[78])
		$racadm set iDRAC.VirtualConsole.AccessPrivilege "Full Access" 
	;;
	*)
		echo "Can not view $host because of its hardware model '$model'!"
	;;
esac

