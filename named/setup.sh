#!/bin/bash

dnf install bind bind-utils -y

cp /etc/named.conf /etc/named.conf.bak
cp ./named.conf /etc/named.conf

cp /etc/named.rfc1912.zones /etc/named.rfc1912.zones.bak
cp ./named.rfc1912.zones /etc/named.rfc1912.zones

cp /etc/sysconfig/named /etc/sysconfig/named.bak
cp ./named /etc/sysconfig/named

cp ./named.example.com /var/named/named.example.com
cp ./named.0.122.10 /var/named/named.0.122.10

firewall-cmd --add-port=53/udp --permanent
firewall-cmd --reload
systemctl start named
systemctl enable named
systemctl status named
