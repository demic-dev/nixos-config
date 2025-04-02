{ self }:
{
  cloudSettings = { config }: {
    email = config.age.secrets.cloudEMAIL.path;
    fqdn = config.age.secrets.cloudFQDN.path;
    internal = config.age.secrets.cloudINTERNAL.path;
    services = {
      nextcloud = {
        subdomain = config.age.secrets.cloudNEXTCLOUD.path;
        port = 8443; # redisPort = port + 1;
        maxUploadSize = "8G";
        client_max_body_size = "8000M";
      };
      immich = {
        subdomain = config.age.secrets.cloudIMMICH.path;
        port = 2283; # redisPort = port + 1;
      };
      miniflux = {
        subdomain = "rss";
        port = 5401;
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

    bach = { config }: {
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
          v4 = config.age.secrets.bachIPV4;
          v6 = config.age.secrets.bachIPV6;
        };
        subnetMask = "255.255.252.0";
        gateway = config.age.secrets.gateway;
        nameservers = [ "1.1.1.1" ];
      };
    };
  };

  age.secrets = {
    cloudFQDN = {
      file = ./secrets/cloud/fqdn.age;
    };
    cloudEMAIL = {
      file = ./secrets/cloud/email.age;
    };
    cloudIMMICH = {
      file = ./secrets/cloud/immich.age;
    };
    cloudINTERNAL = {
      file = ./secrets/cloud/internal.age;
    };
    cloudNEXTCLOUD = {
      file = ./secrets/cloud/nextcloud.age;
    };
    bachIPV4 = {
      file = ./secrets/bach/ipv4.age;
    };
    bachIPV6 = {
      file = ./secrets/bach/ipv6.age;
    };
    bachGATEWAY = {
      file = ./secrets/bach/gateway.age;
    };
  };
}
