#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

if ! ( [ "$model" = "iDRAC7" ] || [ "$model" = "iDRAC8" ] ); then
	echo "Raid configuration possible only on PowerEdge [RM]6[23]0 (or rather iDRAC [78])."
	exit 1
fi

CONTROLLER=`$racadm raid get controllers | tr -d '\r' | grep RAID.Integrated | head -n1 | awk '{print $1}'`
if [ -z "$CONTROLLER" ]; then
	echo "No RAID controller found"
	exit 1
fi

if $racadm jobqueue view | tr -d '\r' | awk '/Job Name=Configure: RAID/{tmp=$0;}; /Status=/{print tmp": "$0}' | grep -vE 'Completed|Failed'; then
	echo "There are pending jobs on controller"
	exit 1
fi

if [ "$1" = "deleteraid" ]; then
	VDISKS=`$racadm raid get vdisks | tr -d '\r' | grep 'Disk.Virtual' | awk '{print $1}'`
	if [ -n "$VDISKS" ]; then
		echo "RAID already exists, deleting it"
		for VDISK in $VDISKS; do
			echo "Parsing existing vdisk -$VDISK- on -$CONTROLLER-"
			$racadm raid deletevd:$VDISK
			$racadm jobqueue create $CONTROLLER -r forced
		done
		exit
	else
		echo "No RAID to delete"
		exit
	fi


fi

if [ "$1" = "createraid" ]; then
	VDISKS=`$racadm raid get vdisks | tr -d '\r' | grep 'Disk.Virtual' | awk '{print $1}'`
	if [ -n "$VDISKS" ]; then
		echo "The following RAIDs already exist:"
		for VDISK in $VDISKS; do
			echo $VDISK
		done
		exit
	fi

	PDISKS=`$racadm raid get pdisks -o -p state | tr -d '\r' | awk '$1 ~ /^Disk/ { D=$1 }; /Non-Raid/ { print D }'`
	for PDISK in $PDISKS; do
		echo "Converting $PDISK to RAID"
		$racadm raid converttoraid:$PDISK
		PDKEY="$PDISK,${PDKEY}"
	done

	PDISKS=`$racadm raid get pdisks -o -p state | tr -d '\r' | awk '$1 ~ /^Disk/ { D=$1 }; /Ready/ { print D }'`
	for PDISK in $PDISKS; do
		echo "Adding $PDISK to RAID"
		PDKEY="$PDISK,${PDKEY}"
	done

	PDKEY=`echo $PDKEY | head -c -2`
	if [ -z "$PDKEY" ]; then
		echo "No disks were found, not creating RAID"
		exit 1
	fi

	$racadm raid createvd:$CONTROLLER -rl r1 -pdkey:$PDKEY
	$racadm jobqueue create RAID.Integrated.1-1 -r forced
fi

