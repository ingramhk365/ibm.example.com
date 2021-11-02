oc new-project wordpress
oc project wordpress
oc adm policy add-cluster-role-to-user cluster-admin -z wordpress
oc adm policy add-scc-to-user anyuid -z default
kubectl apply -k ./
oc expose svc/wordpress
