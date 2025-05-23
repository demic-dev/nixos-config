{ config, pkgs, ... }:

{
  users.users.michele = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ ];

    initialHashedPassword = "$6$DptngetaTDY6G.qa$tEWVAEGlpkvzUltZXYaZpQz4c40KOQG3eQXhwhcQn33oM02NyemgBFSa/G6Mzb9iKbTroI7uKd7AWgBfKuUGF.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZb619CoezLnPqNbHI+SenXRUWSLJxGycykva4ia8Sw decillismicheledeveloper@gmail.com"
    ];

    shell = pkgs.zsh;
    # zsh is installed, but maybe since it's loaded with home manager it can't be found during compilation
    ignoreShellProgramCheck = true;
 };
}
