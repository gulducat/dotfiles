#!/usr/bin/env bash

set -xeuo pipefail

if [ ! -f ~/go/Makefile ]; then
  cp -r ../go ~/go
  cd ~/go && make && cd - || exit
fi

pkgs=(
  github.com/muesli/duf@latest
  github.com/rs/curlie@latest
  github.com/charmbracelet/glow/v2@latest
  github.com/ankitpokhrel/jira-cli/cmd/jira@latest
)

for p in ${pkgs[*]}; do
   go install "$p"
done
