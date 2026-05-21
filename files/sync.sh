#!/usr/bin/env bash

set -xe

find * -type f | grep -v '^sync.sh$' \
| while read -r f; do
  echo mkdir -p $(dirname $f)
  echo cp $f /$f
done
