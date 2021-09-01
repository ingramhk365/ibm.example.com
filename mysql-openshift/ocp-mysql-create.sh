oc new-project mysql
oc project mysql
oc new-app --as-deployment-config \
--docker-image=registry.access.redhat.com/rhscl/mysql-57-rhel7:latest \
--name=mysql-openshift \
-e MYSQL_USER=user1 \
-e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=testdb \
-e MYSQL_ROOT_PASSWORD=r00tpa55
oc expose svc/mysql-openshift
oc status
oc get pods
