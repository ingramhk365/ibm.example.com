oc patch storageclass gold -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "false"}}}'
oc patch storageclass bronze -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
