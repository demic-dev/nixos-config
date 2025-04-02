{
  description = "My MacBook Air configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, impermanence, agenix }:
  let
    env = import ./env.nix { inherit self; };
  in
  {
    nixosConfigurations.bach = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs self env;
      };
      modules = [
        impermanence.nixosModules.impermanence
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit env;
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${env.userSettings.bach.user} = env.userSettings.air.home.config; 
        }
        ./hosts/bach
      ];
    };

    darwinConfigurations.air = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit env;
      };
      modules = [
        home-manager.darwinModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit env;
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.micheledecillis = ./hosts/air/home.nix; 
        }
        ./hosts/air
      ];
    };
  };
}
