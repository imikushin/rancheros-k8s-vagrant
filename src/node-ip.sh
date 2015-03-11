#!/bin/bash
set -e

echo `ip -f inet -o addr show dev eth1 | awk 'gsub(/\/[0-9]+/,""){print $4}'`
