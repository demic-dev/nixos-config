{ self, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "cursor" "line" ];

    history.size = 10000;

    plugins = [
      {
        name = "cobalt2";
        src = builtins.fetchGit {
          url = "https://github.com/wesbos/Cobalt2-iterm";
          rev = "b3a40ad59f907c9d290aba8d7c7d18434aa9d662";
        };
        file = "cobalt2.zsh-theme";
      }
    ];

    oh-my-zsh = {
      enable = true;
    };
  };
}
