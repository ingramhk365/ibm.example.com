oc apply -f ./entitled-registry-repo.yaml

# ensure helm version 3 exist, rename to helm3 and put in /usr/local/bin
helm3 repo add ibm-helm https://raw.githubusercontent.com/IBM/charts/master/repo/ibm-helm
helm3 repo list
helm3 repo update
helm3 search repo spectrum
mkdir installer
cd installer
helm3 fetch ibm-helm/ibm-spectrum-protect-plus-prod --version "1.2.1"
tar -xvf ibm-spectrum-protect-plus-prod-1.2.1.tgz

# Get ClusterAPIServerips
oc get endpoints -n default -o yaml kubernetes

# Get CLUSTER_CIDR
oc get network -o yaml | grep -A1 clusterNetwork:

cd ..
cp baas-options.sh installer/ibm-spectrum-protect-plus-prod/ibm_cloud_pak/pak_extensions/install/
cp baas-values.yaml installer/ibm-spectrum-protect-plus-prod/ibm_cloud_pak/pak_extensions/install/
cd installer/ibm-spectrum-protect-plus-prod/ibm_cloud_pak/pak_extensions/install/
chmod +x *.sh

