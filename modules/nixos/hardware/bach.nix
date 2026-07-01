{ ... }:
{
  # bach's machine layer: nixos-generate-config hardware scan + the ZFS/impermanence
  # wiring it depends on (remote unlock in initrd + the /persist bind mounts).
  flake.nixosModules.bach-hardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      # disko/ lives at the repo root (outside ./modules so import-tree ignores it);
      # pulled in here so the aspect carries bach's whole machine layer.
      ../../../disko/remoteZFSDecrypt.nix
      ../../../disko/persistence.nix
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_scsi" "sr_mod" ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    boot.zfs.devNodes = "/dev/disk/by-uuid";

    fileSystems."/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "mode=755" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/4879-77EA";
      fsType = "vfat";
    };

    fileSystems."/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    fileSystems."/persist" = {
      device = "rpool/safe/persist";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    fileSystems."/persist/data" = {
      device = "rpool/safe/persist/data";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    swapDevices = [
      { device = "/dev/zvol/rpool/tempswap"; }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  };
}
