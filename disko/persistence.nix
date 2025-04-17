{ config, libs, pkgs, ... }:

{
  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
    ];

    directories = [
      "/var/log"
      "/home"
    ];
  };
}
