sed -i 's/pids_limit.*/pids_limit = 12290\ndefault_ulimits = [\n\ \ \ \"nofile=66560:66560",\n]/g' ./crio.conf
#crio_conf=$(cat /tmp/crio.conf | python3 -c "import sys, urllib.parse;
#print(urllib.parse.quote(''.join(sys.stdin.readlines())))")
