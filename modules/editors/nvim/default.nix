{ lib, pkgs, ... }:
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

  # Handle multiple configuration with path aliases: https://github.com/neovim/neovim/commit/d34c64e342dfba9248d1055e702d02620a1b31a8
  home.file.".config/nvim-org" = {
    source = ./config;
    force = true;
  };

  home.file.".config/nvim-coding" = {
    source = ecosse3;
    force = true;
  };

  home.file.".config/nvim-write" = {
    source = miragianCycle;
    force = true;
  };
}
