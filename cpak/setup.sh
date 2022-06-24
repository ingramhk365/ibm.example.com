#######################
# Creating project(s) #
#######################
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

# Create Projects 
oc new-project ibm-common-services
oc new-project cpd-operators
oc new-project cpd-instance
oc new-project cpd-instance-tether


#########################################################################
# Create operator group for IBM Cloud Pak foundational services project #
#########################################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: operatorgroup
  namespace: ibm-common-services
spec:
  targetNamespaces:
  - ibm-common-services
EOF

################
# Verification #
################
oc get operatorgroup -n ibm-common-services
#######################
# Expected Result     #
# NAME            AGE #
# operatorgroup   30s #
#######################


##############################################################################
# Create operator group for IBM Cloud Pak for Data platform operator project #
##############################################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: operatorgroup
  namespace: cpd-operators
spec:
  targetNamespaces:
  - cpd-operators
EOF

################
# Verification #
################
oc get operatorgroup -n cpd-operators
#######################
# Expected Result     #
# NAME            AGE #
# operatorgroup   33s #
#######################

##############################
# Obtain IBM entitlement API #
##############################
echo -n "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2MzA1NTA2MzMsImp0aSI6ImZmMTk1NDk0MTViYTRiODc5NDJlZTQ0OGFmZDUwODc5In0.Rtludp3CLaEqtwHBbtyvBmSYUvtxCz4LJTImCuRZskA" | base64 -w0

############################
# Global Image Pull Secret #
############################
oc extract secret/pull-secret -n openshift-config --confirm
cp ./.dockerconfigjson ./dockerconfigjson.bak
cp ./dockerconfigjson ./.dockerconfigjson
oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=.dockerconfigjson


###############################
# Create IBM Operator Catalog #
###############################
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

################
# Verification #
################
oc get catalogsource -n openshift-marketplace | grep ibm-operator-catalog
############################################################################
# Expected Result                                                          #
# ibm-operator-catalog       IBM Operator Catalog   grpc   IBM         20s #
############################################################################


############################################
# Create Catalog Source - IBM Db2U Catalog #
############################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-db2uoperator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: docker.io/ibmcom/ibm-db2uoperator-catalog:latest
  imagePullPolicy: Always
  displayName: IBM Db2U Catalog
  publisher: IBM
  updateStrategy:
    registryPoll:
      interval: 45m
EOF

################
# Verification #
################
oc get catalogsource -n openshift-marketplace | grep ibm-db2uoperator-catalog
############################################################################
# Expected Result                                                          #
# ibm-db2uoperator-catalog   IBM Db2U Catalog       grpc   IBM         16s #
############################################################################

oc get catalogsource -n openshift-marketplace ibm-db2uoperator-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
###################
# Expected result #
# READY           #
###################



################################
# Create Operator Subscription #
################################
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

################
# Verification #
################
oc --namespace ibm-common-services get csv
############################################################################################################################################################
# Expected Result                                                                                                                                          #
# NAME                                           DISPLAY                                VERSION   REPLACES                                       PHASE     #
# cpd-platform-operator.v2.0.4                   Cloud Pak for Data Platform Operator   2.0.4                                                    Succeeded #
# ibm-common-service-operator.v3.13.0            IBM Cloud Pak foundational services    3.13.0    ibm-common-service-operator.v3.12.0            Succeeded #
# ibm-namespace-scope-operator.v1.7.0            IBM NamespaceScope Operator            1.7.0     ibm-namespace-scope-operator.v1.6.0            Succeeded #
# operand-deployment-lifecycle-manager.v1.11.0   Operand Deployment Lifecycle Manager   1.11.0    operand-deployment-lifecycle-manager.v1.10.0   Succeeded #
############################################################################################################################################################

oc get crd | grep operandrequest
##########################################################################################
# Expected Result                                                                        #
# operandrequests.operator.ibm.com                                  2021-11-30T08:42:51Z #
##########################################################################################

oc api-resources --api-group operator.ibm.com
#############################################################################################
# Expected Result                                                                           #
# NAME                SHORTNAMES   APIVERSION                  NAMESPACED   KIND            #
# commonservices                   operator.ibm.com/v3         true         CommonService   #
# namespacescopes     nss          operator.ibm.com/v1         true         NamespaceScope  #
# operandbindinfos    opbi         operator.ibm.com/v1alpha1   true         OperandBindInfo #
# operandconfigs      opcon        operator.ibm.com/v1alpha1   true         OperandConfig   #
# operandregistries   opreg        operator.ibm.com/v1alpha1   true         OperandRegistry #
# operandrequests     opreq        operator.ibm.com/v1alpha1   true         OperandRequest  #
# podpresets                       operator.ibm.com/v1alpha1   true         PodPreset       #
#############################################################################################


#######################################################
# Create operator subscription for scheduling service #
#######################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-scheduling-catalog-subscription
  namespace: ibm-common-services
spec:
  channel: v1.2
  installPlanApproval: Automatic
  name: ibm-cpd-scheduling-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

################
# Verification #
################
oc get sub -n ibm-common-services ibm-cpd-scheduling-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
######################################
# Expected result                    #
# ibm-cpd-scheduling-operator.v1.2.3 #
######################################

oc get csv -n ibm-common-services ibm-cpd-scheduling-operator.v1.2.3 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
#########################################################
# Expected result                                       #
# Succeeded : install strategy completed with no errors #
#########################################################

oc get deployments -n ibm-common-services -l olm.owner="ibm-cpd-scheduling-operator.v1.2.3" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
###################
# Expected result #
# 1               #
###################


#############################################################################
# Create operator subscription for IBM Cloud Pak for Data platform operator #
#############################################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cpd-operator
  namespace: cpd-operators
spec:
  channel: v2.0
  installPlanApproval: Automatic
  name: cpd-platform-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

################################################################
# Create operator subscription for IBM NamespaceScope Operator #
################################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-namespace-scope-operator
  namespace: cpd-operators
spec:
  channel: v3
  installPlanApproval: Automatic
  name: ibm-namespace-scope-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

################
# Verification #
################
oc get sub -n cpd-operators cpd-operator -o jsonpath='{.status.installedCSV} {"\n"}'
################################
# Expected result              #
# cpd-platform-operator.v2.0.4 #
################################

oc get csv -n cpd-operators cpd-platform-operator.v2.0.4 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
#########################################################
# Expected result                                       #
# Succeeded : install strategy completed with no errors # 
#########################################################

oc get deployments -n cpd-operators -l olm.owner="cpd-platform-operator.v2.0.4" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
###################
# Expected result #
# 1               #
###################


#########################################################################
# Enabling services to use namespace scoping with third-party operators #
#########################################################################
cat <<EOF |oc apply -f -
apiVersion: operator.ibm.com/v1
kind: NamespaceScope
metadata:
  name: cpd-operators
  namespace: cpd-operators
spec:
  csvInjector:
    enable: true
  namespaceMembers:
  - cpd-operators
EOF

########################################################
# Create operator subscription for Data Virtualization #
########################################################
### Old version? ###
#cat <<EOF |oc apply -f -
#apiVersion: operators.coreos.com/v1alpha1
#kind: Subscription
#metadata:
#  name: ibm-db2u-operator
#  namespace: cpd-operators
#spec:
#  channel: v1.1
#  name: db2u-operator
#  installPlanApproval: Automatic
#  source: ibm-operator-catalog
#  sourceNamespace: openshift-marketplace
#EOF
####################
# Old Verification #
####################
oc get sub -n cpd-operators ibm-db2u-operator -o jsonpath='{.status.installedCSV} {"\n"}'
########################
# Expected result      # 
# db2u-operator.v1.1.6 #
########################

#oc get csv -n cpd-operators db2u-operator.v1.1.6 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
#oc get deployments -n cpd-operators -l olm.owner="db2u-operator.v1.1.6" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"


### New version? ###
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-dv-operator-catalog-subscription
  namespace: cpd-operators
spec:
  channel: v1.7
  installPlanApproval: Automatic
  name: ibm-dv-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

################
# Verification #
################
oc get sub -n cpd-operators ibm-dv-operator-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
##########################
# Expected result        # 
# ibm-dv-operator.v1.7.3 #
##########################

oc get csv -n cpd-operators ibm-dv-operator.v1.7.3 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
#########################################################
# Expected result                                       # 
# Succeeded : install strategy completed with no errors #
#########################################################

oc get deployments -n cpd-operators -l olm.owner="ibm-dv-operator.v1.7.3" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
###################
# Expected result # 
# 1               #
###################


##################################################
# Create operator subscription for Watson Studio #
##################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  annotations:
  name: ibm-cpd-ws-operator-catalog-subscription
  namespace: cpd-operators
spec:
  channel: v2.0
  installPlanApproval: Automatic
  name: ibm-cpd-wsl
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

################
# Verification #
################
oc get sub -n cpd-operators ibm-cpd-ws-operator-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
######################
# Expected result    #
# ibm-cpd-wsl.v2.0.2 #
######################

oc get csv -n cpd-operators ibm-cpd-wsl.v2.0.2 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
#########################################################
# Expected result                                       #
# Succeeded : install strategy completed with no errors #
#########################################################

oc get deployments -n cpd-operators -l olm.owner="ibm-cpd-wsl.v2.0.2" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
###################
# Expected result #
# 1               #
###################


######################################################
# Create operator subscription for Cognos Dashboards #
######################################################
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  labels:
    app.kubernetes.io/instance: ibm-cde-operator-subscription
    app.kubernetes.io/managed-by: ibm-cde-operator
    app.kubernetes.io/name: ibm-cde-operator-subscription
  name: ibm-cde-operator-subscription
  namespace: cpd-operators
spec:
  channel: v1.0
  installPlanApproval: Automatic
  name: ibm-cde-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

oc get sub -n cpd-operators ibm-cde-operator-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
####################
# Expected result  #
ibm-cpd-cde.v1.0.3 #
####################


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


cat <<EOF |oc apply -f -
apiVersion: operator.ibm.com/v1
kind: NamespaceScope
metadata:
  name: cpd-operators
  namespace: cpd-operators
spec:
  csvInjector:
    enable: true
  namespaceMembers:
  - cpd-operators
  - cpd-instance
EOF


cat <<EOF |oc apply -f -
apiVersion: cpd.ibm.com/v1
kind: Ibmcpd
metadata:
  name: ibmcpd-cr
  namespace: cpd-instance
spec:
  license:
    accept: true
    license: Standard
  storageClass: nfs
EOF

oc get Ibmcpd ibmcpd-cr -o jsonpath="{.status.controlPlaneStatus}{'\n'}"

oc get ZenService lite-cr -o jsonpath="{.status.zenStatus}{'\n'}"

oc get ZenService lite-cr -o jsonpath="{.status.url}{'\n'}"

oc extract secret/admin-user-details --keys=initial_admin_password --to=-

cat <<EOF |oc apply -f -
apiVersion: db2u.databases.ibm.com/v1
kind: DvService
metadata:
  name: dv-service
  namespace: cpd-instance
spec:
  license:
    accept: true
    license: Standard
  version: 1.7.3
  size: "small"
EOF
