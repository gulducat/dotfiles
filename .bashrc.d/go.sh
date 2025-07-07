export GOPATH=${HOME}/go

[[ "$PATH" =~ "$GOPATH" ]] || export PATH="$GOPATH/go/bin:$GOPATH/bin:$PATH"

export GOPRIVATE=github.com/hashicorp

[[ "$PATH" =~ "JetBrains" ]] || export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
# kill-goland gracefully kills processes spawned by its debugger
kill-goland() {
  local sig="${1:-15}" # default sigterm
  local procs="$(ps faux | grep -v dlv | grep 'tmp/GoLan[d]')"
  test -n "$procs" || return
  echo "$procs"
  awk '{print $2}' <<< "$procs" | xargs sudo kill --verbose -"$sig"
}

