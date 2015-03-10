#!/bin/sh
set -x -e

# FIXME parameterize with etcd endpoint (or maybe not: if we run etcd on minions)

exec /flannel --etcd-endpoints="http://172.17.7.101:4001" --iface=eth1
