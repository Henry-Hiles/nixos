{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.lk-jwt-service;
in {
  meta.maintainers = [lib.maintainers.quadradical];
  options.services.lk-jwt-service = {
    enable = lib.mkEnableOption "Enable lk-jwt-service";
    package = lib.mkPackageOption pkgs "lk-jwt-service" {};

    livekit = {
      url = lib.mkOption {
        type = lib.types.str;
        description = ''
          The URL that livekit runs on, prefixed with `ws://` or `wss://` (recommended).
          For example, `wss://example.com/livekit/sfu`
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to a file of environment variables, where you must declare some of: `LIVEKIT_KEY`, `LIVEKIT_SECRET`, `LIVEKIT_KEY_FROM_FILE`, `LIVEKIT_SECRET_FROM_FILE`, and/or `LIVEKIT_KEY_FILE`.
          For more information, see <https://github.com/element-hq/lk-jwt-service#configuration>.
        '';
      };
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port that lk-jwt-service should listen on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.lk-jwt-service = {
      description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
      documentation = ["https://github.com/element-hq/lk-jwt-service"];
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];
      environment.LIVEKIT_URL = cfg.livekit.url;

      serviceConfig = {
        EnvironmentFile = cfg.livekit.environmentFile;
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
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "077";
      };
    };
  };
}
