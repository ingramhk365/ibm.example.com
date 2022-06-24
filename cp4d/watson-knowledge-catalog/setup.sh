cat <<EOF |oc apply -f -
apiVersion: wkc.cpd.ibm.com/v1beta1
kind: WKC
metadata:
  name: wkc-cr
  namespace: ibm-common-services
spec:
  license:
    accept: true
    license: Enterprise
  version: 4.0.3
  storageClass: nfs
    wkc_db2u_set_kernel_params: True
    iis_db2u_set_kernel_params: True
    install_wkc_core_only: true
EOF
