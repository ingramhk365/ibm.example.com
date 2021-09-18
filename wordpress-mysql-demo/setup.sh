oc new-project wordpress
oc project wordpress
oc adm policy add-cluster-role-to-user cluster-admin -z wordpress
oc adm policy add-scc-to-user anyuid -z default
oc apply -f ./
oc expose svc/wordpress
