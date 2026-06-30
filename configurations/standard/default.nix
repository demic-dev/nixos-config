{ config, pkgs, inputs, lib, ... }:

{
  imports = [ ../../hosts/nixbook-air ];

  networking.hostName = "nixAir";

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.powersave = false;
    wifi.macAddress = "random";
  };

  networking.firewall = rec {
    enable = true;
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
    # Calibre (not default) Wireless Device Connection
    allowedTCPPorts = [ 59520 ];
  };

  time.timeZone = "Europe/Amsterdam";

  users.users.michele = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPasswordFile = config.age.secrets.michele-password.path;
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  services.logind = {
    settings.Login.HandlePowerKey = "ignore";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Default editor
    vim
    openssh
    python3
    gnumake
    unzip
    # C compiler
    gcc
    # Rust package manager
    cargo
    # Rust compiler
    rustc
    # Brightness control
    brightnessctl
    # Screenshot tools
    slurp
    grim
    # Screenshot Annotation
    satty
    # Media Players Control
    playerctl
    # LSPs
    nixd
    deadnix
    statix
    # Secrets management for Nix configurations
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    # inputs.spotatui.packages.${pkgs.stdenv.hostPlatform.system}.default
    # inputs.eduroam.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Related to https://github.com/NixOS/nixpkgs/issues/526914 REMOVE WHEN BITWARDEN UPDATED TO ELECTRON 41
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.udisks2 = {
    enable = true;
  };

  services.udev = {
    enable = true;
  };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "hyprland";

    configHome = "/home/michele";
    
    configFiles = [
      "/home/michele/.config/DankMaterialShell/settings.json"
    ];
  };

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ];

  services.tailscale = {
    enable = true;
  };

  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    tinymist
  ];

  programs.hyprland = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        type= "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  age.secrets.michele-password = {
    file = ../../secrets/michele-password.age;
  };
  age.secrets.michele-at-nixAir = {
    file = ../../secrets/michele-at-nixAir.age;
    path = "/home/michele/.ssh/id_ed25519";
    owner = "michele";
    group = "users";
    mode = "600";
  };
  # The optimal solution would be to use agenix in home-manager, but because of the ssh's passphrase for the user, it doesn't work.
  age.secrets.git-email = {
    file = ../../secrets/git-email.age;
    owner = "michele";
    group = "users";
  };
  age.secrets.noreply-github-email = {
    file = ../../secrets/noreply-github-email.age;
    owner = "michele";
    group = "users";
  };
}

