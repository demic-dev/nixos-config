{ config, pkgs, env, ... }:
{
  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 36;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    datasets."rpool/safe/persist" = {
      useTemplate = [ "backup" ];
    };
  };

  services.borgbackup.jobs."borgbase" = {
    paths = [
      "/home"
      "/data"
      "/etc/machine-id"
      "/var/log"
      "/var/lib/acme"
      "/var/lib/calibre-web"
      "/var/lib/postgresql"
      "/var/lib/tailscale"
    ];
    exclude = [
    ];
    # It's an antipattern, but it's okay since it is just and I don't want to expose it in the config
    repo = pkgs.lib.fileContents config.age.secrets.backup-borgbase-repository.path;
    preHook = ''
      ${pkgs.zfs}/bin/zfs destroy rpool/safe/persist@borgbase && true
      ${pkgs.zfs}/bin/zfs snapshot rpool/safe/persist@borgbase
      /run/current-system/sw/bin/mkdir -p /var/tmp/borgjobs
      /run/wrappers/bin/mount --bind /persist/.zfs/snapshot/borgbase /var/tmp/borgjobs/
    '';
    postHook = ''
      /run/wrappers/bin/umount /var/tmp/borgjobs/
      ${pkgs.zfs}/bin/zfs destroy rpool/safe/persist@borgbase
    '';
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /run/agenix/backup_passphrase";
    };
    environment.BORG_RSH = "ssh -i /home/michele/.ssh/id_ed25519";
    compression = "auto,lzma";
    startAt = "daily";

    user = "root";
    group = "root";
  };

  # Agenix
  age.secrets = {
    backup_passphrase = {
      file = ../../secrets/backup_passphrase.age;
    };
    backup-borgbase-repository = {
      file = ../../secrets/backup-borgbase-repository.age;
    };
  };
}
