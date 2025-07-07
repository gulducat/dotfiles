export RUSTUP_HOME=$HOME/.rustup
export CARGO_HOME=$HOME/.cargo
[[ "$PATH" =~ "$CARGO_HOME" ]] || export PATH="$CARGO_HOME/bin:$PATH"
