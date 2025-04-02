{ config, lib, pkgs, ... }:

{
  imports = [
   ./root.nix
   ./michele.nix
  ];
  users = {
    mutableUsers = false;
  };
}
