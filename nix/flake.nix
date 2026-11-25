{
  description = "nix jazz";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # change this to a known-good sha if something goes wonky with an update.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = { inputs.nixpkgs.follows = "nixpkgs"; # share store
      url = "github:nix-community/home-manager";
    };

    crit = { inputs.nixpkgs.follows = "nixpkgs";
      url = "github:tomasz-tomczyk/crit";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations."nixos" = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        modules = [ ./system/configuration.nix ./system/custom.nix ];
      };

      homeConfigurations."koalia" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ./home/personal.nix ];
        extraSpecialArgs = { inherit inputs; username = "koalia"; };
      };

      homeConfigurations."dbennett" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ./home/work.nix ];
        extraSpecialArgs = { inherit inputs; username = "dbennett"; };
      };
    };
}
