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
    pkgs.fd
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
    home = myConfig.HOSTS.MACBOOK.HOME;
  };


  home-manager.users.${myConfig.HOSTS.MACBOOK.USER} = {
    programs = {
      home-manager.enable = true;
    };

    imports = [
      ../modules/editors/nvim
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${myConfig.HOSTS.MACBOOK.HOME}/.config";
    };

    # Required for internal compatibility
    home.stateVersion = "23.05";
  };

  # Required for backward compatibility
  system = {
    stateVersion = 4;
  };
}
