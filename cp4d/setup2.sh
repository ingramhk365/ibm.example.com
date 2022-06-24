# Create project(s)
# Project ibm-common-services 
# - IBM Cloud Pak foundational services (Required)
# - IBM Cloud Pak for Data scheduling service
# - IBM Cloud Pak for Data platform operator (Express Installation)
# - IBM Cloud Pak for Data service operators (Express Intallation)
# Project cpd-operators (Required for Specialized Installation)
# Project cpd-instance
# Project cpd-instance-tether

# For each project
# 1. Operator Group
# 2. Namespace scope
# 3. SCCs - Security Context Contraints

# Create Project 
oc new-project ibm-common-services

# Create Operator Group
oc apply -f ./ibm-common-services-operatorgroup.yaml

# Obtain IBM entitlement API
echo -n "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2MzA1NTA2MzMsImp0aSI6ImZmMTk1NDk0MTViYTRiODc5NDJlZTQ0OGFmZDUwODc5In0.Rtludp3CLaEqtwHBbtyvBmSYUvtxCz4LJTImCuRZskA" | base64 -w0

# Global Image Pull Secret
oc extract secret/pull-secret -n openshift-config --confirm
cp ./.dockerconfigjson ./dockerconfigjson.bak
cp ./dockerconfigjson ./.dockerconfigjson
oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=.dockerconfigjson

# Create IBM Operator Catalog
# - IBM Cloud Pak foundational services
# - IBM Cloud Pak for Data platform operator
oc get catalogsource -n openshift-marketplace
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: "IBM Operator Catalog" 
  publisher: IBM
  sourceType: grpc
  image: icr.io/cpopen/ibm-operator-catalog:latest
  updateStrategy:
    registryPoll:
      interval: 45m
EOF
oc get catalogsource -n openshift-marketplace

# Create Catalog Source - IBM Db2U Catalog
#oc get catalogsource -n openshift-marketplace
#oc apply -f ./ibm-db2uoperator-catalog.yaml
#oc get catalogsource -n openshift-marketplace

# Create Operator Subscription
oc get sub -n ibm-common-services
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cpd-operator
  namespace: ibm-common-services
spec:
  channel: v2.0
  installPlanApproval: Automatic
  name: cpd-platform-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

# While loop to see the two followings
oc get sub -n ibm-common-services cpd-operator -o jsonpath='{.status.installedCSV} {"\n"}'
# Expected Response: cpd-platform-operator.v2.0.4

oc get csv -n ibm-common-services cpd-platform-operator.v2.0.4 -o jsonpath='{.status.phase}:{.status.message} {"\n"}'
# Expected Response: Succeeded:install strategy completed with no errors

oc get deployments -n ibm-common-services -l olm.owner="cpd-platform-operator.v2.0.4" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
# Expected Response: 1

############################
# CRI-O container settings #
############################
#scp core@worker01.ibm.example.com:/etc/crio/crio.conf /tmp/crio.conf

# Edit nofiles and max number of processes
# [crio.runtime]
# default_ulimits = [
#         "nofile=66560:66560"
# ]

# #Maximum number of processes allowed in a container.
# pids_limit=12288

cat << EOF | oc apply -f -
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: worker
  name: 99-worker-cp4d-crio-conf
spec:
  config:
    ignition:
      version: 3.1.0
    storage:
      files:
      - contents:
          source: data:text/plain;charset=utf-8;base64,$(cat /tmp/crio.conf | base64 -w0)
        filesystem: root
        mode: 0644
        path: /etc/crio/crio.conf
EOF

watch oc get nodes

#############################
# Kernel parameter settings #
#############################
cat << EOF | oc apply -f -
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
  name: db2u-kubelet
spec:
  machineConfigPoolSelector:
    matchLabels:
      db2u-kubelet: sysctl
  kubeletConfig:
    allowedUnsafeSysctls:
      - "kernel.msg*"
      - "kernel.shm*"
      - "kernel.sem"
EOF

oc label machineconfigpool worker db2u-kubelet=sysctl

watch oc get machineconfigpool

##############################
# Install Cloud Pak for Data #
##############################

##########################
# Create operand request #
##########################
cat <<EOF |oc apply -f -
apiVersion: operator.ibm.com/v1alpha1
kind: OperandRequest
metadata:
  name: empty-request
  namespace: ibm-common-services
spec:
  requests: []
EOF

###########################################
# Create Custom Resource for  NFS Storage #
###########################################
cat <<EOF |oc apply -f -
apiVersion: cpd.ibm.com/v1
kind: Ibmcpd
metadata:
  name: ibmcpd-cr
  namespace: ibm-common-services
spec:
  license:
    accept: true
    license: Enterprise
  storageClass: nfs
EOF

##############################
# Verifying the installation #
##############################
oc get Ibmcpd ibmcpd-cr -o jsonpath="{.status.controlPlaneStatus}{'\n'}"

##########################
# Check lite-cr is ready #
##########################
oc get ZenService lite-cr -o jsonpath="{.status.zenStatus} {'\n'}"

################################################
# Get the URL of Cloud Pak for Data web client #
################################################
oc get ZenService lite-cr -o jsonpath="{.status.url}{'\n'}"

###############################################
# Get the initial password for the admin user #
###############################################
oc extract secret/admin-user-details --keys=initial_admin_password --to=-
