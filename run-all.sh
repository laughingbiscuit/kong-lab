#!/bin/sh
set -e
set -x

cd ./scripts
for SCRIPT in *.sh; do
  sh "$SCRIPT"
done

