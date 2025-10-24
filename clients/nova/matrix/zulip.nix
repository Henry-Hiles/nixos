{
  lib,
  pkgs,
  config,
  ...
}:
{
  systemd.services.matrix-zulip-bridge = {
    description = "matrix-zulip-bridge server";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig =
      let
        secretName = "matrix-zulip-bridge-secrets";
      in
      {
        LoadCredential = [
          "${secretName}:${config.age.secrets."zulipRegistration.age".path}"
        ];
        ExecStart = "${lib.getExe pkgs.matrix-zulip-bridge} --config /run/credentials/matrix-zulip-bridge.service/${secretName} --owner @quadradical:${config.quad.matrix.domain} ${config.services.matrix-continuwuity.settings.global.well_known.client}";
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
        Restart = "always";
        RestartSec = 5;
      };
  };
}
