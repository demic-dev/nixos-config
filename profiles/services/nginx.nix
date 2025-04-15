{ config, libs, pkgs, env, ... }:
let
  fqdn = env.cloudSettings.fqdn;
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

        useACMEHost = fqdn;
        forceSSL = true;

        locations."/" = {
          recommendedProxySettings = true;
          return = "301 $scheme://demic-website.netlify.app$request_uri";
        };
      };
      "www.${fqdn}" = {
        serverName = "www.${fqdn}";

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
