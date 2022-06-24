oc create namespace openshift-storage
oc label namespace openshift-storage "openshift.io/cluster-monitoring=true"
oc apply -f ./openshiftstorage-operatorgroup.yaml
oc apply -f ./openshiftstorage-subscription.yaml

oc create namespace openshift-local-storage
oc apply -f ./openshiftlocalstorage-operatorgroup.yaml
oc apply -f ./openshiftlocalstorage-subscription.yaml

oc create -f ./local-disks.yaml


# Create OCS storage cluster

