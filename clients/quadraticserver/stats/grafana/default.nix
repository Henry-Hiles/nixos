{
  config,
  pkgs,
  ...
}:

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
        declarativePlugins = with pkgs.grafanaPlugins; [
          prometheus
        ];

        settings = {
          unified_alerting.enabled = false;

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
              name = "Node Exporter";
              options.path = pkgs.fetchurl {
                name = "dashboard-node-exporter-full.json";
                url = "https://grafana.com/api/dashboards/1860/revisions/42/download";
                hash = "sha256-pNgn6xgZBEu6LW0lc0cXX2gRkQ8lg/rer34SPE3yEl4=";
              };
            }
            {
              name = "Unbound Info";
              options.path = pkgs.fetchurl {
                name = "unbound-info.json";
                url = "https://github.com/rfmoz/grafana-dashboards/raw/refs/heads/master/prometheus/unbound-full.json";
                hash = "sha256-1kV92oMHB3IgH6WnCJeVhmA20Hi61iBiYN+HZqA29b0=";
              };
            }
            {
              name = "Continuwuity Stats";
              options.path = pkgs.fetchurl {
                name = "continuwuity-stats.json";
                url = "https://continuwuity.org/guides/grafana-dashboard.json";
                hash = "sha256-1s7vFEaZMiqH9h//BdrBwtWuYiqlxzUmYwdpMPYyuMo=";
              };
            }
            {
              name = "Caddy Hosts";
              options.path = pkgs.stdenv.mkDerivation {
                pname = "caddy-hosts-json";
                version = "1.0.0";
                dontUnpack = true;

                src = pkgs.fetchurl {
                  name = "caddy-hosts.json";
                  url = "https://grafana.com/api/dashboards/24146/revisions/1/download";
                  hash = "sha256-vw/O3bNKQ0tJwhsZKYvkMU6jeqkG+sfCtA7YT0vp3YY=";
                };

                installPhase = ''
                  mkdir -p $out
                  sed 's|''${DS_PROMETHEUS}|prometheus|g' $src > $out/caddy-exporter.json
                '';
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
