{ pkgs, lib, ... }:
services:
pkgs.writers.writeJSON "status.json" {
  title = "Service Status";
  panels = map (
    { name, service }:
    {
      datasource = {
        type = "prometheus";
        uid = "prometheus";
      };
      fieldConfig = {
        defaults = {
          color = {
            mode = "thresholds";
          };
          mappings = [
            {
              options = {
                "0" = {
                  color = "red";
                  index = 1;
                  text = "Failed";
                };
                "1" = {
                  color = "green";
                  index = 0;
                  text = "Running";
                };
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
      title = name;
      type = "stat";
    }
  ) services;
}
