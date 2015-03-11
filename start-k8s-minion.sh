#!/bin/bash
set -x -e

NODE_IP=`./node-ip.sh`
MASTER_IP=`system-docker --rm --net=host imikushin/flannel /etcdctl get /rancher.io/k8s/master`

system-docker run --name=kube-proxy -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes /kube-proxy --etcd_servers=http://${MASTER_IP}:4001 --logtostderr=true

system-docker run --name=kubelet -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes /kubelet.sh
