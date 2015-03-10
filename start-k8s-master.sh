#!/bin/bash
set -x -e

MASTER_IP=`ip -f inet -o addr show dev eth1 | awk 'gsub(/\/[0-9]+/,""){print $4}'`

sudo system-docker run --name=etcd -d --restart=always \
  --net=host \
  quay.io/coreos/etcd:v2.0.4 --listen-client-urls 'http://0.0.0.0:2379,http://0.0.0.0:4001'

sudo system-docker run --name=flannel-conf --rm --net=host flannel /flannel-conf.sh

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

sudo system-docker run --name=kube-apiserver -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  kubernetes \
  /kube-apiserver --address=0.0.0.0 --port=8080 --portal_net=10.100.0.0/16 \
  --etcd_servers=http://127.0.0.1:4001 --public_address_override=${MASTER_IP} --logtostderr=true

sudo system-docker run --name=kube-controller-manager -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  kubernetes /kube-controller-manager --master=127.0.0.1:8080 --logtostderr=true

sudo system-docker run --name=kube-scheduler -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  kubernetes /kube-scheduler --master=127.0.0.1:8080 --logtostderr=true
