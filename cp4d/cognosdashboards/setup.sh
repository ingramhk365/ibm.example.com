cat <<EOF |oc apply -f -
apiVersion: cde.cpd.ibm.com/v1
kind: CdeProxyService
metadata:
  name: cdeproxyservice-cr
  namespace: ibm-common-services
spec:
  license:
    accept: true
    license: Enterprise
  version: 4.0.2
  storageClass: nfs
EOF
