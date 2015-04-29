#!/bin/bash
set -x -e

NODE_IP=${NODE_IP:?"NODE_IP not set"}
MASTER_ENDPOINT=`system-docker run --rm --net=host imikushin/flannel /etcdctl get /rancher.io/k8s/master`

system-docker rm kube-proxy && :
system-docker run --name=kube-proxy -d --restart=always --privileged \
  --net=host \
  --volumes-from=system-volumes \
  imikushin/kubernetes /kube-proxy --master=http://${MASTER_ENDPOINT} --v=2 --logtostderr=true

system-docker rm kubelet && :
system-docker run --name=kubelet -d --restart=always --privileged \
  --ipc=host --pid=host --net=host \
  --volumes-from=command-volumes --volumes-from=system-volumes \
  imikushin/kubernetes \
  /kubelet  --address=0.0.0.0 --port=10250 --hostname_override=${NODE_IP} \
            --api_servers=${MASTER_ENDPOINT} --v=2 --logtostderr=true

system-docker run --rm \
  --net=host \
  imikushin/kubernetes \
  curl  -si -X POST http://${MASTER_ENDPOINT}/api/v1beta2/minions -H 'content-type: application/json' \
        -d "{\"kind\":\"Minion\",\"apiVersion\":\"v1beta2\",\"id\":\"${NODE_IP}\",\"hostIP\":\"${NODE_IP}\"}"

echo Minion ${NODE_IP} up!
