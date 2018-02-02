#!/bin/sh

cj=$(mktemp)
jnlp=$(mktemp)
case "$model" in
	iDRAC6)
		cookie=$(curl --cookie-jar $cj --cookie $cj -s -k --data "WEBVAR_USERNAME=${USER}&WEBVAR_PASSWORD=${PASS}&WEBVAR_ISCMCLOGIN=0" https://${host}/Applications/dellUI/RPC/WEBSES/create.asp | sed -rn '/SESSION_COOKIE/ s/.*SESSION_COOKIE'\'' : '\''([a-zA-Z0-9]+)'\''.*/\1/p')
		curl --cookie-jar $cj --cookie $cj -s -k -o $jnlp --cookie "Cookie=SessionCookie=$cookie" "https://${host}/Applications/dellUI/Java/jviewer.jnlp"
		;;
	iDRAC[78])
		ST1=$(curl --cookie-jar $cj --cookie $cj -s -k --data "user=${USER}&password=${PASS}" https://$host/data/login | sed -E 's/.*ST1=([a-z0-9]+),.*/\1/g')
		curl --cookie-jar $cj --cookie $cj -s -k -o $jnlp "https://$host/viewer.jnlp($host@0@$host@123@ST1=$ST1)'"
		;;
	*)
		echo "Can not view $host because of its hardware model '$model'!"
	 ;;
esac
rm $cj
#echo $jnlp
#cat $jnlp
javaws $jnlp &
