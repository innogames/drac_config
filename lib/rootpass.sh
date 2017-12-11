#!/bin/sh


case "$model" in
	M1000e)
        # Root user ID is 1 on CMC.
		$racadm config -g cfgQuickDeploy -o cfgiDRACRootPassword  ${DEP_CHPASS}
		$racadm config -g cfgUserAdmin -o cfgUserAdminPassword  -i 1 ${DEP_CHPASS}
	;;
	iDRAC[78])
cat > /tmp/drac_config_user << EOF
[iDRAC.Users.${DEP_ROOTID}]
Password=${DEP_CHPASS}
EOF
		$racadm set -f /tmp/drac_config_user
	;;
	iDRAC6)
        echo $racadm
		$racadm config -g cfgUserAdmin -o cfgUserAdminPassword  -i ${DEP_ROOTID} ${DEP_CHPASS}
		;;
	*)
		echo "Can not configure $host because of its hardware model '$model'!"
	;;
esac

