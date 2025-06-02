#!/usr/bin/env bash

HOSTS_ALLOW=${HOSTS_ALLOW:-"127."}
SERVER_STRING=${SERVER_STRING:-"Samba Server"}
MEDIA_MOUNT=${MEDIA_MOUNT:-"/mnt/media"}


NFS_MOUNT=${NFS_MOUNT:-"unknown"}
NFS_SERVER=$(echo "$NFS_MOUNT" | awk -F: '{print $1}')
NFS_OPTIONS=${NFS_OPTIONS:-"nosuid,nodev,nofail,ro"}

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

header Check NFS Server Connectivity to "${NFS_SERVER}"
ping -c 3 "${NFS_SERVER}" || {
    echo "NFS server ${NFS_SERVER} is unreachable. Exiting."
    exit 1
}

header Mounting NFS Share
mkdir -p "${MEDIA_MOUNT}"
echo "${NFS_MOUNT} ${MEDIA_MOUNT} nfs4 ${NFS_OPTIONS} 0 0" | tee -a /etc/fstab
mount -a || {
    echo "Failed to mount NFS shares. Exiting."
    exit 1
}

header ip a configuration
ip a

header IP Addresses
ip a | grep inet

header Starting Samba
smbd -F --no-process-group </dev/null