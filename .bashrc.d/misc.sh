command -v lsd >/dev/null && alias ls='lsd'

wifi='wlp2s0f0'

# creates `z` function
eval "$(zoxide init bash)"
export _ZO_DOCTOR=0 # disable "zoxide has to go at the end" warning

# bat
alias cat='bat --plain --paging=never'
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"
help() {
  # -pp == --plain --paging=never
  bat -pp --language=help
}

# spicetify
# add_path ~/.spicetify

#add_path ~/.porter

refresh-calendar() {
  rm -rf ~/.{local/share,cache}/evolution/calendar/ \
  && pkill -f calendar
}

jwt() {
	# https://gist.github.com/angelo-v/e0208a18d455e2e6ea3c40ad637aac53
	#cut -d. -f1,2 <<< "$1" | sed 's~\.~\n~g' | base64 --decode | jq .
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
