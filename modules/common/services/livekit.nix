{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.livekit;
in {
  meta.maintainers = with lib.maintainers; [quadradical];
  options.services.livekit = {
    enable = lib.mkEnableOption "Enable the livekit server";
    package = lib.mkPackageOption pkgs "livekit" {};

    keyFile = lib.mkOption {
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

    port = lib.mkOption {
      type = lib.types.port;
      default = 7880;
      description = "Main TCP port for RoomService and RTC endpoint.";
    };

    rtc = {
      portRangeStart = lib.mkOption {
        type = lib.types.int;
        default = 50000;
        description = "Start of UDP port range for WebRTC";
      };

      portRangeEnd = lib.mkOption {
        type = lib.types.int;
        default = 51000;
        description = "End of UDP port range for WebRTC";
      };
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
        EnvironmentFile = cfg.keyFile;
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
        ExecStart = "${lib.getExe cfg.package} --config-body=${
          builtins.toJSON (
            builtins.toJSON {
              port = cfg.port;
              rtc = {
                port_range_start = cfg.rtc.portRangeStart;
                port_range_end = cfg.rtc.portRangeEnd;
                use_external_ip = cfg.useExternalIP;
              };
            }
          )
        }";
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "077";
      };
    };
  };
}
