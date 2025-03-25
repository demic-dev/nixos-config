{ config, lib, pkgs, ... }:
let
  ecosse3 = builtins.fetchGit {
    url = "https://github.com/ecosse3/nvim";
    rev = "0e7ee1853e9f57c5954ba2544ba63d8b689f06f2";
  };
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = ecosse3;
  };
}
