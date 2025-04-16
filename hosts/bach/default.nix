
{ config, pkgs, env, ... }:
let
  user = env.userSettings.bach.user;
  homePath = env.userSettings.bach.home.path;
in
{
  nix = {
    settings.experimental-features = "nix-command flakes";
  };
  nixpkgs.hostPlatform = "aarch64-linux";

  imports =
    [
      # System
      ./hardware-configuration.nix
      ../../disko/remoteZFSDecrypt.nix
      ../../disko/persistence.nix
      ../../profiles/networking.nix
      ../../profiles/optimization.nix
      ../../profiles/services
      ../../profiles/users
      # Security
      ../../profiles/sudo.nix
    ];
  
  time.timeZone = "Europe/Madrid";

  environment.systemPackages = with pkgs; [
    vim
    git
    tailscale
    btop
    fd
    ripgrep
    git-crypt
  ];

  users.users.${user} = {
    name = user;
    home = homePath;
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
