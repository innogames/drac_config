#!/bin/sh

case "$model" in
    iDRAC[789])
        $racadm set System.Power.Hotspare.Enable 0
    ;;
    *)
        echo "Can not change PSU settings on $host because of its hardware model '$model'!"
    ;;
esac

