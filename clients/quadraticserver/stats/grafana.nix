{ config, pkgs, ... }:

let
  secretName = "grafanaSecret";
  passwordName = "grafanaPassword";
  credentialDirectory = "/run/credentials/grafana.service/";
in
{
  systemd.services.grafana.serviceConfig.LoadCredential = [
    "${secretName}:${config.age.secrets."grafanaSecret.age".path}"
    "${passwordName}:${config.age.secrets."grafanaPassword.age".path}"
  ];

  services =
    let
      domain = "status.federated.nexus";
    in
    {
      grafana = {
        enable = true;
        declarativePlugins = [ ];
        settings = {
          analytics.feedback_links_enabled = false;
          users.default_theme = "system";
          server = {
            inherit domain;
            root_url = "https://${domain}";
            protocol = "socket";
          };

          security = {
            cookie_secure = true;
            secret_key = "$__file{${credentialDirectory}${secretName}}";

            admin_user = "quadradical";
            admin_password = "$__file{${credentialDirectory}${passwordName}}";
          };
        };

        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              uid = "prometheus";
              url = with config.services.prometheus; "http://${listenAddress}:${toString port}";
              jsonData.timeInterval = config.services.prometheus.globalConfig.scrape_interval;
            }
          ];

          dashboards.settings.providers = [
            {
              name = "Status";
              options.path = (import ../../../lib/status.nix { inherit pkgs; }) [
                {
                  name = "Continuwuity (Matrix)";
                  service = "continuwuity.service";
                }
                {
                  name = "Forgejo (Git)";
                  service = "forgejo.service";
                }
                {
                  name = "SearXNG (Search)";
                  service = "searx.service";
                }
              ];
            }
            {
              name = "Node exporter";
              options.path = pkgs.fetchurl {
                name = "dashboard-node-exporter-full.json";
                url = "https://grafana.com/api/dashboards/1860/revisions/42/download";
                hash = "sha256-pNgn6xgZBEu6LW0lc0cXX2gRkQ8lg/rer34SPE3yEl4=";
              };
            }
          ];
        };
      };
      caddy.virtualHosts."${domain}".extraConfig = ''
        redir / /public-dashboards/cf91b463711b401b8bf6336125f70cd3
        reverse_proxy unix/${config.services.grafana.settings.server.socket}
      '';
    };

  users.users.caddy.extraGroups = [ "grafana" ];
}
