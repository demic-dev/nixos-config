{ config, lib, pkgs, ... }:
let
  externalInit = builtins.readFile ./ecosse3.nvim/init.lua;
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = ./ecosse3.nvim;
  };
}
