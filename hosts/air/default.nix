{ self, lib, pkgs, userSettings, ... }:
{
  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

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
      "ghostty"
      "netnewswire"
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
