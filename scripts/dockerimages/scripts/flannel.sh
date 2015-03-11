#!/bin/sh
set -x -e

exec /flannel --iface=eth1
