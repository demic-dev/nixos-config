{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    vimAlias = true;
    vimDiffAlias = true;
  };
}
