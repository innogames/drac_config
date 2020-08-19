#!/bin/sh

case "$model" in
    iDRAC[789])
        $racadm set iDRAC.IPMILan.Enable 1
        $racadm set iDRAC.IPMILan.PrivLimit 4
    ;;
    *)
        echo "Can not change IPMI settings on $host because of its hardware model '$model'!"
    ;;
esac

