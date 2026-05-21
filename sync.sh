#!/usr/bin/env bash

rsync -avP \
  --exclude=.git/ --exclude=install/ \
  --exclude=sync.sh --exclude=delta.sh \
  --exclude=scripts \
  --dry-run \
  ./ ~/
