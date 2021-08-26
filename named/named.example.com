$TTL 86400
@       IN SOA  helper.example.com. admin.example.com. (
                2021082400 ;Serial
                3600 ;Refresh
                1800 ;Retry
                604800 ;Expire
                86400 ;Minimum TTL
)

;Name Server Information
@					IN NS		helper

;IP for Name Server
helper					IN A		10.122.0.150
dns					IN CNAME	helper
dhcp					IN CNAME	helper
haproxy					IN CNAME	helper

nfs					IN A		10.122.0.151
keeper					IN A		10.122.0.152

;Bootstrap Node
bootstrap.ibm				IN A		10.122.0.140

;Control Planes Nodes
master01.ibm				IN A		10.122.0.141
master02.ibm				IN A		10.122.0.142
master03.ibm				IN A		10.122.0.143

;Worker Nodes
worker01.ibm				IN A		10.122.0.144
worker02.ibm				IN A		10.122.0.145
worker03.ibm				IN A		10.122.0.146
worker04.ibm				IN A		10.122.0.147
worker05.ibm				IN A		10.122.0.148
worker06.ibm				IN A		10.122.0.149

;HA Proxy
api-int.ibm				IN A		10.122.0.150
api.ibm					IN A		10.122.0.150
*.apps.ibm				IN A		10.122.0.150

oauth-openshift.apps.ibm		IN A		10.122.0.150
console-openshift-console.apps.ibm	IN A		10.122.0.150
