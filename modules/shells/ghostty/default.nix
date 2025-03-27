{ lib, pkgs, userSettings, ... }:
{
  home.file.".config/ghostty" = {
    source = ./ghostty;
    recursive = true;
  };
}
