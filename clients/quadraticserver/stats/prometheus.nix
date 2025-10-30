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
    ];

    exporters.node = {
      enable = true;
      listenAddress = "127.0.0.3";
      enabledCollectors = [
        "systemd"
        "processes"
      ];
      # disabledCollectors = [
      #   "arp"
      #   "bcache"
      #   "bonding"
      #   "btrfs"
      #   "conntrack"
      #   "dmi"
      #   "edac"
      #   "entropy"
      #   "exec"
      #   "fibrechannel"
      #   "filefd"
      #   "hwmon"
      #   "infiniband"
      #   "ipvs"
      #   "mdadm"
      #   "netclass"
      # ];
    };
  };
}
