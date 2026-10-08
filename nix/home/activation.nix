{ lib, pkgs, ... }:

{
  # `home.activation` lets you run imperative shell snippets during
  # `home-manager switch`, integrated into home-manager's activation
  # lifecycle (ordering, dry-run support, etc.) instead of a plain bash
  # script. Good escape hatch for "bootstrap this git repo if missing"
  # style tasks that don't have a first-class Nix package.
  #
  # `lib.hm.dag.entryAfter [ "writeBoundary" ]` schedules these to run
  # after home-manager has finished writing its managed files, which is
  # the conventional place for this kind of hook.

  home.activation.installVimPlug = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
  '';

  home.activation.installTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';
}
