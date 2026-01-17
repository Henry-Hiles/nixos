{
  config,
  inputs,
  pkgs,
  ...
}:
{
  services =
    let
      domain = "dav.henryhiles.com";
    in
    {
      davis = {
        enable = true;
        hostname = domain;
        appSecretFile = config.age.secrets."davSecret.age".path;
        adminPasswordFile = config.age.secrets."davPassword.age".path;
        package = inputs.nixpkgs-master.legacyPackages.${pkgs.stdenv.hostPlatform.system}.davis;
        nginx = null;

        poolConfig = with config.services.caddy; {
          "listen.owner" = user;
          "listen.group" = group;
        };
      };

      caddy.virtualHosts."${domain}".extraConfig = ''
        encode zstd gzip
        header {
            -Server
            -X-Powered-By
            Strict-Transport-Security max-age=31536000;
            X-Content-Type-Options nosniff
            Referrer-Policy no-referrer-when-downgrade
        }

        root * ${config.services.davis.package}/public
        php_fastcgi unix/${config.services.phpfpm.pools.davis.socket}
        file_server

        redir /.well-known/carddav /dav/ 301
        redir /.well-known/caldav /dav/ 301
      '';
    };
}
