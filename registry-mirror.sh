#!/bin/bash
set -e

cd $(dirname $0)

NODE_IP=`./node-ip.sh`

REGISTRY_IP=`echo ${NODE_IP} | awk 'sub(/[0-9]+$/, "1")'`

echo http://${REGISTRY_IP}:5000
