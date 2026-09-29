{
  description = "dbennett's home-manager config";

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

      hostname = "nixos";

      username = "koalia";
      homeDir = "/home/${username}";
      flakeDir = "/home/koalia/dotfiles/nix";
    in
    {
      # nh os switch
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/hardware-configuration.nix
          ./system/configuration.nix
          ./system/custom.nix
        ];
      };

      # nh home switch
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
        extraSpecialArgs = { inherit username homeDir flakeDir; };
      };
    };
}
