{ pkgs, lib, ... }:
pkgs.writers.writeJSON "status.json" {
  title = "Service Status";
  refresh = "10s";
  panels =
    let
      status = null;
      offset = if status == null then 8 else 0;
    in
    (lib.optionals (status != null) [
      {
        gridPos.w = 100;
        title = "Status Update";
        type = "text";
        options.content = status;
      }
    ])
    ++ [
      {
        collapsed = false;
        title = "Federated Nexus Service Statuses";
        type = "row";
        gridPos = {
          h = 8;
          w = 24;
          y = offset;
        };
      }
    ]
    ++ (lib.imap0
      (
        index:
        { name, service }:
        {
          title = name;
          type = "stat";
          gridPos = rec {
            h = 3;
            w = 4;
            x = index * w;
            y = (index * h) + offset + 8;
          };
          datasource = {
            type = "prometheus";
            uid = "prometheus";
          };
          options.graphMode = "none";
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
            };
          };
          targets = [
            {
              expr = "node_systemd_unit_state{name=\"${service}\",state=\"active\"}";
            }
          ];
        }
      )
      [
        {
          name = "Matrix";
          service = "continuwuity.service";
        }
        {
          name = "LaSuite Docs";
          service = "lasuite-docs.service";
        }
        {
          name = "Forgejo (Git)";
          service = "forgejo.service";
        }
        {
          name = "SearXNG (Search)";
          service = "searx.service";
        }
        {
          name = "Redlib";
          service = "redlib.service";
        }
        {
          name = "GMessages Bridge";
          service = "matrix-as-gmessages.service";
        }
      ]
    );
}
