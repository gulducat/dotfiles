{ lib, pkgs, ... }:
{
  # explicit unfree list
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "corefonts"
    "discord" "discord-unwrapped"
    "slack"
    "spotify"
    "vivaldi"
    "zoom"
    # seems weird to need this one, but ok.
    "cheatsheet.nvim"
  ];

  home.packages = with pkgs; [
    # TODO: dropbox

    # english words
    calibre-no-speech # base calibre has a huge japanese tts lib...
    pandoc
    #onlyoffice-desktopeditors
    #euro-office-desktopeditors # gtk2... https://github.com/ONLYOFFICE/DesktopEditors/issues/2549
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

    # media
    qbittorrent
    spotify
    vlc

    # misc GUI
    firefox
    vivaldi
  ];

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

      #{ # tiling window manager # TODO: ~/.config/paperwm ? or...
      #  # https://github.com/paperwm/PaperWM
      #  package = paperwm; }

      { # cpu/mem/etc
        # https://github.com/corecoding/Vitals
        package = vitals; }

      { # https://github.com/ngthanhbinh85/shade-inactive-windows-reborn
        package = shade-inactive-windows-reborn; }

    ];
  };

  # https://nixos.wiki/wiki/GNOME
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  dconf.settings = {
    # discover settings paths with `dconf watch /` or `dconf dump /`
    "org/gnome/desktop" = {
      "interface/show-battery-percentage" = true;
      "wm/preferences/resize-with-right-button" = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      begin-move = ["<Super>v"];
      begin-resize = ["<Super>r"];
      switch-applications = ["<Super>Tab"];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
      toggle-on-all-workspaces = ["<Alt><Super>a"];
      toggle-fullscreen = ["<Super>f"];
    };
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = ["<Super>m"];
    };
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      magnifier = ["<Alt><Super>z"];
    };
    # switching ctrl and capslock can be done at a more fundamental level
    # in system/custom.nix, but here instead for non-nixos installs.
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["ctrl:swapcaps"];
    };

    "org/gnome/shell/extensions/shade-inactive-windows-reborn" = {
      shade-level = 40;
      shadow-width = 80;
      shadow-opacity = 80;
    };

    #"org/gnome/desktop/background" = {
    #  picture-uri = "file:///path/to/light.png";
    #  picture-uri-dark = "file:///path/to/dark.png";
    #};
  };

}
