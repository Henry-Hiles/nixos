{ lib, ... }:
{
  config = {
    systemd = {
      services = {
        caddy.serviceConfig.Restart = lib.mkForce "always";
        clear-caddy-logs = {
          description = "Delete /var/log/caddy and restart Caddy (monthly)";
          serviceConfig.Type = "oneshot";

          script = "rm -rf /var/log/caddy";
          postStop = "systemctl restart caddy";
        };
      };

      timers.clear-caddy-logs = {
        description = "Monthly Caddy log reset";
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnCalendar = "*-*-01 00:00:00";
          Persistent = true;
          Unit = "clear-caddy-logs.service";
        };
      };
    };

    networking.firewall = {
      allowedUDPPorts = [
        443
      ];
      allowedTCPPorts = [
        80
        443
      ];
    };

    services.caddy = {
      enable = true;
      email = "henry@henryhiles.com";
      globalConfig = ''
        metrics {
          per_host
        }
      '';
    };
  };
}
