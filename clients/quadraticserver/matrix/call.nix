{
  lib,
  config,
  inputs,
  ...
}:

let
  livekitDomain = "livekit.call.federated.nexus";
  lkJwtServiceDomain = "lk-jwt.call.federated.nexus";
in
{
  # TODO: remove once https://github.com/NixOS/nixpkgs/pull/548367 is merged
  disabledModules = [ "services/matrix/lk-jwt-service.nix" ];
  imports = [ inputs.lk-jwt-service-module.outPath ];

  systemd.services = {
    livekit.serviceConfig.Restart = lib.mkForce "always";
    lk-jwt-service.serviceConfig.Restart = lib.mkForce "always";
  };

  quad.matrix.settings.matrix_rtc.foci = [
    {
      type = "livekit";
      livekit_service_url = "https://${lkJwtServiceDomain}";
    }
  ];

  services = {
    livekit = {
      enable = true;
      openFirewall = true;
      keyFile = config.age.secrets."livekitKeys.age".path;
      settings.room.auto_create = false;
    };

    lk-jwt-service = {
      enable = true;
      environment = {
        LIVEKIT_URL = "wss://${livekitDomain}";
        LIVEKIT_KEY_FILE = config.services.livekit.keyFile;
        LIVEKIT_JWT_BIND = "127.0.0.4:8080";
        LIVEKIT_FULL_ACCESS_HOMESERVERS = [ "federated.nexus" ];
      };
    };

    caddy.virtualHosts = {
      "${livekitDomain}".extraConfig = "reverse_proxy 127.0.0.1:7880";
      "${lkJwtServiceDomain}".extraConfig =
        "reverse_proxy ${config.services.lk-jwt-service.environment.LIVEKIT_JWT_BIND}";
    };
  };
}
