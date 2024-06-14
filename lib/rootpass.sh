#!/bin/sh


case "$model" in
    M1000e)
        # Root user ID is 1 on CMC.
        $racadm config -g cfgQuickDeploy -o cfgiDRACRootPassword  ${DEP_CHPASS}
        $racadm config -g cfgUserAdmin -o cfgUserAdminPassword  -i 1 ${DEP_CHPASS}
    ;;
    iDRAC[789])
        tf=$(mktemp)
cat > "$tf" << EOF
<SystemConfiguration Model="" ServiceTag="" TimeStamp="">
<Component FQDD="iDRAC.Embedded.1">
<Attribute Name="Users.${DEP_ROOTID}#Password">${DEP_CHPASS}</Attribute>
</Component>
</SystemConfiguration>
EOF
        $racadm set -f "$tf" -t xml
        rm "$tf"
    ;;
    *)
        echo "Can not configure $host because of its hardware model '$model'!"
    ;;
esac

