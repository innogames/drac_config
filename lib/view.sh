#!/bin/sh

source=""
case "$model" in
	iDRAC6)
		cookie=`curl -k --data "WEBVAR_USERNAME=${USER}&WEBVAR_PASSWORD=${PASS}&WEBVAR_ISCMCLOGIN=0" https://${host}/Applications/dellUI/RPC/WEBSES/create.asp 2>/dev/null | sed -rn '/SESSION_COOKIE/ s/.*SESSION_COOKIE'\'' : '\''([a-zA-Z0-9]+)'\''.*/\1/p'`
		if [ -z "$cookie" ]; then
			echo "Unable to get login cookie from ${host}"
			exit;
		fi
	curl -s -k --cookie "Cookie=SessionCookie=$cookie" https://${host}/Applications/dellUI/Java/jviewer.jnlp -o /tmp/$host.jnlp
		source=/tmp/$host.jnlp
		useorig=yes
		;;
	iDRAC7)
		source=$libdir/drac7.jnlp
		useorig=no
		;;
	iDRAC8)
		source=$libdir/drac8.jnlp
		useorig=no
		;;
	*)
		echo "Can not view $host because of its hardware model '$model'!"
	 ;;
esac
if [ -n "$source" ]; then
	echo "$host is $model, using $source"
	if [ "$useorig" = "no" ]; then
		sed "s/USER/$USER/; s/PASS/$PASS/; s/IPADDR/${host}/; s/HOSTNAME/$host/;" $source > /tmp/$host.jnlp
	fi
	javaws /tmp/$host.jnlp &
fi

