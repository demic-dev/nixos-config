{ self, lib, pkgs, env, ... }:
{
  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  imports =
    [
      # System
      ../default.nix
    ];

  # Source: https://macos-defaults.com/
  system = {
    defaults = {
      finder = {
        FXEnableExtensionChangeWarning = false;

        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
        QuitMenuItem = true;
        CreateDesktop = false;
        ShowPathbar = true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";

        AppleShowAllExtensions = true;

        _HIHideMenuBar = true;
        AppleFontSmoothing = 2;
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;
      };

      dock = {
        autohide = true;

        orientation = "bottom";
        show-recents = false;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
  ];

  # Brew
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    brews = [
      "neofetch"
      "ncspot"
      "node"
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
      "ghostty"
      "netnewswire"
      "nextcloud"
      # "visual-studio-code"
      "nordvpn"
      "figma"
      # "zen-browser"
    ];
  };

  users.users.${env.userSettings.air.user} = {
    name = env.userSettings.air.user;
    home = env.userSettings.air.home.path;
  };

  # Required for backward compatibility
  system.stateVersion = 4;
}
