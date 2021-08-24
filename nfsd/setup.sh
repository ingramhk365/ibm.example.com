#!/bin/bash

dnf install nfs-utils -y

cp ./exports /etc/exports
exportfs -ra

firewall-cmd --add-service=mountd --permanent
firewall-cmd --add-service=rpc-bind --permanent
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload
systemctl start nfs-server rpcbind nfs-mountd
systemctl enable nfs-server
systemctl status nfs-server
