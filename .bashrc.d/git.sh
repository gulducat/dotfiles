pull() {
  local remote="${1:-origin}"
  shift
  local cmd="git pull ${remote} $(git branch --show-current) $@"
  echo "+ $cmd"
  eval "$cmd"
}
push() {
  local remote="${1:-origin}"
  shift
  local cmd="git push ${remote} $(git branch --show-current) $@"
  echo "+ $cmd"
  eval "$cmd"
}
