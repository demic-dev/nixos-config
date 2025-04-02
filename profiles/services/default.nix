{ config, lib, pkgs, ... }:

{
  imports = [
    # Admin services
    ./ssh.nix
    ./tailscale.nix
    # Hosting services
    ./acme.nix
    ./nginx.nix
    ./fail2ban.nix
    ./postgresql.nix
    # NAS Services
    # ./calibre.nix
    ./immich.nix
    ./nextcloud.nix
    ./miniflux.nix
  ];
}
