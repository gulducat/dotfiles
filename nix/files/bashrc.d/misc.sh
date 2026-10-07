..() {
  local to
  for _ in $(seq 1 ${1:-1}); do
    to="../$to"
  done
  cd "$to"
}

# TODO: bat for man pages? this one is wonky
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# cmd -h | help
help() {
  bat --plain --paging=never --language=help
}

port-forward() {
  local port addr
  port="${1?need port}"
  addr="${2?need target addr}"
  shift 2
  socat "TCP-LISTEN:$port,fork" "TCP:$addr" "$@"
}

jwt() {
  # unwrap a jwt
  jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <<< "$1"
}

wipe-iptables() {
  set -x
  sudo whoami
  for ipt in iptables ip6tables; do
    sudo $ipt -P INPUT ACCEPT
    sudo $ipt -P FORWARD ACCEPT
    sudo $ipt -P OUTPUT ACCEPT
    sudo $ipt -t nat -F
    sudo $ipt -t mangle -F
    sudo $ipt -F
    sudo $ipt -X
  done
  set +x
}
