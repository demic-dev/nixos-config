{ lib, pkgs, userSettings, ... }:
let
  ecosse3 = builtins.fetchGit {
    url = "https://github.com/ecosse3/nvim";
    rev = "0e7ee1853e9f57c5954ba2544ba63d8b689f06f2";
  };
  miragianCycle = builtins.fetchGit {
    url = "https://github.com/MiragianCycle/OVIWrite";
    rev = "e64930f38ab619e315ca71c47e7edd286ba2b4f2";
  };
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim/init.lua" = {
    source = ./config/init.lua;
  };

  home.file.".config/nvim/ecosse3" = {
    source = ecosse3;
  };

  home.file.".config/nvim/miragianCycle" = {
    source = miragianCycle;
  };
}
