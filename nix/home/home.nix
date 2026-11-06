{ pkgs, username, homeDir, flakeDir, ... }:
{
  imports = [
    ./shell.nix
    ./nvim.nix
    ./code.nix
    ./gui.nix
    ./config-links.nix
    ./flakes.nix
    ./copyfonts.nix
  ];

  home.username = username;
  home.homeDirectory = homeDir;

  # stateVersion pins the format/behavior of home-manager's *own* internal
  # state (not your packages) to whatever was current when you started using
  # it. Nix convention: set once, then leave it alone forever, even as you
  # upgrade home-manager/nixpkgs later. Bumping it is a deliberate, separate
  # decision (check the release notes first).
  home.stateVersion = "26.05";

  # Lets home-manager manage itself (adds the `home-manager` CLI command
  # to your profile, so you don't need to reach for it via `nix run`).
  programs.home-manager.enable = true;

  # `nh` is "yet another Nix CLI helper"
  # https://github.com/nix-community/nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${flakeDir}"; # sets NH_FLAKE var
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # "JetBrainsMono Nerd Font"
    eb-garamond
    garamond-libre
    corefonts
  ];

}
