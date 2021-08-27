curl https://raw.githubusercontent.com/IBM/ibm-block-csi-operator/master/deploy/99-ibm-attach.yaml > 99-ibm-attach.yaml
oc apply -f ./99-ibm-sttach.yaml
oc apply -f ./fs5200-secret.yaml
oc apply -f ./fs5200-storageclass.yaml
