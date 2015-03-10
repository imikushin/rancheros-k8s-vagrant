#!/bin/bash
set -x -e

. /var/run/flannel/subnet.env

CGROUPS="perf_event net_cls freezer devices blkio memory cpuacct cpu cpuset"

mkdir -p /sys/fs/cgroup
mount -t tmpfs none /sys/fs/cgroup

for i in $CGROUPS; do
    mkdir -p /sys/fs/cgroup/$i
    mount -t cgroup -o $i none /sys/fs/cgroup/$i
done

if ! lsmod | grep -q br_netfilter; then
    modprobe br_netfilter 2>/dev/null || true
fi

rm -f /var/run/docker.pid

ip link set down dev docker0
brctl delbr docker0

exec >/var/log/userdocker.log 2>&1
exec docker -d -s overlay -G docker --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}
