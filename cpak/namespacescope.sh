cat <<EOF |oc apply -f -
apiVersion: operator.ibm.com/v1
kind: NamespaceScope
metadata:
  name: cpd-operators
#  namespace: cpd-operators        # (Default) Replace with the Cloud Pak for Data platform operator project name 
  namespace: ibm-common-services
spec:
  csvInjector:
    enable: true
  namespaceMembers:
#  - cpd-operators                 # (Default) Replace with the Cloud Pak for Data platform operator project name
#  - cpd-instance                  # Replace with the project where you will install Cloud Pak for Data
  - ibm-common-services
EOF
