echo "2. Check Catalog Source ibm-operator-catalog..."
oc get catalogsource -n openshift-marketplace ibm-operator-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'

echo ""

echo "3. Check Catalog Source ibm-db2uoperator-catalog..."
oc get catalogsource -n openshift-marketplace ibm-db2uoperator-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'

echo ""

echo "4. Check Operator Subscription ibm-common-service-operator..."
oc get csv -n ibm-common-services | grep ibm-common-service-operator

echo ""

echo "5. Check Custom Resource operandrequests.operator.ibm.com..."
oc get crd | grep operandrequests.operator.ibm.com

echo ""

echo "6. Check Cloud Pak foundational services API..."
oc api-resources --api-group operator.ibm.com -n ibm-common-services

echo ""
echo "7.1 Check installed Cluster Service Version (CSV) for scheduling service operator subscription..."
oc get sub -n ibm-common-services ibm-cpd-scheduling-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
echo ""
echo "7.2 Check Cluster Service Version (CSV) status for scheduling service operator..."
TMP=`oc get sub -n ibm-common-services ibm-cpd-scheduling-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'`
#echo $TMP
#oc get csv -n ibm-common-services ibm-cpd-scheduling-operator.v1.2.3 -o jsonpath='{.status.phase}:{.status.message} {"\n"}'
oc get csv -n ibm-common-services $TMP -o jsonpath='{.status.phase}:{.status.message} {"\n"}'
echo ""
echo "7.3 Check readiness for schdeuling service operator..."
oc get deployments -n ibm-common-services -l olm.owner=$TMP -o jsonpath='{.items[0].status.availableReplicas} {"\n"}'

echo ""
echo "8.1 Check installed Cluster Service Version (CSV) for Cloud Pak for Data platform operator subscription..."
oc get sub -n cpd-operators cpd-operator -o jsonpath='{.status.installedCSV} {"\n"}'
echo ""
echo "8.2 Check Cluster Service Version (CSV) status for Cloud Pak for Data platform operator..."
TMP=`oc get sub -n cpd-operators cpd-operator -o jsonpath='{.status.installedCSV} {"\n"}'`
oc get csv -n cpd-operators $TMP -o jsonpath='{.status.phase}:{.status.message}{"\n"}'
echo ""
echo "8.3 Check readiness for Cloud Pak for Data platform operator..."
oc get deployments -n cpd-operators -l olm.owner=$TMP -o jsonpath='{.items[0].status.availableReplicas} {"\n"}'


echo "*************************************************************************************************"
echo "9.1 Check installed Cluster Service Version (CSV) for IBM NamespaceScope operator subscription..."
oc get sub -n cpd-operators ibm-namespace-scope-operator -o jsonpath='{.status.installedCSV} {"\n"}'
echo ""
echo "9.2 Check Cluster Service Version (CSV) status for IBM NamespaceScope operator..."
TMP=`oc get sub -n cpd-operators ibm-namespace-scope-operator -o jsonpath='{.status.installedCSV} {"\n"}'`
oc get csv -n cpd-operators $TMP -o jsonpath='{.status.phase}:{.status.message}{"\n"}'
echo ""
echo "9.3 Check readiness for IBM NamespaceScope operator..."
oc get deployments -n cpd-operators -l olm.owner=$TMP -o jsonpath='{.items[0].status.availableReplicas} {"\n"}'
echo ""
echo "9.4 Check csv injection enablement for Cloud Pak for IBM NamespaceScope operator..."
echo "Don't know how to check"



