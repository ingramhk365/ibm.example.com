#!/bin/bash

dnf install httpd -y

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
cp ./httpd.conf /etc/httpd/conf/httpd.conf

firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload
systemctl start httpd
systemctl enable httpd
systemctl status httpd
