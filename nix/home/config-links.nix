# I do this so I can update config files in place where the app expects,
# see the results immediately, then git add/commit changes in this repo.
{ config, lib, flakeDir, ... }:
let
  # symlink a path in this repo to a destination.
  mkLink = repoPath: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/${repoPath}";
in
{
  # ~
  home.file = lib.mapAttrs (_: repoPath: { source = mkLink repoPath; }) {
    ".gitconfig" = "files/gitconfig";
    ".bashrc.d" = "files/bashrc.d";
  };
  # ~/.config
  xdg.configFile = lib.mapAttrs (_: repoPath: { source = mkLink repoPath; }) {
    "ghostty/config" = "files/ghostty";
    "hunk/config.toml" = "files/hunk.toml";
    "nvim/init.vim"  = "files/init.vim";
    "starship.toml"  = "files/starship.toml";
    "tmux/tmux.conf" = "files/tmux.conf";
    "zed/keymap.json" = "files/zed/keymap.json";
    "zed/settings.json" = "files/zed/settings.json";
  };
}
