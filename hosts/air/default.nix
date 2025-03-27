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
    pkgs.ripgrep
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

  users.users.${userSettings.air.user} = {
    name = userSettings.air.user;
    home = userSettings.air.home.path;
  };

  # Required for backward compatibility
  system = {
    stateVersion = 4;
  };
}
