#!/bin/bash

files() {
  local backup_dir="$1"
  rsync -aAXv \
    --include-from ./rsync-include \
    "$HOME/" "$backup_dir/home/"
}

packages() {
  local backup_dir="$1"

  uname -a > "$backup_dir/system-info.txt"
  cat /etc/fedora-release >> "$backup_dir/system-info.txt"

  cp -r /etc/yum.repos.d/ "$backup_dir/yum.repos.d/"
  dnf repoquery --userinstalled > "$backup_dir/user-packages.txt"
  flatpak list --app --columns=application > "$backup_dir/flatpak-apps.txt"
}

if [[ $# -lt 2 || "$@" =~ '-h' ]]; then
  echo "usage: $0 <files|packages> <dest-dir>"
  exit 1
fi

set -euo pipefail

cmd="$1"
dir="$2"
case $cmd in
  files|packages)
    backup_dir="$dir/fedora-backup-$(date +%Y%m%d)"
    mkdir -p "$backup_dir"

    set -x
    eval "$cmd $backup_dir"

    echo "backup completed in $backup_dir"
    ;;
  *) 'unknown command'; exit 1 ;;
esac

