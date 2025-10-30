{ pkgs, lib, ... }:
services:

#  {
#       "collapsed": false,
#       "gridPos": {
#         "h": 1,
#         "w": 24,
#         "x": 0,
#         "y": 0
#       },
#       "id": 261,
#       "panels": [],
#       "title": "Quick CPU / Mem / Disk",
#       "type": "row"
#     },
pkgs.writers.writeJSON "status.json" {
  title = "Service Status";
  panels = [
    {
      collapsed = false;
      title = "Federated Nexus Service Statuses";
      type = "row";
      gridPos = {
        h = 1;
        w = 24;
        x = 0;
        y = 0;
      };
    }
  ]
  ++ (lib.imap0 (
    index:
    { name, service }:
    {
      title = name;
      type = "stat";
      gridPos = rec {
        h = 3;
        w = 4;
        x = index * w;
        y = (index * h) + 8;
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
  ) services);
}
