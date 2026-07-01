{ ... }:
{
  # Graphical SYSTEM stack (Hyprland + DankMaterialShell greeter + keyring/portal plumbing).
  # Host-specific bits (hostName, networking, users, secrets, timezone, packages) stay inline
  # in the host file — this aspect is the reusable desktop base.
  flake.nixosModules.desktop = { config, lib, pkgs, env, ... }:
    let
      # Resolve the desktop user's home from env by the host being built, so adding another
      # desktop host only needs an env.userSettings.<host> entry — no edit here.
      homePath = env.userSettings.${config.networking.hostName}.home.path;
    in
    {
    programs.hyprland.enable = true;

    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "hyprland";
      configHome = lib.removeSuffix "/" homePath;
      configFiles = [ "${homePath}.config/DankMaterialShell/settings.json" ];
    };

    security.polkit.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    # gcr provides the gcr-ssh-agent / pkcs11 D-Bus services the keyring relies on.
    services.dbus.packages = [ pkgs.gcr ];

    services.logind.settings.Login.HandlePowerKey = "ignore";

    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    services.udisks2.enable = true;
    services.udev.enable = true;

    fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [ tinymist ];

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
