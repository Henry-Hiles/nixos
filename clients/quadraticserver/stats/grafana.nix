{ config, pkgs, ... }@attrs:

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

          "auth.anonymous".enabled = true;
          analytics.feedback_links_enabled = false;
          users.default_theme = "system";
          dashboards.default_home_dashboard_path = toString (import ../../../lib/status.nix attrs);
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
      caddy.virtualHosts."${domain}".extraConfig =
        "reverse_proxy unix/${config.services.grafana.settings.server.socket}";
    };

  users.users.caddy.extraGroups = [ "grafana" ];
}
