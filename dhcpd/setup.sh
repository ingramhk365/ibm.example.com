#!/bin/bash

dnf install dhcp-server -y 

cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
cp ./dhcpd.conf /etc/dhcp/dhcpd.conf

firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload
systemctl start dhcpd
systemctl enable dhcpd
systemctl status dhcpd
