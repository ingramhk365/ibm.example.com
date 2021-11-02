#oc patch storageclass block -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "false"}}}'
oc patch storageclass nfs -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
