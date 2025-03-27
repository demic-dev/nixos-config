{ self, lib, pkgs, ... }:
{
  imports = [
    ../defaultHome.nix
  ];

  # programs.zsh = {
  #   shellAliases = {
  #     python = "/usr/bin/python3";
  #     pip = "/usr/bin/pip";
  #     update = "darwin-rebuild switch --flake ${self}#air";
  #   };
  # };
}
