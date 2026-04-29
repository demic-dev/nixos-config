{ config, pkgs, env, inputs, ... }:
let
  fqdn = env.cloudSettings.fqdn;
  domain = "caccaculo.${env.cloudSettings.fqdn}";

  port = 41921;

  user = env.userSettings.nixAir.user;
in
{
  users.users.${user}.extraGroups = [ "docker" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/ghost-blog 0755 root root -"
  ];

  # NixOS native way to run docker containers
  virtualisation.oci-containers = {
    containers.ghost-blog = {
      image = "ghost:latest";
      ports = [ "${toString port}:2368" ];
      
      environment = {
        # Using the domain instead of localhost
        url = "https://${domain}"; 
        # Must be development for SQLite, production requires MySQL
        NODE_ENV = "development";
        database__client = "sqlite3";
      };

      volumes = [
        "/var/lib/ghost-blog:/var/lib/ghost/content"
      ];
    };
  };

  # Nginx reverse proxy
  services.nginx.virtualHosts.${domain} = {
    serverName = domain;

    enableACME = false;
    useACMEHost = fqdn;
    forceSSL = true;

    locations."/" = {
      recommendedProxySettings = true;

      proxyPass = "http://localhost:${builtins.toString port}";
      proxyWebsockets = true;
    };
  };
}
