oc create -f ./rbac.yaml
oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:nfs-client-provisioner:nfs-client-provisioner
oc apply -f ./deployment.yaml
oc apply -f ./class.yaml
