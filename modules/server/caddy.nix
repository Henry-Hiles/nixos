{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.services.caddy.authedHosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.lines;
    default = { };
  };

  config = {
    systemd.services.caddy.serviceConfig.Restart = lib.mkForce "always";
    networking.firewall.allowedTCPPorts = [ 443 ];
    services.caddy = {
      enable = true;
      email = "henry@henryhiles.com";
      environmentFile = config.age.secrets."base64JwtSecret.age".path;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/ggicci/caddy-jwt@v1.1.0"
          "pkg.jsn.cam/caddy-defender@v0.9.0"
        ];
        hash = "sha256-2FDvTpK608UrnOXvjzC7S2gtxf9HUOE9Mw2/E6YzBi0=";
      };

      virtualHosts = lib.mapAttrs (domain: host: {
        extraConfig =
          let
            auth = "https://auth.federated.nexus";
          in
          ''
            handle_errors 401 {
              redir https://federated.nexus/login?redirect_uri=${auth}/bridge?redirect_uri=https://${domain}{uri} 302
            }

            route {
              jwtauth {
                from_cookies id_token
                sign_key {$JWK_SECRET}
                issuer_whitelist ${auth}
                audience_whitelist proxy
              }

              ${host}
            }
          '';
      }) config.services.caddy.authedHosts;
    };
  };
}
