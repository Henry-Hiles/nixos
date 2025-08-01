{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    networking.firewall.allowedTCPPorts = [443];
    services.caddy = {
      enable = true;
      email = "hen" + "ry@he" + "nryhi" + "les.c" + "om";
      environmentFile = config.age.secrets."base64JwtSecret.age".path;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/ggicci/caddy-jwt@v1.1.0"];
        hash = "sha256-sdhX/dAQ7lIxBo/ZW6XYX8SRuacLO9HobtIVKD/cw0o=";
      };

      virtualHosts =
        lib.mapAttrs (domain: host: {
          extraConfig = let
            auth = "https://auth.federated.nexus";
          in ''
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
        })
        config.services.caddy.authedHosts;
    };
  };

  options.services.caddy.authedHosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.lines;
    default = [];
  };
}
