curl -s https://docs.kasten.io/tools/k10_primer.sh | bash

helm repo add kasten https://charts.kasten.io
helm repo list

oc annotate volumesnapshotclass snapshotclass k10.kasten.io/is-snapshot-class=true

#oc new-project kasten-io --description="Kubernetes data management platform" --display-name="Kasten K10"

helm upgrade k10 kasten/k10 --namespace=kasten-io \
--reuse-values \
--set route.enabled=true \
--set auth.basicAuth.enabled=true \
--set auth.basicAuth.htpasswd='ibmadmin:$2y$05$ztUkmBNGTqeJWqJ34AJzE.Ag3hGbO9Dli7J16PwIE1SNvnTSSzHdW' \
--set route.host=k10.apps.ibm.example.com
