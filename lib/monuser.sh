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
		$racadm config -f /tmp/drac_config_user
	;;
	iDRAC[78])
        tf=$(mktemp)
        cat > $tf << EOF
<SystemConfiguration>
<Component FQDD="iDRAC.Embedded.1">
<Attribute Name="IPMILan.1#Enable">Enabled</Attribute>
<Attribute Name="Users.${DEP_MONID}#UserName">${DEP_MONUSER}</Attribute>
<Attribute Name="Users.${DEP_MONID}#Password">${DEP_MONPASS}</Attribute>
<Attribute Name="Users.${DEP_MONID}#Privilege">9</Attribute>
<Attribute Name="Users.${DEP_MONID}#IpmiLanPrivilege">user</Attribute>
<Attribute Name="Users.${DEP_MONID}#Enable">Enabled</Attribute>
<Attribute Name="Users.${DEP_MONID}#SolEnable">Disabled</Attribute>
<Attribute Name="Users.${DEP_MONID}#ProtocolEnable">Disabled</Attribute>
<Attribute Name="Users.${DEP_MONID}#AuthenticationProtocol">SHA</Attribute>
<Attribute Name="Users.${DEP_MONID}#PrivacyProtocol">AES</Attribute>
</Component>
</SystemConfiguration>
EOF
		$racadm set -f $tf -t xml
	;;
	iDRAC6)
		$racadm config -g cfgIpmiLan -o cfgIpmiLanEnable 1
		$racadm config -g cfgUserAdmin -o cfgUserAdminEnable    -i ${DEP_MONID} 1
		$racadm config -g cfgUserAdmin -o cfgUserAdminUserName  -i ${DEP_MONID} ${DEP_MONUSER}
		$racadm config -g cfgUserAdmin -o cfgUserAdminPassword  -i ${DEP_MONID} ${DEP_MONPASS}
		$racadm config -g cfgUserAdmin -o cfgUserAdminPrivilege -i ${DEP_MONID} 0x00000000
		$racadm config -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege    -i ${DEP_MONID} 2
		$racadm config -g cfgUserAdmin -o cfgUserAdminSolEnable -i ${DEP_MONID} 0
		$racadm config -g cfgUserAdmin -o cfgUserAdminSolEnable           -i ${DEP_MONID} 0
		;;
	*)
		echo "Can not configure $host because of its hardware model '$model'!"
	;;
esac

