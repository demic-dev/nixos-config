{ lib, pkgs, ... }:
let
  personalConfig = builtins.fetchGit {
    url = "ssh://git@github.com/demic-dev/nvim";
    rev = "5f2e9ce126b55744fcc576999ad80878ab304c4c";
  };
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = personalConfig;
    force = true;
  };
}
