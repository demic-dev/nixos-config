{ config, pkgs, env, ... }:
let
  fqdn = env.cloudSettings.fqdn;
  webRoot = "/var/www/${fqdn}";
in
{
  systemd.services.${fqdn} = {
    enable = true;
    description = ''
      https://${fqdn} source
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    path = [ pkgs.nix ];
    startAt = "*:0/5";
    script = ''
      set -ex

      nix build github:demic-dev/website --out-link ${webRoot} --extra-experimental-features nix-command --extra-experimental-features flakes --refresh --no-write-lock-file
    '';
  };

  # Nginx
  services.nginx.virtualHosts = {
    ${fqdn} = {
      serverName = fqdn;

      useACMEHost = fqdn;
      forceSSL = true;

      root = webRoot;
    };
    "www.${fqdn}" = {
      serverName = "www.${fqdn}";

      # enableACME = false;
      # useACMEHost = fqdn;
      # forceSSL = true;

      root = webRoot;
    };
  };
}
