{ config, pkgs, env, ... }:
let
  fqdn = env.cloudSettings.fqdn;
  domain = "${env.cloudSettings.services.immich.subdomain}.${env.cloudSettings.fqdn}";
  port = env.cloudSettings.services.immich.port;
  redisPort = port + 1;

  immichPath = "/data/immich";

  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  # not the best approach. it is temporary until I do not update nixos to the latest version
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;

    port = port;
    host = "127.0.0.1";

    mediaLocation = "/persist${immichPath}";

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
  environment.persistence."/persist".directories = [
    {
      directory = immichPath;
      user = "immich";
      group = "immich";
    }
  ];

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
        proxy_set_header Host $host; 
        proxy_set_header X-Forwarded-Proto $scheme; 
        proxy_set_header X-Real-IP $remote_addr; 
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_max_temp_file_size 16384m; 
      '';
    };
  };

  users.users.immich.uid = 15015;
  users.groups.immich.gid = 15015;

  users.users.redis-immich.uid = 995;
  users.groups.redis-immich.gid = 995;
}
