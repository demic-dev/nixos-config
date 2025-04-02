{ config, lib, pkgs, env, ...  }:
let
  hostName = env.userSettings.bach.host;
  hostId = env.userSettings.bach.id;

  ipv4 = env.userSettings.bach.network.ip.v4;
  ipv6 = env.userSettings.bach.network.ip.v6;
  gateway = env.userSettings.bach.network.gateway;
  nameservers = env.userSettings.bach.network.nameservers;
in
{
  networking = {
    inherit hostName hostId nameservers;

    networkmanager.enable = false;

    interfaces.enp7s0 = {
      useDHCP = false;

      ipv4.addresses = [{
        address = ipv4;
        prefixLength = 22;
      }];

      ipv6.addresses = [{
        address = ipv6;
        prefixLength = 64;
      }];
    };

    defaultGateway = gateway;

    firewall.enable = true;
  };
}
