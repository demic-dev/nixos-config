{ ... }:
{
  # Shared git config, identical on every host
  flake.homeModules.git = { osConfig, ... }:
    {
      programs.git = {
        enable = true;

        includes = [
          { path = osConfig.age.secrets.git-email.path; }
          { condition = "hasconfig:remote.*.url:git@github.com:*/**"; path = osConfig.age.secrets.noreply-github-email.path; }
          { condition = "hasconfig:remote.*.url:https://github.com/**"; path = osConfig.age.secrets.noreply-github-email.path; }
        ];

        settings = {
          user.name = "demic-dev";

          init.defaultBranch = "main";
          merge.conflictstyle = "diff3";
          diff.colorMoved = "default";
          pull.ff = "only";
          push.autoSetupRemote = true;

          color.ui = true;
        };
      };
    };
}
