# homelab-sonos-exporter
Docker container to setup SMB exports for sonos v1

Shoutout to https://github.com/dperson/samba where a bunch of inspiration comes from. 

## How To Use

Setup to run on truenas in the application. 

Be sure to include the volume mount. TrueNAS exposes this under "storage". This is much
simpler than an NFS mount.