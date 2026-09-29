{ username, homeDir, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/activation.nix
    ./modules/onlyoffice.nix
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
}
