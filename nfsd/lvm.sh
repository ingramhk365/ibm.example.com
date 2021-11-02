pvcreate /dev/sdb
vgcreate nfs /dev/sdb
lvcreate -L 200G -n registry nfs
lvcreate -L 800G -n nfsshare nfs
mkfs.xfs /dev/nfs/registry
mkfs.xfs /dev/nfs/nfsshare
mkdir /registry
mkdir /nfsshare
echo '/dev/mapper/nfs-registry /registry xfs defaults 0 0' >> /etc/fstab
echo '/dev/mapper/nfs-nfsshare /nfsshare xfs defaults 0 0' >> /etc/fstab
mount /registry
mount /nfsshare
chown -R nobody:nobody /registry
chown -R nobody:nobody /nfsshare
chmod -R 777 /registry
chmod -R 777 /nfsshare
