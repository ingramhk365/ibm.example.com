curl https://raw.githubusercontent.com/IBM/ibm-block-csi-operator/master/deploy/99-ibm-attach.yaml > 99-ibm-attach.yaml
oc new-project ibm-block-csi
oc apply -f ./99-ibm-sttach.yaml
oc apply -f ./fs5200-secret.yaml
oc apply -f ./fs5200-storageclass.yaml

# For Snapshot
oc apply -f ./fs5200-volumesnapshotclass.yaml
oc create -f ./crd
oc create -f ./snapshot-controller
