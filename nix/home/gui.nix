{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO: dropbox

    # english words
    pandoc
    onlyoffice-desktopeditors
    libreoffice
    hunspell
    hunspellDicts.en_US
    hyphenDicts.en_US

    # images
    gimp
    inkscape

    # gnome desktop
    gnome-tweaks
    gnome-shell-extensions
    seahorse

    # social
    discord
    slack
    zoom-us

    # misc GUI
    vivaldi
    spotify
  ];

  # https://github.com/nix-community/home-manager/tree/master/modules/programs

  programs.firefox.enable = true;

  # Needed because vivaldi/spotify are "unfree" licensed packages; nixpkgs
  # refuses to build/install these unless you opt in. Setting it here too
  # (in addition to flake.nix) keeps this file self-documenting.
  nixpkgs.config.allowUnfree = true;
}
