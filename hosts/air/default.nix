{ self, lib, pkgs, userSettings, ... }:
{
  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = [
    pkgs.fd
  ];

  # Brew
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [];
    brews = [
      "neofetch"
      "ncspot"
    ];
    casks = [
      "signal"
      "telegram"
      "spotify"
      "bitwarden"
      "tailscale"
      "anki"
      "iterm2"
      "discord"
      "figma"
      "calibre"
      "anytype"
      "thunderbird"
      # "zen-browser"
    ];
  };

  programs = {
    zsh.enable = true;
  };

  users.users.${userSettings.air.user} = {
    name = userSettings.air.user;
    home = userSettings.air.home;
  };


  home-manager.users.${userSettings.air.user} = {
    programs = {
      home-manager.enable = true;
    };

    imports = [
      ( import ../../modules/editors/nvim { inherit pkgs userSettings lib; } )
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${userSettings.air.home}/.config";
    };

    # Required for internal compatibility
    home.stateVersion = "23.05";
  };

  # Required for backward compatibility
  system = {
    stateVersion = 4;
  };
}
