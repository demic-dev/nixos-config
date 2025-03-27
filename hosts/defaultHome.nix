{ self, lib, pkgs, userSettings, ... }:
{
  imports = [
    ../modules/git
    ../modules/editors/nvim
    ../modules/shells/zsh
    ../modules/shells/ghostty
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "${userSettings.air.home.path}.config";
  };

  # Required for internal compatibility
  home.stateVersion = "23.05";
}
