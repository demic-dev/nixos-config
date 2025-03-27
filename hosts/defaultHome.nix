{ self, lib, pkgs, userSettings, ... }:
{
  imports = [
    ( import ../../modules/editors/nvim { inherit pkgs userSettings lib; } )
  ];

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
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # autosuggestions.enable = true;
    # syntaxHighlighting.enable = true;
    history.size = 10000;

    oh-my-zsh = {
      enable = true;

      theme = "cobalt2";
    };
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "${userSettings.air.home}/.config";
  };

  # Required for internal compatibility
  home.stateVersion = "23.05";
}
