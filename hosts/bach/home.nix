
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
      update = "nixos-rebuild switch --flake ${homePath}/.config/nix#bach";
    };
  };
}
