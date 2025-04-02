{ config, libs, pkgs, env, ... }:
let
  ipv4 = env.userSettings.bach.network.ip.v4;
  gateway = env.userSettings.bach.network.gateway;
  subnetMask = env.userSettings.bach.network.subnetMask;

  airSSH = env.userSettings.air.publicSSH;
in
{
  boot = {
    kernelParams = [ "ip=${ipv4}::${gateway}:${subnetMask}::enp7s0:none" ];
    supportedFilesystems = [ "zfs" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      kernelModules = [
        "virtio-pci"
      ];

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = [
            /persist/etc/secrets/initrd/ssh_host_ed25519_key
          ];
          authorizedKeys = [
            airSSH;
          ];
        };

        # this will automatically load the zfs password prompt on login
        # and kill the other prompt so boot can continue
        postCommands = ''
          cat <<EOF > /root/.profile
          if pgrep -x "zfs" > /dev/null
          then
            zfs load-key -a
            killall zfs
          else
            echo "zfs not running -- maybe the pool is taking some time to load for some unforseen reason."
          fi
          EOF
        '';
      };
    };
  };
}
