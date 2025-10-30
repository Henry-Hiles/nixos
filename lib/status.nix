{ pkgs, lib, ... }:
services:
pkgs.writers.writeJSON "status.json" {
  title = "Service Status";
  panels = lib.imap0 (
    index:
    { name, service }:
    {
      title = name;
      type = "stat";
      gridPos = rec {
        h = 3;
        w = 4;
        x = index * w;
        y = index * h;
      };
      datasource = {
        type = "prometheus";
        uid = "prometheus";
      };
      fieldConfig = {
        defaults = {
          color.mode = "thresholds";
          mappings = [
            {
              options = {
                "0".text = "Failed";
                "1".text = "Running";
              };
              type = "value";
            }
          ];
          thresholds = {
            mode = "absolute";
            steps = [
              {
                color = "red";
                value = 0;
              }
              {
                color = "green";
                value = 1;
              }
            ];
          };
          unit = "none";
        };
      };
      targets = [
        {
          expr = "node_systemd_unit_state{name=\"${service}\",state=\"active\"}";
        }
      ];
    }
  ) services;
}
