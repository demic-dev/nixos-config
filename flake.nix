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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    systemSettings = { };
    userSettings = {
      writingEnvironment = "dev";

      air = {
        user = "micheledecillis";
        host = "air";
        home = {
          path = "/Users/micheledecillis/";
          config = ./hosts/air/home.nix;
        };
      };
    };
  in
  {
    darwinConfigurations.${userSettings.air.host} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit systemSettings;
        inherit userSettings;
      };
      modules = [
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userSettings.air.user} = userSettings.air.home.config;
        }
        ./hosts/air
      ];
    };
  };
}
