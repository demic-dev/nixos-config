{ self, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Michele De Cillis";
    userEmail = "decillismicheledeveloper@gmail.com";
    ignores = [
      ".DS_Store"
      "**/.DS_Store" 
    ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
