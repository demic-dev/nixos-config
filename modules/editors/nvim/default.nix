{ lib, pkgs, ... }:
let
  personalConfig = builtins.fetchGit {
    url = "https://github.com/demic-dev/nvim";
    # ref = "main";
    rev = "d9d32cd2b8cd27681a3c347166525bc7a6d72ad6";
  };
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = personalConfig;
    force = true;
  };
}
