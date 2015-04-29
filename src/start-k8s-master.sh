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
                  --etcd_servers=http://127.0.0.1:2379 --public_address_override=${NODE_IP} --v=2 --logtostderr=true

system-docker rm kube-proxy && :
system-docker run --name=kube-proxy -d --restart=always --privileged \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes /kube-proxy --master=http://127.0.0.1:${MASTER_PORT} --v=2 --logtostderr=true

system-docker rm kube-controller-manager && :
system-docker run --name=kube-controller-manager -d --restart=always \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-controller-manager --master=http://127.0.0.1:${MASTER_PORT} --v=2 --logtostderr=true

system-docker rm kube-scheduler && :
system-docker run --name=kube-scheduler -d --restart=always \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-scheduler --master=http://127.0.0.1:${MASTER_PORT} --v=2 --logtostderr=true
