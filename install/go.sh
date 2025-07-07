#!/usr/bin/env bash

set -xeuo pipefail

pkgs=(
  github.com/muesli/duf@latest
  github.com/rs/curlie@latest
)

for p in ${pkgs[*]}; do
   go install "$p"
done
