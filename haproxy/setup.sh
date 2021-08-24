#!/bin/bash

#dnf install haproxy -y

cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
cp ./haproxy.cfg /etc/haproxy/haproxy.cfg

setsebool -P haproxy_connect_any 1

firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=22623/tcp --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-port=9000/tcp --permanent
firewall-cmd --reload
systemctl start haproxy
systemctl enable haproxy
systemctl status haproxy
