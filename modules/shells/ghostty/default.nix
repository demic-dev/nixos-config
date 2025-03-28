{ lib, pkgs, userSettings, ... }:
{
  home.file.".config/ghostty/config" = {
    source = ./config;
    recursive = true;
  };
}
