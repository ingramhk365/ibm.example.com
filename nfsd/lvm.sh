pvcreate /dev/sdb
vgcreate nfs /dev/sdb
lvcreate -L 149G -n nfsshare nfs
mkfs.xfs /dev/nfs/nfsshare
mkdir /nfsshare
mkdir /nfsshare/registry
mount /nfs-nfsshare /nfsshare
chown -R nobody:nobody /nfsshare
chmod -R 777 /nfsshare
