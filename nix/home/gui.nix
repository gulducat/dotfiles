{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO: dropbox

    # english words
    calibre-no-speech # base calibre has a huge japanese tts lib...
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

  # https://nix-community.github.io/home-manager/options/home-manager/programs/gnome-shell.html
  # equiv: dconf.settings."org/gnome/shell"
  programs.gnome-shell = {
    enable = true;
    # https://search.nixos.org/packages?channel=unstable&query=gnomeExtensions.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/desktops/gnome/extensions/extensionRenames.nix
    extensions = with pkgs.gnomeExtensions; [
      { # tray icons
        # https://github.com/ubuntu/gnome-shell-extension-appindicator
        package = appindicator; }

      # paperwm does its own top bar styling
      #{ # https://github.com/metehan-arslan/gnome-compact-top-bar
      #  package = compact-top-bar; }

      { package = emoji-copy; }

      { # hide "___ is ready" notifications
        # https://github.com/zalckos/GrandTheftFocus
        package = grand-theft-focus; }

      { # tiling window manager # TODO: ~/.config/paperwm ? or...
        # https://github.com/paperwm/PaperWM
        package = paperwm; }

      { # cpu/mem/etc
        # https://github.com/corecoding/Vitals
        package = vitals; }
    ];
  };

  # https://nixos.wiki/wiki/GNOME
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  dconf.settings = {
    # discover settings paths with `dconf watch /` or `dconf dump /`
    "org/gnome/desktop" = {
      "interface/show-battery-percentage" = true;
      "wm/preferences.resize-with-right-button" = true;
    };
    #"org/gnome/desktop/background" = {
    #  picture-uri = "file:///path/to/light.png";
    #  picture-uri-dark = "file:///path/to/dark.png";
    #};
    #this is done at a more fundamental level in system/custom.nix
    #"org/gnome/desktop/input-sources/xkb-options" = [
    #  "ctrl:swapcaps"
    #];
  };

}
