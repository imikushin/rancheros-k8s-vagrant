#!/bin/sh
set -x -e

until /etcdctl cluster-health; do
  sleep 2
done

/etcdctl mk /coreos.com/network/config '{"Network":"10.244.0.0/16", "Backend": {"Type": "vxlan"}}' && :

/etcdctl get /coreos.com/network/config
