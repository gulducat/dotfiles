{ config, lib, pkgs, homeDir, flakeDir, ... }:

let
  # Custom derivation for a Go tool not (yet) in nixpkgs.
  hc-install = pkgs.callPackage ./pkgs/hc-install.nix { };

  # Symlinks a path in this repo's files/ dir into place, live-editable
  # without a rebuild (see mkOutOfStoreSymlink).
  mkLink = repoPath: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/${repoPath}";
in
{
  # https://github.com/nix-community/home-manager/tree/master/modules/programs

  # https://github.com/nix-community/nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${flakeDir}"; # sets NH_FLAKE var
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
    '';
  };

  # starship detects programs.bash
  programs.starship.enable = true;

  # https://docs.atuin.sh/latest/configuration/config/
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      invert = true;
      show_tabs = false;
      enter_accept = true;
      tmux.enabled = true;
    };
    forceOverwriteSettings = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # do not place init.lua
    sideloadInitLua = true;
    plugins = [
      # TODO: neovim plugins here, instead of init.vim?
    ];
  };

  # https://wiki.nixos.org/wiki/Zed
  programs.zed-editor = {
   enable = true;
   extraPackages = with pkgs; [ nixd nil ];
   extensions = [ "nix" "make" "toml" "gdscript" "svelte" ];
  };
  #programs.nix-ld = {
  #  enable = true;
  #  libraries = [ pkgs.zlib pkgs.openssl ];
  #};

  programs.firefox.enable = true;

  # xdg.configFile."nvim/init.vim".source =
  #  config.lib.file.mkOutOfStoreSymlink "${flakeDir}/files/init.vim";
  # cleaner below, but more obscure?
  xdg.configFile = lib.mapAttrs (_: repoPath: { source = mkLink repoPath; }) {
    "nvim/init.vim"  = "files/init.vim";
    "ghostty/config" = "files/ghostty";
    "tmux/tmux.conf" = "files/tmux.conf";
    "starship.toml"  = "files/starship.toml";
  };

  home.sessionPath = [
    # TODO: figure out fnm, dynamic `node` error, etc
    #"${homeDir}/.local/share/fnm/aliases/default/bin"
  ];

  home.shellAliases = {
    ls = "lsd";
  };

  home.packages = with pkgs; [
    # TODO: dropbox

    # --- shell & terminal ---
    ghostty
    tmux

    # --- modern-unix / everyday CLI tools ---
    bat
    btop
    duf
    fastfetch
    fd
    fzf
    gdu
    lsd
    procs
    ripgrep # rg
    television # tv
    zoxide # z

    # --- git / github / dev workflow ---
    delta # git-delta
    gh
    gh-dash
    gh-enhance
    diffnav

    # --- editors / docs ---
    pandoc
    onlyoffice-desktopeditors
    libreoffice
    hunspell
    hunspellDicts.en_US
    hyphenDicts.en_US

    # --- images ---
    gimp
    inkscape

    # --- linting / scripting ---
    shellcheck
    #actionlint
    #act

    # --- languages / toolchains ---
    # TODO: my special ~/go/ setup...?
    # TODO: don't need these? could be per-project shell.nix ...
    #nodejs
    #pnpm
    #uv
    #godot

    # --- misc CLI ---
    curlie
    glow
    slides

    # --- GNOME desktop integration ---
    gnome-tweaks
    gnome-shell-extensions
    seahorse

    # --- social ---
    discord
    slack
    zoom-us

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
