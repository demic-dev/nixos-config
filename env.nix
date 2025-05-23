{ lib }:
{
  cloudSettings = {
    email = builtins.getEnv "EMAIL";
    fqdn = builtins.getEnv "FQDN";
    internal = builtins.getEnv "INTERNAL";
    services = {
      nextcloud = {
        subdomain = builtins.getEnv "NEXTCLOUD_SUB";
        port = 8443; # redisPort = port + 1;
        maxUploadSize = "8G";
        client_max_body_size = "8000M";
      };
      immich = {
        subdomain = builtins.getEnv "IMMICH_SUB";
        port = 2283; # redisPort = port + 1;
      };
      miniflux = {
        subdomain = "rss";
        port = 5401;
      };
      calibre = {
        subdomain = "calibre";
        port = 10291;
      };
    };
  };

  userSettings = {
    air = {
      publicSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZb619CoezLnPqNbHI+SenXRUWSLJxGycykva4ia8Sw decillismicheledeveloper@gmail.com";
      user = "micheledecillis";
      host = "air";
      home = {
        path = "/Users/micheledecillis/";
        config = ./hosts/air/home.nix;
      };
    };

    bach = {
      publicSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjDuFgmRgyjZ/Ye/QiFetZ6r+W9SGB4ufJcxzCF0ALP decillismicheledeveloper@gmail.com";
      rootSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7rFUiGulUCjRKMua3OXkAyfnvkZLHwBud4kb37gT83 root@bach";
      id = "05835d97";
      user = "michele";
      host = "bach";
      home = {
        path = "/home/michele/";
        config = ./hosts/bach/home.nix;
      };
      network = {
        ip = {
          v4 = builtins.getEnv "BACH_IPV4";
          v6 = builtins.getEnv "BACH_IPV6";
        };
        gateway = builtins.getEnv "BACH_GATEWAY";
        subnetMask = "255.255.252.0";
        nameservers = [ "1.1.1.1" ];
      };
    };
  };
}

