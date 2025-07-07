#!/usr/bin/env bash

set -xeuo pipefail

if [ ! command -v cargo ]; then
  # lazy pkg management detection
  mgr=''
  for m in apt dnf rpm rpm-ostree; do
    command -v $m && mgr="$m" && break
  done
  if [ -z "$mgr" ]; then
    echo 'no package manager detected?'
    exit 1
  fi
  
  sudo "$mgr" install rustup

  # PATH and RUSTUP_HOME and CARGO_HOME env vars
  # are set in ../.bashrc.d/rust.sh
  rustup-init --no-modify-path
fi

cargo --version

cargo install --locked \
  du-dust \
  fd-find \
  procs \
  ;

