
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
      # Until when I don't solve how to load sensitive variables in a private way, I will use this ugly approach.
      update = "source /home/michele/nixos/sensitive.sh && sudo -E nixos-rebuild switch --flake /home/michele/nixos/#bach --impure";
    };
  };
}
