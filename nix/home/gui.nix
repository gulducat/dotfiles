{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO: dropbox
    # TODO: mullvad

    # english words
    calibre
    pandoc
    onlyoffice-desktopeditors
    libreoffice
    hunspell
    hunspellDicts.en_US
    hyphenDicts.en_US

    # images
    gimp
    inkscape

    # gnome
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

  # spotify, vivaldi, ...
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/GNOME
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  dconf.settings = {
    # discover settings paths with `dconf watch /` or `dconf dump /`
    "org/gnome/desktop/wm/preferences" = {
      "resize-with-right-button" = true;
    };
    #"org/gnome/desktop/background" = {
    #  picture-uri = "file:///path/to/light.png";
    #  picture-uri-dark = "file:///path/to/dark.png";
    #};
    #this is done at a more fundamental level in system/custom.nix
    #"org/gnome/desktop/input-sources/xkb-options" = [
    #  "ctrl:swapcaps"
    #];
    "org/gnome/shell" = {
      disable-user-extensions = false;
      # https://search.nixos.org/packages?channel=unstable&query=gnomeExtensions.
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/desktops/gnome/extensions/extensionRenames.nix
      # curl https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-unstable/pkgs/desktops/gnome/extensions/extensions.json
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid # "appindicatorsupport@rgcjonas.gmail.com"
        emoji-copy.extensionUuid # "emoji-copy@felipeftn"
      ];
    };
  };

}
