{ config, ... }:
{
  systemd.services.prometheus.serviceConfig.SupplementaryGroups = [
    config.services.matrix-continuwuity.group
  ];

  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.7";

    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = with config.services.prometheus.exporters.node; [
              "${listenAddress}:${toString port}"
            ];
          }
        ];
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = with config.services.prometheus.exporters.unbound; [
              "${listenAddress}:${toString port}"
            ];
          }
        ];
      }
      {
        job_name = "caddy";
        static_configs = [
          { targets = [ "localhost:2019" ]; }
        ];
      }
      {
        job_name = "continuwuity";
        metrics_path = "/_continuwuity/metrics";
        static_configs = [
          { targets = [ "localhost" ]; }
        ];
        relabel_configs = [
          {
            target_label = "__unix_socket__";
            replacement = config.services.matrix-continuwuity.settings.global.unix_socket_path;
          }
        ];
      }
    ];

    exporters = {
      node = {
        enable = true;
        listenAddress = "127.0.0.3";
        enabledCollectors = [
          "systemd"
          "processes"
        ];
      };
      unbound = {
        enable = true;
        listenAddress = "127.0.0.5";
        unbound.host = "unix://${config.services.unbound.localControlSocketPath}";
        group = config.services.unbound.group;
      };
    };
  };
}
