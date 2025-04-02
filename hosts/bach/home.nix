
{ self, lib, pkgs, env, ... }:

{
  imports = [
    ../defaultHome.nix
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${env.userSettings.bach.home.path}.config";
  };

  programs.zsh = {
    shellAliases = {
      update = "nixos-rebuild switch --flake ${env.userSettings.bach.home.path}/.config/nix#air";
    };
  };
}
