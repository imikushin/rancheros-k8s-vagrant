#!/bin/bash
set -x -e

cd $(dirname $0)

NODE_IP=`./node-ip.sh`
REGISTRY_MIRROR=`./registry-mirror.sh`

./start-etcd.sh

system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=flannel-conf --rm --net=host imikushin/flannel /flannel-conf.sh

# TODO maybe not --privileged
system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=flannel -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/flannel /flannel.sh && :

system-docker stop userdocker && system-docker rm userdocker && :

system-docker --registry-mirror=${REGISTRY_MIRROR} run --name=k8s-docker -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=user-volumes --volumes-from=system-volumes \
  -v=/var/lib/rancher/state/docker:/var/lib/docker \
  imikushin/kubernetes /k8s-docker.sh && :

if [ -f ./.k8s-master ]; then
  system-docker run --rm --net=host imikushin/flannel /etcdctl set /rancher.io/k8s/master "${NODE_IP}"
  ./start-k8s-master.sh
else
  ./start-k8s-minion.sh
fi
