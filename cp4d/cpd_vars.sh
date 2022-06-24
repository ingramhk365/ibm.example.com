#===============================================================================
# Cloud Pak for Data installation variables
#===============================================================================

# ------------------------------------------------------------------------------
# Cluster variables
# ------------------------------------------------------------------------------

export OCP_URL=https://ibm.example.com:8443


# ------------------------------------------------------------------------------
# Project variables
# ------------------------------------------------------------------------------

export PROJECT_CPFS_OPS=ibm-common-services        
export PROJECT_CPD_OPS=cpd-operators
export PROJECT_CATSRC=openshift-marketplace
export PROJECT_CPD_INSTANCE=cpd-instance
export PROJECT_TETHERED=cpd-instance-tether


# ------------------------------------------------------------------------------
# Operator installation variables
# ------------------------------------------------------------------------------

export APPROVAL_TYPE=Automatic


# ------------------------------------------------------------------------------
# Licenses variables
# ------------------------------------------------------------------------------

export LICENSE_CPD=Enterprise

# ------------------------------------------------------------------------------
# IBM Entitled Registry variables
# ------------------------------------------------------------------------------

export IBM_ENTITLEMENT_KEY=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2MzA1NTA2MzMsImp0aSI6ImZmMTk1NDk0MTViYTRiODc5NDJlZTQ0OGFmZDUwODc5In0.Rtludp3CLaEqtwHBbtyvBmSYUvtxCz4LJTImCuRZskA
export IBM_ENTITLEMENT_USER=cp
export IBM_ENTITLEMENT_SERVER=cp.icr.io


# ------------------------------------------------------------------------------
# CASE package management variables
# ------------------------------------------------------------------------------

export OFFLINEDIR_CPD=$HOME/offline/cpd
export OFFLINEDIR_CPFS=$HOME/offline/cpfs
export PATH_CASE_REPO=https://github.com/IBM/cloud-pak/raw/master/repo/case
export USE_SKOPEO=true


# ------------------------------------------------------------------------------
# Private container registry variables
# ------------------------------------------------------------------------------
# Set the following variables if you mirror images to a private container registry.
#
# To export these variables, you must uncomment each command in this section.

# export PRIVATE_REGISTRY_LOCATION=<enter the location of your private container registry>
# export PRIVATE_REGISTRY_PUSH_USER=<enter the username of a user that can push to the registry>
# export PRIVATE_REGISTRY_PUSH_PASSWORD=<enter the password of the user that can push to the registry>
# export PRIVATE_REGISTRY_PULL_USER=<enter the username of a user that can pull from the registry>
# export PRIVATE_REGISTRY_PULL_PASSWORD=<enter the password of the user that can pull from the registry>


# ------------------------------------------------------------------------------
# Intermediary container registry variables
# ------------------------------------------------------------------------------
# Set the following variables if you use an intermediary container registry to
# mirror images to your private container registry.
#
# To export these variables, you must uncomment each command in this section.

# export INTERMEDIARY_REGISTRY_HOST=localhost
# export INTERMEDIARY_REGISTRY_PORT=<enter the port to use on the localhost>
# INTERMEDIARY_REGISTRY_LOCATION="${INTERMEDIARY_REGISTRY_HOST}:${INTERMEDIARY_REGISTRY_PORT}"
# export INTERMEDIARY_REGISTRY_LOCATION
# export INTERMEDIARY_REGISTRY_USER=<enter the username to authenticate to the registry>
# export INTERMEDIARY_REGISTRY_PASSWORD=<enter the password for the user>
