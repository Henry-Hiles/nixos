{
  lib,
  pkgs,
  config,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      sogo = prev.sogo.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [prev.postgresql.lib];
        NIX_LDFLAGS = (old.NIX_LDFLAGS or "") + " -lpq";
      });
    })
  ];

  services = let
    domain = "mail.federated.nexus";
  in {
    memcached = {
      enable = true;
      user = "sogo";
      enableUnixSocket = true;
      extraOptions = [
        "-a"
        "0600"
      ];
    };

    postgresql = {
      enable = true;
      enableTCPIP = true;

      ensureDatabases = ["sogo"];
      ensureUsers = [
        {
          name = "sogo";
          ensureDBOwnership = true;
        }
      ];
    };

    sogo = {
      enable = true;
      timezone = config.time.timeZone;
      extraConfig = let
        db = "postgresql://sogo@127.0.0.1/sogo";
      in ''
        SOGoMailDomain = "federated.nexus";
        SOGoMemcachedHost = "/run/memcached/memcached.sock";

        SOGoAuthenticationType = "openid";
        SOGoOpenIdConfigUrl = "https://auth.federated.nexus/.well-known/openid-configuration";
        SOGoOpenIdClient = "Federated Nexus Auth";
        SOGoOpenIdClientSecret = "";
        SOGoOpenIdScope = "";
        SOGoOpenIdTokenCheckInterval = 600;

        SOGoSMTPServer = "smtp://localhost";
        SOGoSMTPAuthenticationType = "xoauth2";

        SOGoIMAPServer = "imap://localhost";
        NGImap4AuthMechanism = "xoauth2";

        SOGoPageTitle = "Federated Nexus Mail";
        SOGoZipPath = "${lib.getExe pkgs.zip}";

        OCSSessionsFolderURL = "${db}/sogo_sessions_folder";
        OCSFolderInfoURL = "${db}/sogo_folder_info";
        OCSOpenIdURL = "${db}/sogo_openid";
        MySQL4Encoding = "utf8mb4";
      '';
    };

    caddy.virtualHosts."${domain}".extraConfig = ''
      # Redirect root to /SOGo
      @root path /
      redir @root https://{host}/SOGo

      # Redirect /principals/ to /SOGo/dav
      @principals path /principals/*
      redir @principals https://{host}/SOGo/dav

      # Static assets for SOGo
      handle_path /SOGo.woa/WebServerResources/* {
        root * ${pkgs.sogo}/lib/GNUstep/SOGo/WebServerResources/
        file_server
      }

      handle_path /SOGo/WebServerResources/* {
        root * ${pkgs.sogo}/lib/GNUstep/SOGo/
        file_server
      }

      # Regex match: ControlPanel products
      @resources1 path_regexp resources1 ^/SOGo/so/ControlPanel/Products/([^/]*)/Resources/(.*)$
      handle @resources1 {
        root * ${pkgs.sogo}/lib/GNUstep/SOGo/{http.regexp.resources1.1}.SOGo/Resources/
        rewrite * /{http.regexp.resources1.2}
        file_server
      }

      # Regex match: ControlPanel UI resources
      @resources2 path_regexp resources2 ^/SOGo/so/ControlPanel/Products/([^/]*)UI/Resources/(.*\.(jpg|png|gif|css|js))$
      handle @resources2 {
        root * ${pkgs.sogo}/lib/GNUstep/SOGo/{http.regexp.resources2.1}UI.SOGo/Resources/
        rewrite * /{http.regexp.resources2.2}
        file_server
      }

      # SOGo app proxy
      handle_path /SOGo* {
        reverse_proxy 127.0.0.1:20000 {
          header_up x-webobjects-server-protocol HTTP/1.0
          header_up x-webobjects-remote-host 127.0.0.1
          header_up x-webobjects-server-port {server_port}
          header_up x-webobjects-server-name {host}
          header_up x-webobjects-server-url {scheme}://{host}
        }
      }
    '';
  };
}
