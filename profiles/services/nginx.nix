{ config, libs, pkgs, env, ... }:
let
  fqdn = env.cloudSettings.fqdn;
  port = env.cloudSettings.services.miniflux.port;
in
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      ${fqdn} = {
        serverName = fqdn;

        enableACME = true;
        forceSSL = true;

        locations."/" = {
          recommendedProxySettings = true;
          return = "301 $scheme://demic-website.netlify.app$request_uri";
        };
      };
      "www.${fqdn}" = {
        serverName = fqdn;

        enableACME = false;
        useACMEHost = fqdn;
        forceSSL = true;

        locations."/" = {
          recommendedProxySettings = true;
          return = "301 $scheme://demic-website.netlify.app$request_uri";
        };
      };
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
