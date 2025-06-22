{
  config,
  lib,
  ...
}: {
  services = let
    socket = "/var/run/searx/socket";
    domain = "search.federated.nexus";
  in {
    searx = {
      enable = true;
      environmentFile = config.age.secrets."searxngSecret.age".path;

      settings = {
        general = {
          instance_name = "Federated Nexus Search";
          contact_url = "mailto:henry@henryhiles.com";
        };
        search = {
          autocomplete = "duckduckgo";
          favicon_resolver = "duckduckgo";
        };

        server = {
          base_url = "https://${domain}";

          port = "8080";
          bind_address = "unix://${socket}";
        };

        engines = lib.mapAttrsToList (name: value: {inherit name;} // value) {
          "wikidata".disabled = true;
        };
      };
    };

    caddy = {
      environmentFile = config.age.secrets."oidcJwtSecretEnv.age".path;
      virtualHosts."${domain}".extraConfig = let
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

          reverse_proxy unix/${socket}
        }
      '';
    };
  };
  systemd.services = let
    commonConfig = builtins.mapAttrs (_: value: lib.mkForce value) {
      Group = "caddy";
      RuntimeDirectoryMode = "0770";
      UMask = "007";
    };
  in {
    searx.serviceConfig = commonConfig;
    searx-init.serviceConfig = commonConfig;
  };
}
