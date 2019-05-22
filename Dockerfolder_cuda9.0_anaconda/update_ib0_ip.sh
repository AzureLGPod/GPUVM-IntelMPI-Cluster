### update_ib0_ip.sh ###
#!/bin/bash
### This will update ib0 with infiniband IP in /etc/dat.conf
ETH1=$(/sbin/ifconfig eth1 | grep Mask | awk '{print $2}'| cut -f2 -d:)
sed -i -e 's/^ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "ib0 0"/ofa-v2-ib0 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "'$ETH1' 0"/g' /etc/dat.conf
