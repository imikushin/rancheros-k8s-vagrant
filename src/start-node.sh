#!/bin/bash
set -x -e

cd $(dirname $0)

export NODE_IP=`./node-ip.sh`

./start-etcd.sh

system-docker rm flannel-conf && :
system-docker run --name=flannel-conf --rm --net=host \
  -e FLANNEL_NETWORK="10.244.0.0/16" \
  imikushin/flannel /flannel-conf.sh

system-docker rm flannel && :
system-docker run --name=flannel -d --restart=always --privileged \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/flannel /flannel --iface=eth1

system-docker stop userdocker && system-docker rm userdocker && :

system-docker rm k8s-docker && :
system-docker run --name=k8s-docker -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=user-volumes --volumes-from=system-volumes \
  -v=/var/lib/rancher/state/docker:/var/lib/docker \
  imikushin/kubernetes /k8s-docker.sh

if [ -f ./.k8s-master ]; then
  ./start-k8s-master.sh
else
  ./start-k8s-minion.sh
fi
