oc new-project spp-velero

#File aws-secret.yaml
#[default]
#aws_access_key_id=
#aws_secret_access_key=

oc create secret generic cloud-credentials --namespace spp-velero --from-file cloud=./aws-secret.yaml
