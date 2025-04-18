{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.livekit;
  format = pkgs.formats.json {};
in {
  meta.maintainers = with lib.maintainers; [quadradical];
  options.services.livekit = {
    enable = lib.mkEnableOption "Enable the livekit server";
    package = lib.mkPackageOption pkgs "livekit" {};

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        LiveKit key file, with syntax `LIVEKIT_KEYS=\"key: secret\"`
        The key and secret are used by other clients or services to connect to your Livekit instance.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Opens ports 50000 to 51000 on the firewall.";
    };

    useExternalIP = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When set to true, attempts to discover the host's public IP via STUN.
        This is useful for cloud environments such as AWS & Google where hosts have an internal IP that maps to an external one
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 7880;
            description = "Main TCP port for RoomService and RTC endpoint.";
          };

          rtc = {
            port_range_start = lib.mkOption {
              type = lib.types.int;
              default = 50000;
              description = "Start of UDP port range for WebRTC";
            };

            port_range_end = lib.mkOption {
              type = lib.types.int;
              default = 51000;
              description = "End of UDP port range for WebRTC";
            };
          };
        };
      };
      default = {};
      description = ''
        LiveKit configuration file expressed in nix.

        For an example configuration, see <https://docs.livekit.io/home/self-hosting/deployment/#configuration>.
        For all possible values, see <https://github.com/livekit/livekit/blob/master/config-sample.yaml>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.port
      ];
      allowedUDPPortRanges = [
        {
          from = cfg.rtc.port_range_start;
          to = cfg.rtc.port_range_end;
        }
      ];
    };

    systemd.services.livekit = {
      description = "LiveKit SFU server";
      documentation = ["https://docs.livekit.io"];
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];

      serviceConfig = {
        EnvironmentFile = cfg.environmentFile;
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        ProtectHome = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ExecStart = "${lib.getExe cfg.package} --config ${format.generate "livekit.json" cfg.settings}";
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "077";
      };
    };
  };
}
