

# oc annotate volumesnapshotclass <Snapshot Storage Class> k10.kasten.io/is-snapshot-class=true
oc annotate volumesnapshotclass snapshotclass k10.kasten.io/is-snapshot-class=true

# curl https://docs.kasten.io/tools/k10_primer.sh | bash

# oc new-project kasten-io
# helm repo add kasten https://charts.kasten.io
# helm repo update
# helm repo list

# helm install kasten/k10 --name=k10 --namespace=kasten-io

helm upgrade k10 kasten/k10 --namespace=kasten-io \
--reuse-values \
--set route.enabled=true \
--set auth.basicAuth.enabled=true \
--set auth.basicAuth.htpasswd='ibmadmin:$2y$05$ztUkmBNGTqeJWqJ34AJzE.Ag3hGbO9Dli7J16PwIE1SNvnTSSzHdW' \
--set route.host=k10.apps.ibm.example.com

oc -n kasten-io port-forward svc/gateway 8080:8000
