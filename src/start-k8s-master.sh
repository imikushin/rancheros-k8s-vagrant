#!/bin/bash
set -x -e

NODE_IP=${NODE_IP:?"NODE_IP not set"}
MASTER_PORT=8080
MASTER_ENDPOINT="${NODE_IP}:${MASTER_PORT}"
system-docker run --rm --net=host imikushin/flannel /etcdctl set /rancher.io/k8s/master ${MASTER_ENDPOINT}

system-docker rm kube-apiserver && :
system-docker run --name=kube-apiserver -d --restart=always \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-apiserver --address=0.0.0.0 --port=${MASTER_PORT} --portal_net=10.100.0.0/16 \
                  --etcd_servers=http://127.0.0.1:2379 --public_address_override=${NODE_IP} --logtostderr=true

system-docker rm kube-controller-manager && :
system-docker run --name=kube-controller-manager -d --restart=always \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-controller-manager --master=127.0.0.1:${MASTER_PORT} --logtostderr=true

system-docker rm kube-scheduler && :
system-docker run --name=kube-scheduler -d --restart=always \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-scheduler --master=127.0.0.1:${MASTER_PORT} --logtostderr=true
