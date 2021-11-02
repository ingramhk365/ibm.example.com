oc edit configs.imageregistry.operator.openshift.io

# Original
# spec:
#   logLevel: Normal
#   managementState: Removed
#
# Change to
# spec:
#   logLevel: Normal
#   managementState: Managed

# Original
# spec:
# ...
# ...
#   rolloutStrategy: RollingUpdate
#   storage: {}
#   unsupportedConfigOverrides: null
#
# Change to
# spec:
# ...
# ...
#   rolloutStrategy: RollingUpdate
#   storage:
#     pvc:
#       claim:
#   unsupportedConfigOverrides: null

# oc apply -f ./registry.yaml
# ./ocp-chkregistry.sh
