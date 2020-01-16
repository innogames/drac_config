#!/bin/sh

# Please note that racadm returns empty lines and \r on the next line.
# This is why we put each command via tr and awk to get proper strings.

case "$1" in
    "clrsel")
        $racadm clrsel
        ;;
    "getsel")
        $racadm getsel
        ;;
    *)
        echo "Unknown action $1"
    ;;
esac

