#oc patch storageclass block -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "false"}}}'
oc patch storageclass ocs-storagecluster-cephfs -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
