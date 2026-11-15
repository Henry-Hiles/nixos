{
  pkgs,
  config,
  lib,
  ...
}:
let
  client = "forgejo";
  sourceName = "Federated Nexus";
  cfg = config.services.forgejo;
in
{
  networking.firewall.allowedTCPPorts = [ 22 ];
  services =
    let
      domain = "git.federated.nexus";
      socket = "/run/forgejo/socket";
    in
    {
      kanidm.provision.systems.oauth2.${client} = {
        displayName = "Forgejo";
        originUrl = "https://${domain}/user/oauth2/${lib.escapeURL sourceName}/callback";
        originLanding = "https://${domain}";
        basicSecretFile = "/var/lib/kanidm-oauth2-secrets/${client}";
        preferShortUsername = true;
        scopeMaps.idm_all_persons = [
          "openid"
          "email"
          "profile"
        ];
      };

      forgejo = {
        enable = true;
        package = pkgs.forgejo; # Not LTS
        settings = {
          service = {
            ENABLE_INTERNAL_SIGNIN = false;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          };
          oauth2_client.ENABLE_AUTO_REGISTRATION = true;
          repository = {
            GO_GET_CLONE_URL_PROTOCOL = "ssh";
            DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
          };

          actions.DEFAULT_ACTIONS_URL = "github";
          admin.USER_DISABLED_FEATURES = "manage_password,deletion";

          server = {
            DOMAIN = domain;
            ROOT_URL = "https://${domain}";
            HTTP_ADDR = socket;
            PROTOCOL = "http+unix";

            START_SSH_SERVER = true;
            BUILTIN_SSH_SERVER_USER = "git";

            LANDING_PAGE = "explore";
          };

          federation.enable = true;
        };
      };

      # We may want to include regular commits, e.g. https://git.federated.nexus/Henry-Hiles/nixos/commit/21373eed250ba70ff195258d3b5a4fe039f72779, but currently this doesn't seem needed
      caddy.virtualHosts."${domain}".extraConfig = ''
        respond /robots.txt <<EOF
          User-agent: *
          Disallow: /*/*/*/commit*
          EOF 200

        @commitAnonymous {
          path_regexp commit ^/[^/]+/[^/]+/[^/]+/commit(?:/.*)?$
          not header_regexp Cookie "(^|;[[:space:]]*)session=[^;]+(;|$)"
        }

        redir @commitAnonymous /user/login?redirect_to={uri} 302

        reverse_proxy unix/${socket}
      '';
    };

  systemd = {
    services = {
      forgejo = {
        requires = [ "kanidm-oauth2-secrets.service" ];
        after = [ "kanidm-oauth2-secrets.service" ];
        serviceConfig = {
          MemoryHigh = "500M";
          MemoryMax = "600M";
          LoadCredential = "secret:${
            config.services.kanidm.provision.systems.oauth2.${client}.basicSecretFile
          }";
        };

        preStart = lib.mkAfter ''
          # So a failed list stops here, rather than adding a duplicate source
          set -o pipefail
          forgejo() { ${lib.getExe cfg.package} --config ${cfg.customDir}/conf/app.ini "$@"; }

          args=(
          	--name ${lib.escapeShellArg sourceName}
          	--provider openidConnect
          	--key ${client}
          	--secret "$(< "$CREDENTIALS_DIRECTORY/secret")"
          	--auto-discover-url ${config.services.kanidm.server.settings.origin}/oauth2/openid/${client}/.well-known/openid-configuration
          	--scopes openid --scopes email --scopes profile
          )

          # Columns are separated by tabs
          id=$(forgejo admin auth list | ${lib.getExe pkgs.gawk} -F '\t+' -v name=${lib.escapeShellArg sourceName} '$2 == name { print $1 }')
          if [ -n "$id" ]; then
          	forgejo admin auth update-oauth --id "$id" "''${args[@]}"
          else
          	forgejo admin auth add-oauth "''${args[@]}"
          fi
        '';
      };
    };
    sockets.forgejo = {
      requiredBy = [ "forgejo.service" ];
      wantedBy = [ "sockets.target" ];

      listenStreams = [
        (toString config.services.forgejo.settings.server.SSH_PORT)
      ];
    };
  };
}
