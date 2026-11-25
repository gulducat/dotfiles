{ lib, pkgs, ... }: {

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
    flake = "/home/koalia/dotfiles/nix"; # sets NH_FLAKE var
  };

  # Fingerprint reader
  services.fprintd.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password" "vivaldi"
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    tmux

    dig
    git
    gnumake
    tree
    gdu

    python3

    # vivaldi must be installed system-wide, along with 1password,
    # for the integration between them to work.
    vivaldi

  ];

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
  # disabled in favor of dconf in home/ to work on non-nixos installs.
  #services.keyd = {
  #  enable = true;
  #  keyboards = {
  #    default = {
  #      ids = [ "*" ]; # all keyboards
  #      settings = {
  #        main = {
  #          capslock = "leftcontrol";
  #          leftcontrol = "capslock";
  #        };
  #      };
  #    };
  #  };
  #};

  # https://wiki.nixos.org/wiki/Mullvad_VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.gui.enable = true;
}
