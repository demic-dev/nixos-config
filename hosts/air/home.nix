{ self, lib, pkgs, userSettings, ... }:
{
  imports = [
    ../defaultHome.nix
  ];

  programs.zsh = {
    shellAliases = {
      python = "/usr/bin/python3";
      pip = "/usr/bin/pip";
      update = "darwin-rebuild switch --flake ${userSettings.air.home.path}/.config/nix#air";
    };
  };
}
