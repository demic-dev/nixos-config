
{ self, lib, pkgs, env, config, ... }:
let
  homePath = env.userSettings.bach.home.path;
in
{
  imports = [
    ../defaultHome.nix
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${homePath}.config";
  };

  programs.zsh = {
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /home/.config-flakes/#bach";
    };
  };
}
