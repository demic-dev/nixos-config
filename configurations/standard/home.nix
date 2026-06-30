{ pkgs, inputs, ... }:
{
  home.username = "michele";
  home.homeDirectory = "/home/michele";

  imports = [
    ../../modules/zsh.nix
    ../../modules/git
    ../../modules/ghostty
    ../../modules/xdg
    ../../modules/hyprland
    ../../modules/dms
    ../../modules/kdeconnect
    ../../modules/gruvbox-wallpapers
    ../../modules/fish
    ../../modules/nushell
  ];

  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
            # replace with your favorite file manager
            file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        };
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  home.packages = with pkgs; [
    # Claude Code
    claude-code
    # Proton Authenticator
    proton-authenticator
    # Anki Notes
    anki
    # Age Crypt
    git-agecrypt
    # zip copmresser
    zip
    # 7zip (un)compresser
    p7zip
    # SpreadSheet Calculator 
    sc-im
    # Image viewer
    loupe
    # GNOME Keyring
    gcr
    # GNOME Keyring GUI
    seahorse
    # GNOME Keys API
    libsecret
    # XDG tools
    xdg-utils
    # Desktop Apps
    bitwarden-desktop
    signal-desktop
    neovim
    # Discord
    vesktop
    # PDF viewer
    zathura
    # E-book manager
    calibre
    nextcloud-client
    chromium
    # File Manager
    kdePackages.dolphin
    # KDE CLI tools
    kdePackages.kde-cli-tools
    # Unfree Apps
    obsidian
    vscode
    # Zen Browser Flake
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Typst Neovim Plugin
    vimPlugins.typst-preview-nvim
    # Client for websockets. Required for TypstPreview
    websocat
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
    fish.enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
      };
    };
  };
  home.file.".ssh/id_ed25519.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUnGzmayiQ8SazjVxi8KPAmgJQQssVbSCpAerMn0Eve michele@nixAir
  '';

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
