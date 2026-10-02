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

  programs.zoxide.enable = true;

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

  programs.lazygit = {
    enable = true;
    shellWrapperName = "lg";
    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    settings = {
      git = {
        branchLogCmd = "git log --graph --color=always --date=relative --pretty=medium {{branchName}} --";
        diffRenderers = [{
          command = "delta --paging=never --detect-dark-light=always --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
        }];
      };
      gui = {
        theme = {
          activeBorderColor = [ "green" ];
          inactiveBorderColor = [ "#777777" ];
        };
        nextScreenMode = "+";
        prevScreenMode = "_";
        nerdFontsVersion = "3";
      };
    };
  };

  # https://wiki.nixos.org/wiki/Zed
  programs.zed-editor = {
   enable = true;
   extraPackages = with pkgs; [ nixd nil go gopls ];
   # user settings in files/zed/
  };
  #programs.nix-ld = {
  #  enable = true;
  #  libraries = [ pkgs.zlib pkgs.openssl ];
  #};

  programs.btop = {
    enable = true;
    # https://github.com/aristocratos/btop#configurability
    settings = {
      color_theme = "TTY";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.firefox.enable = true;

  home.file = lib.mapAttrs (_: repoPath: { source = mkLink repoPath; }) {
    ".gitconfig" = "files/gitconfig";
  };
  xdg.configFile = lib.mapAttrs (_: repoPath: { source = mkLink repoPath; }) {
    "ghostty/config" = "files/ghostty";
    "tmux/tmux.conf" = "files/tmux.conf";
    "starship.toml"  = "files/starship.toml";
    "nvim/init.vim"  = "files/init.vim";
    "zed/keymap.json" = "files/zed/keymap.json";
    "zed/settings.json" = "files/zed/settings.json";
  };

  home.sessionPath = [
    # TODO: figure out fnm, dynamic `node` error, etc
    #"${homeDir}/.local/share/fnm/aliases/default/bin"
  ];

  home.shellAliases = {
    a = "source ~/.bash_profile";
    ls = "lsd";
    ll = "ls -lh";
  };

  home.packages = with pkgs; [
    # TODO: dropbox

    # --- shell & terminal ---
    ghostty
    tmux

    # --- modern-unix / everyday CLI tools ---
    bat
    duf
    fastfetch
    fd
    fzf
    gdu
    lsd
    procs
    ripgrep # rg
    television # tv

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
