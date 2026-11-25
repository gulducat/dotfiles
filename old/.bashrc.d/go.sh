export GOPATH=${HOME}/go

[[ "$PATH" =~ "$GOPATH" ]] || export PATH="$GOPATH/go/bin:$GOPATH/bin:$PATH"

export GOPRIVATE=github.com/gulducat,github.com/hashicorp

[[ "$PATH" =~ "JetBrains" ]] || export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
# kill-goland gracefully kills processes spawned by its debugger
kill-goland() {
  local sig="${1:-15}" # default sigterm
  local procs="$(ps faux | grep -v dlv | grep 'tmp/GoLan[d]')"
  test -n "$procs" || return
  echo "$procs"
  awk '{print $2}' <<< "$procs" | xargs sudo kill --verbose -"$sig"
}

go-test() {
  [ -n "$1" ] || { echo 'need filename(s)'; return 1; }
  local files dir tests tags cmd
  files=("$@") # expand any globs
  echo "files: ${files[@]}"
  # assume they're all in the one dir/package
  dir="$(dirname "${files[0]}")"
  tests="$(awk -F'[ \\(]' -v ORS='|' '/^func Test/ {print$2}' "${files[@]}")" || return
  tests="${tests::-1}" # drop the trailing '|'
  tags=''
  [[ "$PWD" =~ '-enterprise' ]] && tags='-tags=ent'
  cmd="go test -v $dir $tags -run '($tests)'"
  echo "+ $cmd"
  eval "$cmd"
}

