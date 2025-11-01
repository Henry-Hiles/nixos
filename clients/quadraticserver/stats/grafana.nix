{ config, pkgs, ... }@attrs:

let
  secretName = "grafanaSecret";
  passwordName = "grafanaPassword";
  mailPasswordName = "mailPassword";
  credentialDirectory = "/run/credentials/grafana.service/";
in
{
  systemd.services.grafana.serviceConfig.LoadCredential = [
    "${secretName}:${config.age.secrets."grafanaSecret.age".path}"
    "${passwordName}:${config.age.secrets."grafanaPassword.age".path}"
    "${mailPasswordName}:${config.age.secrets."smtpPassword.age".path}"
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

          smtp = {
            enabled = true;
            host = "mail.henryhiles.com";
            user = config.services.caddy.email;
            password = "$__file{${credentialDirectory}${mailPasswordName}}";
            from_address = "alerts@federated.nexus";
            from_name = "Grafana Alerts";
          };

          "auth.anonymous".enabled = true;
          users.default_theme = "system";
          analytics.feedback_links_enabled = false;
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

          alerting = {
            contactPoints = [
              {
                name = "Email";
                receivers = [
                  {
                    type = "email";
                    uid = "email";
                    settings.addresses = config.services.grafana.settings.smtp.user;
                  }
                ];
              }
            ];

            settings = {
              policies = [
                {
                  orgId = 1;
                  receiver = "grafana-default-email";
                  group_by = [ "..." ];
                  matchers = [
                    "alertname = Watchdog"
                    "severity =~ \"warning|critical\""
                  ];
                  mute_time_intervals = [
                    "abc"
                  ];
                  group_wait = "30s";
                  group_interval = "5m";
                  repeat_interval = "4h";
                }
              ];

            };
          };
        };
      };
      caddy.virtualHosts."${domain}".extraConfig =
        "reverse_proxy unix/${config.services.grafana.settings.server.socket}";
    };

  users.users.caddy.extraGroups = [ "grafana" ];
}
