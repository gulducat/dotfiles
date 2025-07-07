alias n=nomad
alias tf=terraform

# hashi-bin
#export HASHI_LINKS=$HOME/.local/bin/
# totally different thing now in ~/.local/bin/hashi-bin
[[ "$PATH" =~ 'local/bin/hashi' ]] || export PATH="$HOME/.local/bin/hashi:$PATH"

# nomad
#export NOMAD_ADDR=https://localhost:4646
export NOMAD_LICENSE_PATH=$HOME/licenses/nomad.hclic
export NOMAD_TOKEN=00000000-0000-0000-0000-000000000000
#export NOMAD_CLIENT_CERT=/opt/nomad/tls/global-client-nomad.pem
#export NOMAD_CLIENT_KEY=/opt/nomad/tls/global-client-nomad-key.pem
unset-nomad-env() {
  env | grep -q NOMAD_ || return
  echo 'unsetting these env vars:'
  for e in $(env | awk -F= '/NOMAD_/ {print$1}'); do
		eval "echo export $e=\"\$$e\""
		unset $e
	done
}
acl-bootstrap() {
  nomad acl bootstrap - <<< "$NOMAD_TOKEN"
}

# vault
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=localdev

# consul
export CONSUL_LICENSE_PATH=$HOME/licenses/consul.hclic
# token set in /opt/nomad/consul.hcl
export CONSUL_HTTP_TOKEN='consul-root-token'

# TODO: go-run-programs
consul-connect() {
  > /tmp/consul.log
  consul agent -dev -config-file /opt/consul/agent.hcl $@ > /tmp/consul.log 2>&1 &
  while true; do
    consul members | grep alive && break
    sleep 0.5
  done
  nomad setup consul -y &
  tail -f /tmp/consul.log | rainbow
}

agent() {
  if [ "$1" == 'bootstrap' ]; then
    _agent start --bootstrap-expect=1 &
  else
    _agent start &
  fi
  local pid="$!"
  _agent logs
  echo "remember to kill $pid"
}

_agent() {
  > /tmp/nomad.log
  case "$1" in
    'start')
      shift
      sudo -i $(which nomad) agent -config /opt/nomad/agent.hcl $@ > /tmp/nomad.log 2>&1
      ;;
    'logs') tail -f /tmp/nomad.log | rainbow ;;
    *) echo 'start or logs?' ;;
  esac
}

server() {
  case "$1" in
    'start') sudo -i $(which nomad) agent -config /opt/nomad/server.hcl > /tmp/nomad.log 2>&1 ;;
    'logs') tail -f /tmp/nomad.log | rainbow ;;
    *) echo 'start or logs?' ;;
  esac
}

client() {
  case "$1" in
    'start') nomad run /opt/nomad/clients.nomad.hcl ;;
    'restart') nomad job restart clients ;;
    'logs') nomad logs -f -job clients | rainbow ;;
    'stop') nomad stop clients ;;
    *) echo 'start or stop?' ;;
  esac
}

state() {
  local snap
  snap="$(nomad operator snapshot save | awk '{print $NF}')" 
  test -n "$snap" || return
  nomad operator snapshot state "$snap" | less
  rm -v "$snap"
}

# VIRT
_virsh_ip() {
  local vm="$(virsh list | awk '/running/ {print $2}' | head -n1)"
  test -n "$vm" || { 1>&2 echo 'no vm running..'; return 1; }
  virsh net-dhcp-leases default | awk "/$vm/ {print \$5}" | cut -d'/' -f1
}
_virsh_ssh() {
  local user="${1:-ubuntu}"
  local ip="$(_virsh_ip)"
  echo "ip: $ip"
  test -n "$ip" || { 1>&2 echo 'no ip..'; return 1; }
  echo "$user@$ip"
  ssh -i ~/.ssh/virt \
    -o 'StrictHostKeyChecking=no' \
    -o 'UserKnownHostsFile=/dev/null' \
    "$user@$ip"
}

vercel(){
  echo "https://nomad-git-${1:-$(git branch --show-current)}-hashicorp.vercel.app/nomad"
}

# jira cli
# https://github.com/ankitpokhrel/jira-cli
# token from https://id.atlassian.com/manage-profile/security/api-tokens
#export JIRA_API_TOKEN='TODO: probably a better way to set this...'
#source <(jira completion bash)
