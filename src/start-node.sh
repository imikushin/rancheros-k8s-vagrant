#!/bin/bash
set -x -e

cd $(dirname $0)

export NODE_IP=`./node-ip.sh`
export REGISTRY_MIRROR=`./registry-mirror.sh`

./start-etcd.sh

system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=flannel-conf --rm --net=host \
  -e FLANNEL_NETWORK="10.244.0.0/16" \
  imikushin/flannel /flannel-conf.sh

# TODO maybe not --privileged
system-docker rm flannel && :
system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=flannel -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/flannel /flannel --iface=eth1

system-docker stop userdocker && system-docker rm userdocker && :

system-docker rm k8s-docker && :
system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=k8s-docker -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=user-volumes --volumes-from=system-volumes \
  -v=/var/lib/rancher/state/docker:/var/lib/docker \
  imikushin/kubernetes /k8s-docker.sh

if [ -f ./.k8s-master ]; then
  ./start-k8s-master.sh
else
  ./start-k8s-minion.sh
fi
