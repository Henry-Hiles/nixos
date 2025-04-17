{
  pkgs,
  config,
  ...
}: {
  services = {
    lk-jwt-service = {
      enable = true;
      livekit = {
        url = "ws://livekit.henryhiles.com/sfu";
        keyFile = config.age.secrets."livekitKeys.age".path;
      };
    };

    livekit = {
      enable = true;
      keyFile = config.age.secrets."livekitKeys.age".path;
    };

    caddy.virtualHosts = {
      "call.henryhiles.com".extraConfig = ''
          root * ${pkgs.element-call}
          respond /config.json `${builtins.toJSON {
          default_server_config = {
            "m.homeserver" = {
              "base_url" = "https://matrix.henryhiles.com";
              "server_name" = "henryhiles.com";
            };
          };
          livekit.livekit_service_url = "https://livekit.henryhiles.com";
        }}` 200

        try_files {path} {path}/ /index.html
        file_server
      '';
      "livekit.henryhiles.com".extraConfig = ''
        handle_path /sfu/get {
          reverse_proxy 127.0.0.1:8080
        }

        reverse_proxy 127.0.0.1:7880
      '';
    };
  };
}
