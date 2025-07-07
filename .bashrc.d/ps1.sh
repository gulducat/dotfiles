#GREEN="\[$(tput setaf 3)\]"
#NC="\[$(tput sgr0)\]"
_exit_code() {
  local rc=$?
  printf "\[" # be nice to bash for width-calculating
  [[ $rc == 0 ]] && tput setaf 2 || tput setaf 1
  printf "\]" # same
  printf "$rc"
  echo "\[$(tput sgr0)\]"
}
# a fun called `_git_branch` comes from *somewhere*
# idk where, so mine's a little exhasperated.
_git_branch_cmon() {
  #local br="$(git brname 2>/dev/null)"
  local br="$(git branch 2>/dev/null | grep "^*" | awk '{ print $2 }')"
  echo "\[$(tput setaf 4)\]$br \[$(tput sgr0)\]"
}
_prompt_symbol() {
  local symbol='$'
  if [ $(whoami) == root ]; then
    symbol="\[$(tput setaf 3)\]root #\[$(tput sgr0)\]"
  fi
  echo "$symbol"
  #echo "\[$(tput setaf 3)\]$symbol\[$(tput sgr0)\]"
}
__prompt() {
  local rc="$(_exit_code)"
  local branch="$(_git_branch_cmon)"
  local venv="$VIRTUAL_ENV_PROMPT"
  PS1="$rc \w $branch\n$venv$(_prompt_symbol) "
}
#export PS1="\$(_git_branch)\w \$(_exit_code) $ "
export PROMPT_COMMAND=__prompt
