# Create HTPasswd file - users.htpasswd
# htpasswd -c -B -b users.htpasswd user0 pass0
# htpasswd -B -b users.htpasswd user1 pass1
# htpasswd -B -b users.htpasswd user2 pass2
htpasswd -c -B -b users.htpasswd ibmadmin ibmadmin
htpasswd -B -b users.htpasswd ocpadmin ocpadmin
htpasswd -B -b users.htpasswd imadmin imadmin

# Create Secret under openshift-config, named httpasswd-secret from File users.htpasswd 
oc create secret generic htpass-secret --from-file=htpasswd=./users.htpasswd -n openshift-config
#oc get secret -n openshift-config

# Create Identity from Custom Resource Sample File htpasswdCR.yaml
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
oc apply -f ./htpasswdCR.yaml

# Bind Cluster Admin Role
oc adm policy add-cluster-role-to-user cluster-admin ibmadmin
oc adm policy add-cluster-role-to-user cluster-admin ocpadmin
oc adm policy add-cluster-role-to-user cluster-admin imadmin
