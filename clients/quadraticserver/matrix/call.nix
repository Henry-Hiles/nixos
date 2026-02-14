{
  lib,
  pkgs,
  config,
  ...
}:
{
  systemd.services = {
    livekit.serviceConfig.Restart = lib.mkForce "always";
    lk-jwt-service.serviceConfig.Restart = lib.mkForce "always";
  };

  services =
    let
      domain = "call.federated.nexus";
      livekitDomain = "livekit.call.federated.nexus";
      lkJwtServiceDomain = "lk-jwt.call.federated.nexus";
    in
    {
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
        "${domain}".extraConfig = ''
          root * ${pkgs.element-call}
          route {
          	respond /config.json `${
             builtins.toJSON {
               default_server_config = {
                 "m.homeserver" = {
                   "base_url" = config.services.matrix-continuwuity.settings.global.well_known.client;
                   "server_name" = config.quad.matrix.domain;
                 };
               };
             }
           }` 200

            try_files {path} {path}/ /index.html
          	file_server
          }
        '';
      };
    };
}
