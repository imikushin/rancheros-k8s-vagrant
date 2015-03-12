#!/bin/bash
set -x -e

NODE_IP=`./node-ip.sh`
MASTER_IP=`system-docker run --rm --net=host imikushin/flannel /etcdctl get /rancher.io/k8s/master`

system-docker rm kube-proxy && :
system-docker run --name=kube-proxy -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes /kube-proxy --etcd_servers=http://127.0.0.1:2379 --logtostderr=true

system-docker rm kubelet && :
system-docker run --name=kubelet -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes /kubelet.sh

system-docker run --rm \
  --net=host \
  imikushin/kubernetes \
  curl -si -X POST http://${MASTER_IP}:8080/api/v1beta2/minions -H 'content-type: application/json' \
  -d "{\"kind\":\"Minion\",\"apiVersion\":\"v1beta2\",\"id\":\"${NODE_IP}\",\"hostIP\":\"${NODE_IP}\"}" && :

echo Minion ${NODE_IP} up!
