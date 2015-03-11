#!/bin/bash
set -x -e

NODE_IP=`./node-ip.sh`

system-docker run --name=kube-apiserver -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-apiserver --address=0.0.0.0 --port=8080 --portal_net=10.100.0.0/16 \
  --etcd_servers=http://127.0.0.1:4001 --public_address_override=${NODE_IP} --logtostderr=true

system-docker run --name=kube-controller-manager -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-controller-manager --master=127.0.0.1:8080 --logtostderr=true

system-docker run --name=kube-scheduler -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kube-scheduler --master=127.0.0.1:8080 --logtostderr=true
