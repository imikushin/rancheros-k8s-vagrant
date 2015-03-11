#!/bin/sh
set -x -e

NODE_IP=`ip -f inet -o addr show dev eth1 | awk 'gsub(/\/[0-9]+/,""){print $4}'`
MASTER_IP=`/etcdctl get /rancher.io/k8s/master`

exec /kubelet --address=0.0.0.0 --port=10250 --hostname_override=${NODE_IP} \
              --api_servers=${MASTER_IP}:8080 --logtostderr=true
