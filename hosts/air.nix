{ self, config, lib, pkgs, inputs, ... }:
let
  myConfig = import ../configuration.nix { inherit self config; };
in
{
  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = [
    pkgs.neofetch
    pkgs.ncspot
    pkgs.neovim
  ];

  # Brew
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [];
    brews = [];
    casks = [];
  };

  programs = {
    zsh.enable = true;
  };

  users.users.${myConfig.HOSTS.MACBOOK.USER} = {
    name = myConfig.HOSTS.MACBOOK.USER;
    home = "/Users/${myConfig.HOSTS.MACBOOK.USER}";
  };


  home-manager.users.${myConfig.HOSTS.MACBOOK.USER} = {
    programs.home-manager.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # Required for internal compatibility
    home.stateVersion = "23.05";
  };

  # Required for backward compatibility
  system = {
    stateVersion = 4;
  };
}
