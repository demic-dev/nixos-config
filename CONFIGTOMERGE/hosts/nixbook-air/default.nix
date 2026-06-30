{ config, pkgs, inputs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.systemd-boot.graceful = true;

  boot.kernel.sysctl."vm.mmap_rnd_bits" = 31;
  
  boot.kernelParams = [
    "brcmfmac.feature_disable=0x82000"
    "brcmfmac.roamoff=1"
  ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024;
  }];

  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  system.stateVersion = "25.11";
}
