# made for an eng-serv demo long long ago

succeed() {
  local steps sp msg last_len step pct half left full empty bar spin out
  steps="${1:-2}00" # default 20 seconds. succeding is hard work, after all.
  sp='⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓' # spinnin https://github.com/molovo/revolver/blob/master/revolver
  msg="$(_random_msg)"
  last_len=0 # for clearing buffer

  for step in $(seq 0 $steps); do
    pct=$(( $step / ($steps / 100) ))
    half=$(( $pct / 2 ))
    left=$(( 50 - $half ))
    full=$(printf "%${half}s")
    empty=$(printf "%${left}s")
    bar="${full// /▇}${empty// /-}"

    if [[ $(( $step % 40 )) == 0 ]]; then
      msg="$(_random_msg)"
    fi

    if [ $pct -lt 100 ]; then
      spin=$(printf "\b${sp:$step%${#sp}:1}")
    else
      spin='✅'
      msg='Success!\n'
      tput setaf 2
      tput bold
    fi

    printf "\r%-${last_len}s" " "
    out="\r$spin $bar $pct%% $msg"
    last_len=${#out}
    printf "$out"
    sleep 0.1
  done

  tput sgr0
}

_random_msg() {
  local lines idx
  declare -a lines
  # TODO: more lines http://www.stackprinter.com/export?service=stackoverflow&question=182112
  lines=(
    "reticulating splines"
    "counting pixels"
    "waiting for Godot"
    "remembering the good times"
    "asking a friend for help"
    "enjoying the scenery"
    "taking a deep breath"
    "taking a quick nap"
    "looking for fireflies"
    "tickling the elves"
  )
  # zsh's $RANDOM is not very random, so do a silly perl
  idx=$(perl -e "print int rand ${#lines[@]}")
  printf "${lines[$idx]}..."
}
