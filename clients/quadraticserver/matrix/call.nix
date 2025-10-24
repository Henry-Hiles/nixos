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
    in
    {
      livekit = {
        enable = true;
        keyFile = config.age.secrets."livekitKeys.age".path;
      };

      lk-jwt-service = {
        enable = true;
        livekitUrl = "wss://${domain}/livekit/sfu";
        keyFile = config.services.livekit.keyFile;
      };

      caddy.virtualHosts."${domain}".extraConfig = ''
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
             livekit.livekit_service_url = "https://${domain}/livekit";
           }
         }` 200

        	handle /livekit/sfu/get {
        	  uri strip_prefix /livekit
        	  reverse_proxy 127.0.0.1:8080
        	}

        	handle_path /livekit/sfu* {
        	  reverse_proxy 127.0.0.1:7880
        	}

        	try_files {path} {path}/ /index.html
        	file_server
        }
      '';
    };
}
