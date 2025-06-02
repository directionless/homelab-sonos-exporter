#!/usr/bin/env bash

set -euo pipefail

HOSTS_ALLOW=${HOSTS_ALLOW:-"127."}
SERVER_STRING=${SERVER_STRING:-"Samba Server"}
MEDIA_MOUNT=${MEDIA_MOUNT:-"/mnt/media"}
SMB_USERS=${SMB_USERS:-""}

function header() {
    echo -e "\n#############################################"
    echo "# $*"
    echo -e "#############################################"
}

header Building Samba Config
sed -e "s|@HOSTS_ALLOW@|${HOSTS_ALLOW}|g" \
    -e "s|@SERVER_STRING@|${SERVER_STRING}|g" \
    -e "s|@MEDIA_MOUNT@|${MEDIA_MOUNT}|g" \
    /etc/samba/smb.conf.template | tee /etc/samba/smb.conf

header Setting Up Users
# Don't use `;` or `:`
echo "$SMB_USERS" | sed 's/;/\n/g' | while read -r USERPASS; do
    user=${USERPASS%:*} # ABCDE
    pass=${USERPASS#*:} # 12345

    if [[ -n "$user" ]]; then
        echo "Adding user: $user"

        adduser -D -H -S -s "/sbin/nologin" "$user"
        echo -e "$pass\n$pass" | smbpasswd -s -a "$user"
    fi
done


header df
df -h

header ip a configuration
ip a

header IP Addresses
ip a | grep inet

header Starting Samba
smbd -F --no-process-group </dev/null