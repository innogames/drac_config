#!/bin/sh

cj=$(mktemp)
jnlp=$(mktemp)
case "$model" in
    iDRAC[78])
        ST1=$(curl --cookie-jar $cj --cookie $cj -s -k --data "user=${USER}&password=${PASS}" https://$host/data/login | sed -E 's/.*ST1=([a-z0-9]+),.*/\1/g')
        curl --cookie-jar $cj --cookie $cj -s -k -o $jnlp "https://$host/viewer.jnlp($host@0@$host@123@ST1=$ST1)'"
        ;;
    *)
        echo "Can not view $host because of its hardware model '$model'!"
     ;;
esac
rm $cj
javaws $jnlp &
