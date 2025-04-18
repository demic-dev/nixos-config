{ lib, pkgs, ... }:
let
  personalConfig = builtins.fetchGit {
    url = "ssh://git@github.com/demic-dev/nvim";
    rev = "874c577f3680210fe8ced0adf380ddc7c903413d";
  };
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = personalConfig;
    force = true;
  };
}
