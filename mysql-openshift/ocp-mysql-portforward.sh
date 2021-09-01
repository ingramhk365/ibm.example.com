POD=`oc get pods | grep Running | awk '{ print $1 }'`
oc port-forward $POD 3306:3306
