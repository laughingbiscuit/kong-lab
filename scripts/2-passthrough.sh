#!/bin/sh
set -e
set -x
SCRIPT_DIR=$( (cd "$(dirname "$0")" && pwd ))

deck ping
deck sync -s "$SCRIPT_DIR/../apis/httpbin.yaml"
curl -q localhost:8000/httpbin/v1/get
