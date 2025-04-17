{ config, pkgs, ... }:
{
  nix.optimise = {
    automatic = true;
    dates = [ "04:00" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
    persistent = true;
  };
}
