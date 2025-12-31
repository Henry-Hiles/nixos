{ config, ... }:
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.7";

    globalConfig.scrape_interval = "3s";
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
        job_name = "caddy";
        static_configs = [
          { targets = [ "localhost:2019" ]; }
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
    };
  };
}
