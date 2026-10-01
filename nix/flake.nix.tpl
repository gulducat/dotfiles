{
  # NOTE: flake.nix is templated from flake.nix.tpl via Makefile

  description = "%%CUR_USER%%'s home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # share store
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # needed for vivaldi, spotify, etc.
      };

      hostname = "%%HOST_NAME%%";

      username = "%%CUR_USER%%";
      homeDir = "/home/${username}";
      flakeDir = "%%NH_FLAKE%%";
    in
    {
      # nh os switch
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./system/configuration.nix ];
      };

      # nh home switch
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
        extraSpecialArgs = { inherit username homeDir flakeDir; };
      };
    };
}
