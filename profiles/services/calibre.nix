{ config, lib, pkgs, env, ... }:
let
  fqdn = env.cloudSettings.fqdn;
  domain = "${env.cloudSettings.services.calibre.subdomain}.${fqdn}";
  port = env.cloudSettings.services.calibre.port;
in
{
  services.calibre-web = {
    enable = true;
    listen.port = port;

    options = {
      # calibreLibrary = "/data/books";
      enableBookUploading = true;
    };
  };

  # Nginx
  services.nginx.virtualHosts.${domain} = {
    serverName = domain;

    enableACME = false;
    useACMEHost = fqdn;
    forceSSL = true;

    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://localhost:${builtins.toString port}";

      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout   600s;
        proxy_send_timeout   600s;
        send_timeout         600s;
      '';
    };
  };

  # Persistence
  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/calibre-web";
      user = "calibre-web";
      group = "calibre-web";
    }
    {
      directory = "/data/books";
      # user = "calibre-web";
      # group = "calibre-web";
    }
  ];

  users.users.calibre-web.uid = 991;
  users.groups.calibre-web.gid = 989;
}
