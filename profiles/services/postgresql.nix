{ config, pkgs, ... }:
{
  # services.postgresql = {
  #   enable = true;
  # };

  environment.persistence."/persist".directories = [
    "/var/lib/postgresql"
  ];
}
