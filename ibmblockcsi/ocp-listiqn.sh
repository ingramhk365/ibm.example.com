NODES=$(oc get node -o name)
for node in $NODES; do oc debug $node -- chroot /host cat /etc/iscsi/initiatorname.iscsi; 
done
