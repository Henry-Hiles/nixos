{
  lib,
  config,
  ...
}:

let
  livekitDomain = "livekit.call.federated.nexus";
  lkJwtServiceDomain = "lk-jwt.call.federated.nexus";
in
{
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
      livekitUrl = "wss://${livekitDomain}";
      keyFile = config.services.livekit.keyFile;
    };

    caddy.virtualHosts = {
      "${livekitDomain}".extraConfig = "reverse_proxy 127.0.0.1:7880";
      "${lkJwtServiceDomain}".extraConfig = "reverse_proxy 127.0.0.1:8080";
    };
  };
}
