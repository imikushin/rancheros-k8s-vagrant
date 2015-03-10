#!/bin/sh
set -x -e

public_ipv4=`ip -f inet -o addr show dev eth1 | awk 'gsub(/\/[0-9]+/,""){print $4}'`

exec /kubelet --address=0.0.0.0 --port=10250 --hostname_override=${public_ipv4} \
              --api_servers=172.17.7.101:8080 --logtostderr=true
