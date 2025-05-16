{ self, lib, pkgs, env, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    fd
    ripgrep
    git-crypt
    zathura
    texliveFull
    pandoc
    go
    hugo
  ];
}
