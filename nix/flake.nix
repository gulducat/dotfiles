{
  description = "dbennett's home-manager config";

  # "inputs" are the other flakes this one depends on. Pinning them here
  # (and locking them in flake.lock, generated on first build) is what makes
  # a flake reproducible: everyone who builds this flake gets the exact same
  # nixpkgs/home-manager revisions until you deliberately run `nix flake update`.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # "follows" pins home-manager's own nixpkgs input to *our* nixpkgs input
      # above, instead of whatever nixpkgs revision home-manager itself pins.
      # Without this you'd end up with two separate copies of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # "outputs" is a function of the inputs, producing whatever this flake
  # provides. Here we provide a single `homeConfigurations` entry, which is
  # what `home-manager switch --flake .#dbennett` looks for.
  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # needed for vivaldi, spotify, etc.
      };

      username = "dbennett";
      homeDir = "/home/${username}";
      flakeDir = "/home/dbennett/dotfiles/nix";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
        extraSpecialArgs = { inherit username homeDir flakeDir; };
      };
    };
}
