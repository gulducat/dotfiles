{ config, lib, pkgs, flakeDir, ... }:

let
  # Custom derivation for a Go tool not (yet) in nixpkgs.
  hc-install = pkgs.callPackage ../pkgs/hc-install.nix { };

  # Symlinks a path in this repo's files/ dir into place, live-editable
  # without a rebuild (see mkOutOfStoreSymlink).
  mkLink = repoPath: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/${repoPath}";
in
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${flakeDir}"; # sets NH_FLAKE var
  };

   programs.neovim = {
     enable = true;
     defaultEditor = true;
     viAlias = true;
     vimAlias = true;
     # do not place init.lua
     sideloadInitLua = true;
     plugins = [];
   };

  # xdg.configFile."nvim/init.vim".source =
  #  config.lib.file.mkOutOfStoreSymlink "${flakeDir}/files/init.vim";
  # cleaner below, but more obscure?
  xdg.configFile = lib.mapAttrs (_: repoPath: { source = mkLink repoPath; }) {
    "nvim/init.vim"  = "files/init.vim";
    "ghostty/config" = "files/ghostty";
    "tmux/tmux.conf" = "files/tmux.conf";
    "starship.toml"  = "files/starship.toml";
  };

  home.packages = with pkgs; [
    # --- shell & terminal ---
    ghostty
    tmux
    starship
    atuin

    # --- modern-unix / everyday CLI tools ---
    bat
    btop
    duf
    fastfetch
    fd
    fzf
    gdu
    procs
    ripgrep
    television
    zoxide

    # --- git / github / dev workflow ---
    delta # git-delta
    gh
    gh-dash
    gh-enhance
    diffnav

    # --- editors / docs ---
    pandoc

    # --- linting / scripting ---
    shellcheck
    #actionlint
    #act

    # --- languages / toolchains ---
    #nodejs
    #pnpm
    #uv

    # --- misc CLI ---
    curlie
    glow
    slides

    # --- GNOME desktop integration ---
    gnome-tweaks
    gnome-shell-extensions
    seahorse

    # --- GUI apps (unfree, hence allowUnfree in flake.nix) ---
    vivaldi
    spotify

    # --- custom package, see ../pkgs/hc-install.nix ---
    hc-install
  ];

  # Needed because vivaldi/spotify are "unfree" licensed packages; nixpkgs
  # refuses to build/install these unless you opt in. Setting it here too
  # (in addition to flake.nix) keeps this file self-documenting.
  nixpkgs.config.allowUnfree = true;
}
