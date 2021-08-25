#oc get pods -n openshift-authentication
POD=`oc get pods -n openshift-authentication | awk 'NR==2 {print $1}'`
echo $POD
oc rsh -n openshift-authentication $POD cat /run/secrets/kubernetes.io/serviceaccount/ca.crt > ./ingress-ca.crt
