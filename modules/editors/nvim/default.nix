{ lib, pkgs, ... }:
let
  personalConfig = builtins.fetchGit {
    url = "https://github.com/demic-dev/nvim";
    rev = "aa982fe2b6da61cedf189fe4d70fc29bf0511b47";
  };
in
{
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = personalConfig;
    force = true;
  };
}
