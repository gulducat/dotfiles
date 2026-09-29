{ pkgs, ... }: {

  # also, home manager: https://nix-community.github.io/home-manager/installation/standalone.html

  nix.settings.auto-optimise-store = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # unified nix cli: https://github.com/nix-community/nh
  # see: flake.nix
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/koalia/dotfiles/nixos"; # sets NH_FLAKE var
  };

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    eb-garamond
    garamond-libre
    corefonts
  ];

  environment.systemPackages = with pkgs; [

    fastfetch

    ghostty
    tmux

    git
    gnumake
    tree

    lsd
    gdu
    btop

    # https://extensions.gnome.org/
    gnome-shell-extensions

    python3
    uv

    # vivaldi must be installed system-wide, along with 1password,
    # for the integration between them to work.
    vivaldi

  ];

  environment.shellAliases = {
    ls = "lsd";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # 1password desktop <-> vivaldi chrome extension
  # https://wiki.nixos.org/wiki/1Password
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "koalia" ]; # TODO: how not to hard-code this?
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
      '';
      mode = "0755";
    };
  };

  # key mappings - this method applies across all desktop environments.
  # (xkb works on everything *except* for gnome, which instead uses dconf)
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # all keyboards
        settings = {
          main = {
            capslock = "leftcontrol";
            leftcontrol = "capslock";
          };
        };
      };
    };
  };

  # magic extra libraries ??? for zed language servers...??
  # https://github.com/nix-community/nix-ld
  #programs.nix-ld.libraries = with pkgs; [
  #  openssl
  #  zlib
  #  libsecret
  #  glib
  #];

}
