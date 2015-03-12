#!/bin/bash
set -x -e

nohup /home/rancher/start-node.sh </dev/null >/var/log/start.log 2>&1 &
