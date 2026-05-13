{ lib }:
{
  cloudSettings = {
    email = lib.fileContents ./secrets/sensitive/email.age;
    fqdn = lib.fileContents ./secrets/sensitive/fqdn.age;
    internal = lib.fileContents ./secrets/sensitive/internal.age;
    services = {
      nextcloud = {
        subdomain = lib.fileContents ./secrets/sensitive/nextcloud-subdomain.age;
        port = 8443; # redisPort = port + 1;
        maxUploadSize = "8G";
        client_max_body_size = "8000M";
      };
      immich = {
        subdomain = lib.fileContents ./secrets/sensitive/immich-subdomain.age;
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
    nixAir = {
      publicSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUnGzmayiQ8SazjVxi8KPAmgJQQssVbSCpAerMn0Eve michele@nixAir";
      rootSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjIqDJcBd5/kw+kA8DNdM1KB2IZivH17GrIN+wEiTp5 root@nixAir";

      user = "michele";
      host = "nixAir";

      home = {
        path = "/home/michele/";
        # config = ./hosts/nixAir/home.nix;
      };
    };

    bach = {
      publicSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjDuFgmRgyjZ/Ye/QiFetZ6r+W9SGB4ufJcxzCF0ALP decillismicheledeveloper@gmail.com";
      rootSSH = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7rFUiGulUCjRKMua3OXkAyfnvkZLHwBud4kb37gT83 root@bach";

      borg-repository = lib.fileContents ./secrets/sensitive/backup-borgbase-repository.age;
      
      id = "05835d97";

      configPath = "/home/michele/nixos/#bach";
      
      user = "michele";
      host = "bach";
      
      home = {
        path = "/home/michele/";
        config = ./hosts/bach/home.nix;
      };
      
      network = {
        ip = {
          v4 = lib.fileContents ./secrets/sensitive/bach-ipv4.age;
          v6 = lib.fileContents ./secrets/sensitive/bach-ipv6.age;
        };
        gateway = lib.fileContents ./secrets/sensitive/bach-gateway.age;
        subnetMask = "255.255.252.0";
        nameservers = [ "1.1.1.1" ];
      };
    };
  };
}

