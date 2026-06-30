{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alF --color=auto";
      la = "ls -A --color=auto";
      update = "nixos-rebuild switch --flake ~/.nixos#nixAir --sudo";
    };

    plugins = [
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
    ];
  };

  # programs.bash.interactiveShellInit = ''
  #   if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  #   then
  #     shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #     exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #   fi
  # '';
}
