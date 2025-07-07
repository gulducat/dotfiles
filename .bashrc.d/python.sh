# https://github.com/pyenv/pyenv
# don't forget to install deps before doing `pyenv install`
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin && ! "$PATH" =~ "$PYENV_ROOT" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#pathmunge "$PYENV_ROOT/bin:$PATH"

# this is sloppy...

#eval "$(pyenv virtualenv-init -)"
# copy of the eval init, but avoid duplicate PATH entries
[[ "$PATH" =~ 'pyenv-virtualenv' ]] || export PATH="$HOME/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
#pathmunge "$HOME/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";

export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "${VIRTUAL_ENV-}" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};
if ! [[ "${PROMPT_COMMAND-}" =~ _pyenv_virtualenv_hook ]]; then
  PROMPT_COMMAND="_pyenv_virtualenv_hook;${PROMPT_COMMAND-}"
fi

eval "$(pyenv init - bash)"
# copy of the above, but avoid duplicate PATH entries

