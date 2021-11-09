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

# Create Catalog Source - IBM Operator Catalog
# - IBM Cloud Pak foundational services
# - IBM Cloud Pak for Data platform operator
# - Service operators
oc get catalogsource -n openshift-marketplace
oc apply -f ./ibm-operator-catalog.yaml
oc get catalogsource -n openshift-marketplace

# Create Catalog Source - IBM Db2U Catalog
oc get catalogsource -n openshift-marketplace
oc apply -f ./ibm-db2uoperator-catalog.yaml
oc get catalogsource -n openshift-marketplace

# Create Operator Subscription
oc get sub -n ibm-common-services
oc apply -f ./cpd-operator-subscription.yaml
oc get sub -n ibm-common-services
