# Create HTPasswd file - users.htpasswd
htpasswd -c -B -b users.htpasswd ibmadmin ibmadmin
htpasswd -B -b users.htpasswd admin1 admin1
htpasswd -B -b users.htpasswd admin2 admin2
htpasswd -B -b users.htpasswd admin3 admin3
htpasswd -B -b users.htpasswd admin4 admin4
htpasswd -B -b users.htpasswd admin5 admin5
#htpasswd -c -B -b users.htpasswd user0 pass0
#htpasswd -B -b users.htpasswd user1 pass1
#htpasswd -B -b users.htpasswd user2 pass2

# Create Secret named httpasswd-secret from File users.htpasswd
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config
#oc get secret -n openshift-config

# Create Identity from Custom Resource Sample File htpasswd.cr
#apiVersion: config.openshift.io/v1
#kind: OAuth
#metadata:
#  name: cluster
#spec:
#  identityProviders:
#    - name: htpasswd_provider
#      mappingMethod: claim
#      type: HTPasswd
#      htpasswd:
#        fileData:
#          name: htpass-secret
oc apply -f htpasswd.cr

# Bind Cluster Admin Role
oc adm policy add-cluster-role-to-user cluster-admin ibmadmin --rolebinding-name=cluster-admin
oc adm policy add-cluster-role-to-user cluster-admin admin1 --rolebinding-name=cluster-admin
oc adm policy add-cluster-role-to-user cluster-admin admin2 --rolebinding-name=cluster-admin
oc adm policy add-cluster-role-to-user cluster-admin admin3 --rolebinding-name=cluster-admin
oc adm policy add-cluster-role-to-user cluster-admin admin4 --rolebinding-name=cluster-admin
oc adm policy add-cluster-role-to-user cluster-admin admin5 --rolebinding-name=cluster-admin
