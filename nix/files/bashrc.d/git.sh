pull() {
  _git pull "$@"
}
push() {
  _git push "$@"
}
_git() {
  local act="${1}"
  local remote="${2:-origin}"
  shift; shift
  local cmd="git ${act} ${remote} $(git branch --show-current) $@"
  echo "+ $cmd"
  eval "$cmd"
}
