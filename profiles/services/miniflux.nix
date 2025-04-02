{ config, pkgs, env, ... }:
let
  internal = env.cloudSettings.internal;
  domain = "${env.cloudSettings.services.miniflux.subdomain}.${env.cloudSettings.internal}";
  port = env.cloudSettings.services.miniflux.port;
in
{
  services.miniflux = {
    enable = true;

    config = {
      CREATE_ADMIN = 1;
      LISTEN_ADDR = "127.0.0.1:${port}";

      HTTPS = 1;
    };

    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets.miniflux_admin_pass.path;

  };

  # Nginx
  services.nginx.virtualHosts.${domain} = {
    serverName = domain;

    enableACME = false;
    useACMEHost = internal;
    forceSSL = true;

    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://localhost:${port}";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_read_timeout   600s;
        proxy_send_timeout   600s;
        send_timeout         600s;
      '';
    };
  };

  # Agenix
  age.secrets = {
    miniflux_admin_pass = {
      file = ../secrets/miniflux_admin_pass.age;
    };
  };
}
