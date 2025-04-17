{
  pkgs,
  config,
  ...
}: {
  services = {
    lk-jwt-service = {
      enable = true;
      livekit = {
        url = "wss://call.henryhiles.com/livekit/sfu";
        keyFile = config.age.secrets."livekitKeys.age".path;
      };
    };

    livekit = {
      enable = true;
      keyFile = config.age.secrets."livekitKeys.age".path;
    };

    caddy.virtualHosts."call.henryhiles.com".extraConfig = ''
      root * ${pkgs.element-call}
      route {
      	respond /config.json `${builtins.toJSON {
        default_server_config = {
          "m.homeserver" = {
            "base_url" = "https://matrix.henryhiles.com";
            "server_name" = "henryhiles.com";
          };
        };
        livekit.livekit_service_url = "https://call.henryhiles.com/livekit";
      }}` 200

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
