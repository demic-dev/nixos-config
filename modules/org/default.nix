{ lib, pkgs, ... }:
let
  orgfiles = builtins.fetchGit {
    url = "ssh://git@github.com/demic-dev/org";
    rev = "c297c8668e2560a10c4ac476dc5439106bec1468";
  };
in
{
  programs.neovim.enable = true;

  # STATE: change enabled to true, git pull and decrypt
  home.file.".org" = {
    enable = false;
    source = orgfiles;
    force = true;
  };
}

