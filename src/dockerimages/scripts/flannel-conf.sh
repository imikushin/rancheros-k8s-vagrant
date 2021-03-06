#!/bin/sh
set -x -e

until /etcdctl cluster-health; do
  sleep 2
done

FLANNEL_NETWORK=${FLANNEL_NETWORK:?"FLANNEL_NETWORK not set"}

/etcdctl set /coreos.com/network/config "{\"Network\":\"${FLANNEL_NETWORK}\",\"Backend\":{\"Type\":\"vxlan\"}}"
