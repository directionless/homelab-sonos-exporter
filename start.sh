#!/usr/bin/env bash

HOSTS_ALLOW=${HOSTS_ALLOW:-"127."}
SERVER_STRING=${SERVER_STRING:-"Samba Server"}
MEDIA_MOUNT=${MEDIA_MOUNT:-"/mnt/media"}

sed -e "s|@HOSTS_ALLOW@|${HOSTS_ALLOW}|g" \
    -e "s|@SERVER_STRING@|${SERVER_STRING}|g" \
    -e "s|@MEDIA_MOUNT@|${MEDIA_MOUNT}|g" \
    /etc/samba/smb.conf.template > /etc/samba/smb.conf


# Display some data
echo "ip configuration:"
ip a

echo
echo "Starting Samba"
smbd -F --no-process-group </dev/null