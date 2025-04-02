{ self, lib, pkgs, ... }:
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
  };

  # Required for internal compatibility
  home.stateVersion = "23.05";
}
