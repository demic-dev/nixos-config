# =============================================================================
# configuration.nix
# =============================================================================
# 
# DESCRIPTION:
#   Centralized configuration variables for NixOS system configuration.
#   This file serves as a single source of truth for system-wide settings
#   that can be imported by other Nix modules.
#
# CONTENTS:
#   - Host-specific configurations (usernames, hostnames)
#   - System-wide constants and configuration parameters
#
# USAGE:
#   Import this file in other Nix modules to access configuration values:
#   ```
#   let
#     myConfig = import ./configuration.nix { inherit self config; };
#   in
#   {
#     # Access configuration values
#     networking.hostName = myConfig.HOSTS.MACBOOK.HOST;
#   }
#   ```
#
# AUTHOR: demic-dev
#
# =============================================================================

{ self, config, ... }:
let
  HOSTS = {
    MACBOOK = {
      USER = "micheledecillis";
      HOST = "air";
      HOME = "/Users/micheledecillis";
    };
  };
in 
{
  inherit HOSTS;
}
