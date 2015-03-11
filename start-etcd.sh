#!/bin/bash
set -x -e

cd $(dirname $0)

NODE_IP=`./node-ip.sh`
REGISTRY_MIRROR=`./registry-mirror.sh`
DISCOVERY_URL=`cat .etcd-discovery-url`

system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=etcd -d --restart=always \
  --net=host \
  imikushin/flannel /etcd \
  --initial-advertise-peer-urls http://${NODE_IP}:2380 \
  --listen-peer-urls http://${NODE_IP}:2380 \
  --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
  --advertise-client-urls http://${NODE_IP}:2379,http://${NODE_IP}:4001 \
  --discovery ${DISCOVERY_URL}
