#!/bin/sh

host1=$1
host2=$2

for h in $host1 $host2 ; do
  echo -n "fetching rpm info..."
  ssh root@$h "rpm -qa" | sort > $h.rpms
  echo "done"
  echo -n "fetching sysctl info..."
  ssh root@$h "sysctl -a" | sort > $h.sysctl
  echo "done"
  echo -n "fetching redhat info..."
  ssh root@$h "cat /etc/redhat-release" | sort > $h.redhat
  echo "done"
  echo -n "fetching model info..."
  ssh root@$h 'grep "model name" /proc/cpuinfo | uniq' > $h.cpu
  echo "done"
  echo -n "fetching kernel info..."
  ssh root@$h 'uname -r' > $h.kernel
  echo "done"
  echo -n "fetching network card info..."
  ssh root@$h 'lspci | grep net' > $h.lspci
  echo "done"
  echo -n "fetching iptables info..."
  ssh root@$h 'iptables --list -t mangle' > $h.l3dsr-iptables
  echo "done"
  echo -n "fetching ip addr list info..."
  ssh root@$h 'ip addr list' > $h.ip_addr_list
  echo "done"
done
echo "===================== RPMS $host1 $host2 ============================="
diff $host1.rpms $host2.rpms
echo "===================== SYSCTL $host1 $host2 ==========================="
