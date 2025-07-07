#!/usr/bin/env bash

find . -type f \
  -not -path './.git*' \
  -not -path './install/*' \
  -not -path './sync.sh' \
  -not -path './delta.sh' \
  | while read -r f; do
    #echo "==== $f ===="
    dest="$(sed -r 's_^\._'"$HOME"'_' <<< "$f")"
    #test -f "$dest" || { echo "no $dest"; continue; }
    test -f "$dest" || continue
    delta "$f" "$dest"
  done
