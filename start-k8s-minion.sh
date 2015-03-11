#!/bin/bash
set -x -e

NODE_IP=`./node-ip.sh`

# TODO maybe not --privileged

sudo system-docker run --name=flannel -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  flannel /flannel.sh

# stop userdocker
sudo system-docker stop userdocker && sudo system-docker rm userdocker && :

sudo system-docker run --name=k8s-docker -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=user-volumes --volumes-from=system-volumes \
  -v=/var/lib/rancher/state/docker:/var/lib/docker \
  kubernetes /k8s-docker.sh

# FIXME replace 172.17.7.101 with MASTER_IP

sudo system-docker run --name=kube-proxy -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  kubernetes /kube-proxy --etcd_servers=http://172.17.7.101:4001 --logtostderr=true

sudo system-docker run --name=kubelet -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  kubernetes /kubelet.sh
