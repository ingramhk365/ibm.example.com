POD=`oc get pods | grep Running | awk '{ print $1 }'`
oc rsh pod/$POD
