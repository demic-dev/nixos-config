{ config, pkgs, env, ... }:
let
  fqdn = env.cloudSettings.fqdn;
  domain = "${env.cloudSettings.services.immich.subdomain}.${env.cloudSettings.fqdn}";
  port = env.cloudSettings.services.immich.port;
  redisPort = port + 1;
in
{
  services.immich = {
    enable = true;

    port = port;
    host = "127.0.0.1";

    mediaLocation = "/persist/data/immich";

    database = {
      enable = true;

      createDB = true;
      user = "immich";
      name = "immich";
      host = "/run/postgresql";
    };

    redis = {
      enable = true;

      host = "127.0.0.1";
      port = redisPort;
    };

    settings = {
      server.externalDomain = "https://${domain}";
      backup.database.enabled = true;
    };

  };

  # Postgres
  services.postgresql = {
    ensureDatabases = [ "immich" ];
    ensureUsers = [
      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];
  };

  # Redis
  services.redis.servers.immich = {
    enable = true;
    port = redisPort;
    bind = "127.0.0.1";
  };

  # Shouldn't be necessary anymore since it's under /persist/data
  # # Persistence
  # environment.persistence."/persist".directories = [
  #   {
  #     directory = "/var/lib/immich";
  #     user = "immich";
  #     group = "immich";
  #   }
  # ];

  # Fail2Ban Jail
   services.fail2ban.jails.immich.settings = {
    filter = "immich";
    backend = "systemd";
    findtime = 86400;
    bantime  = 43200;
    maxretry = 5;
    chain = "FORWARD";
  };

  environment.etc."fail2ban/filter.d/immich.local".text = pkgs.lib.mkDefault( pkgs.lib.mkAfter ''
    [Definition]
    failregex = immich-server.*Failed login attempt for user.+from ip address\s?<ADDR>
    journalmatch = CONTAINER_TAG=immich-server
  '');

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

  users.users.immich.uid = 15015;
  users.groups.immich.gid = 15015;

  users.users.redis-immich.uid = 995;
  users.groups.redis-immich.gid = 995;
}
