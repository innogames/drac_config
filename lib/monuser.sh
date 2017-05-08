#!/bin/sh


case "$model" in
	M1000e)
cat > /tmp/drac_config_user << EOF
[iDRAC.Users.${DEP_MONID}]
cfgUserAdminEnable=1
cfgUserAdminIndex=${DEP_MONID}
cfgUserAdminUserName=${DEP_MONUSER}
cfgUserAdminPassword=${DEP_MONPASS}
cfgUserAdminPrivilege=0x0
cfgUserAdminSNMPv3Enable=0
cfgUserAdminSNMPv3AuthenticationType=SHA
cfgUserAdminSNMPv3PrivacyType=AES
EOF
#		$racadm config -g cfgUserAdmin -o cfgUserAdminUserName  -i ${DEP_MONID} ${DEP_MONUSER}
#		$racadm config -g cfgUserAdmin -o cfgUserAdminPassword  -i ${DEP_MONID} ${DEP_MONPASS}
#		$racadm config -g cfgUserAdmin -o cfgUserAdminEnable    -i ${DEP_MONID} 1
#		$racadm config -g cfgUserAdmin -o cfgUserAdminPrivilege -i ${DEP_MONID} 0x00000001
#		$racadm config -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege    -i ${DEP_MONID} 2
#		$racadm config -g cfgUserAdmin -o cfgUserAdminIpmiSerialPrivilege -i ${DEP_MONID} 15
#		$racadm config -g cfgUserAdmin -o cfgUserAdminSolEnable           -i ${DEP_MONID} 0
		$racadm config -f /tmp/drac_config_user
	;;
	iDRAC[78])
cat > /tmp/drac_config_user << EOF
[iDRAC.Users.${DEP_MONID}]
IpmiLanPrivilege=2
Password=${DEP_MONPASS}
Privilege=0x9
SNMPv3Enable=Disabled
UserName=${DEP_MONUSER}
Enable=Enabled
EOF
		$racadm set -f /tmp/drac_config_user
	;;
	iDRAC6)
		$racadm config -g cfgUserAdmin -o cfgUserAdminEnable    -i ${DEP_MONID} 1
		$racadm config -g cfgUserAdmin -o cfgUserAdminUserName  -i ${DEP_MONID} ${DEP_MONUSER}
		$racadm config -g cfgUserAdmin -o cfgUserAdminPassword  -i ${DEP_MONID} ${DEP_MONPASS}
		$racadm config -g cfgUserAdmin -o cfgUserAdminPrivilege -i ${DEP_MONID} 0x00000001
		$racadm config -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege    -i ${DEP_MONID} 2
		$racadm config -g cfgUserAdmin -o cfgUserAdminIpmiSerialPrivilege -i ${DEP_MONID} 15
		$racadm config -g cfgUserAdmin -o cfgUserAdminSolEnable           -i ${DEP_MONID} 0
		;;
	*)
		echo "Can not configure $host because of its hardware model '$model'!"
	;;
esac

