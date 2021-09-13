#!/bin/sh
set -e
set -x

docker run --network kong-lab-net -it kong/deck --kong-addr http://kong-lab-ee:8001 ping
