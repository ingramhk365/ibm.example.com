# The value for DOCKER_REGISTRY_ADDRESS must match the value for imageRegistry in baas-values.yaml
# The value for DOCKER_REGISTRY_NAMESPACE must match the value for imageRegistryNamespace: in baas-values.yaml
#

export DOCKER_REGISTRY_ADDRESS='cp.icr.io/cp'
export DOCKER_REGISTRY_USERNAME='cp'
export DOCKER_REGISTRY_PASSWORD='eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2MzA1NTA2MzMsImp0aSI6ImZmMTk1NDk0MTViYTRiODc5NDJlZTQ0OGFmZDUwODc5In0.Rtludp3CLaEqtwHBbtyvBmSYUvtxCz4LJTImCuRZskA'
export DOCKER_REGISTRY_NAMESPACE='sppc'
export SPP_ADMIN_USERNAME='superuser'
export SPP_ADMIN_PASSWORD='P@ssw0rd'
export DATAMOVER_USERNAME='datamover'
export DATAMOVER_PASSWORD='P@ssw0rd'
export MINIO_USERNAME='minio'
export MINIO_PASSWORD='P@ssw0rd'
export BAAS_VERSION='10.1.8.1'
