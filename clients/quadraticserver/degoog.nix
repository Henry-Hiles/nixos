{ inputs, config, ... }:
{
  imports = [ inputs.degoog.nixosModules.default ];
  services =
    let
      domain = "search.federated.nexus";
      client = "search";
      proxySocket = "/run/oauth2-proxy/socket";
      proxy = "unix/${proxySocket}";
    in
    {
      degoog = {
        enable = true;
        configurePostgres = true;

        environment.DEGOOG_UNIX_SOCKET = "/var/run/degoog/degoog.sock";
      };

      kanidm.provision.systems.oauth2.${client} = {
        displayName = "Search";
        originUrl = "https://${domain}/oauth2/callback";
        originLanding = "https://${domain}";
        basicSecretFile = "/var/lib/kanidm-oauth2-secrets/${client}";
        preferShortUsername = true;
        scopeMaps.idm_all_persons = [
          "openid"
          "email"
          "profile"
        ];
      };

      oauth2-proxy = {
        enable = true;
        provider = "oidc";
        clientID = client;
        clientSecretFile = config.services.kanidm.provision.systems.oauth2.${client}.basicSecretFile;
        oidcIssuerUrl = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${client}";
        httpAddress = "unix://${proxySocket},mode=0660";
        reverseProxy = true;
        trustedProxyIP = [ "127.0.0.1/32" ];

        email.domains = [ "*" ];
        cookie.secretFile = config.age.secrets."cookieSecret.age".path;
        extraConfig = {
          code-challenge-method = "S256";
          skip-provider-button = true;
          whitelist-domain = domain;
        };
      };

      caddy.virtualHosts.${domain}.extraConfig = ''
        handle /oauth2/* {
          reverse_proxy ${proxy} {
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-Uri {uri}
          }
        }

        handle {
          forward_auth ${proxy} {
            uri /oauth2/auth
            header_up X-Real-IP {remote_host}

            @unauthenticated status 401
            handle_response @unauthenticated {
              redir * /oauth2/start?rd={scheme}://{host}{uri} 302
            }
          }

          reverse_proxy unix/${config.services.degoog.environment.DEGOOG_UNIX_SOCKET}
        }
      '';
    };

  systemd.services = {
    caddy.serviceConfig.SupplementaryGroups = [
      "degoog"
      "oauth2-proxy"
    ];

    oauth2-proxy = {
      requires = [ "kanidm.service" ];
      after = [
        "kanidm.service"
        "caddy.service"
      ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "oauth2-proxy";
        RuntimeDirectoryMode = "0750";
      };
    };
  };
}
