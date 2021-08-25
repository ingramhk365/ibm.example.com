dnf install tigervnc-server tigervnc -y

dnf groupinstall "Server with GUI" -y

systemctl set-default graphical.target
systemctl isolate graphical.target

vncpasswd

echo ':1=root' >> /etc/tigervnc/vncserver.users
echo 'geometry=1920x1200' >> /etc/tigervnc/vncserver-config-defaults 
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
firewall-cmd --permanent --add-port 5901/tcp
firewall-cmd --reload
systemctl enable vncserver@:1.service
systemctl start vncserver@:1.service
systemctl status vncserver@:1.service
ss -atp | grep 5901

#echo ':2=jeff' >> /etc/tigervnc/vncserver.users 
#cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:2.service
#firewall-cmd --permanent --add-port 5902/tcp
#firewall-cmd --reload
#systemctl enable vncserver@:2.service
#systemctl start vncserver@:2.service
#systemctl status vncserver@:2.service
#ss -atp | grep 5902

