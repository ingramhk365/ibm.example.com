rm -f ~/.ssh/known_hosts
rm -rf ~/.kube
systemctl stop httpd
rm -rf /var/www/html/ocpinstall
rm -rf ~/ocpinstall
mkdir ~/ocpinstall
cp ./install-config.yaml ~/ocpinstall/
/usr/local/bin/openshift-install create manifests --dir ~/ocpinstall/
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/' ~/ocpinstall/manifests/cluster-scheduler-02-config.yml
/usr/local/bin/openshift-install create ignition-configs --dir ~/ocpinstall/
cp -Rp ~/ocpinstall/ /var/www/html/
chcon -R -t httpd_sys_content_t /var/www/html/ocpinstall/
chown -R apache: /var/www/html/ocpinstall/
chmod 755 /var/www/html/ocpinstall/
systemctl start httpd
mkdir ~/.kube
cp ~/ocpinstall/auth/kubeconfig ~/.kube/config
