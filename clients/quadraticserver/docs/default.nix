{
  inputs,
  config,
  pkgs,
  ...
}:
let
  s3Domain = "http://127.0.0.1${config.services.minio.listenAddress}";
  cfg = config.services.lasuite-docs;
in
{
  imports = [ inputs.lasuite-docs-proxy.nixosModules.default ];

  systemd.services = {
    lasuite-docs-collaboration-server.serviceConfig = {
      EnvironmentFile = cfg.environmentFile;
      Restart = "always";
    };

    lasuite-docs-celery.serviceConfig.Restart = "always";
    lasuite-docs.serviceConfig.Restart = "always";
  };

  services =
    let
      proxySocket = "/var/run/lasuite-docs-proxy/socket";
      authDomain = "auth.federated.nexus";
      domain = "docs.federated.nexus";
      s3Url = "${s3Domain}/lasuite-docs";
      socket = "/run/lasuite-docs/socket";
    in
    {
      lasuite-docs-proxy = {
        enable = true;
        args = [
          "--socket"
          proxySocket
          "--authUri"
          "https://docs.federated.nexus/api/v1.0/documents/media-auth/"
          "--minioUri"
          s3Url
        ];
        group = "caddy";
      };
      lasuite-docs = {
        enable = true;
        enableNginx = false;
        redis.createLocally = true;
        postgresql.createLocally = true;
        backendPackage = pkgs.lasuite-docs.overrideAttrs {
          patches = [ ./enable-languages.patch ];
        };
        frontendPackage = pkgs.lasuite-docs-frontend.overrideAttrs {
          NEXT_PUBLIC_PUBLISH_AS_MIT = "false";
        };
        bind = "unix:${socket}";
        inherit s3Url domain;

        settings = {
          OIDC_OP_AUTHORIZATION_ENDPOINT = "https://federated.nexus/login";
          OIDC_OP_TOKEN_ENDPOINT = "https://${authDomain}/token";
          OIDC_OP_USER_ENDPOINT = "https://${authDomain}/userinfo";
          OIDC_RP_SIGN_ALGO = "HS256";

          COLLABORATION_API_URL = "https://${domain}/collaboration/api/";
          LOGIN_REDIRECT_URL = "https://${domain}";

          AWS_S3_ENDPOINT_URL = s3Domain;
          AWS_S3_ACCESS_KEY_ID = "minioadmin";
          AWS_STORAGE_BUCKET_NAME = "lasuite-docs";
          MEDIA_BASE_URL = "https://${domain}";

          DJANGO_ALLOWED_HOSTS = domain;
        };

        environmentFile = config.age.secrets."lasuiteSecrets.age".path;
      };

      minio = {
        enable = true;
        rootCredentialsFile = config.age.secrets."minioCredentials.age".path;
      };

      caddy.virtualHosts."${domain}".extraConfig =
        let
          collabUrl = "http://localhost:${toString cfg.collaborationServer.port}";
        in
        ''
          handle_errors {
            rewrite * /{http.error.status_code}
            file_server
          }

          redir /api/v1.0/logout/None /

          root * ${cfg.frontendPackage}
          file_server

          @uuidDocs path_regexp uuidDocs ^/docs/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$
          rewrite @uuidDocs /docs/[id]/index.html

          reverse_proxy /api/* unix/${socket}
          reverse_proxy /admin/* unix/${socket}

          reverse_proxy /collaboration/ws/* ${collabUrl}
          reverse_proxy /collaboration/api/* ${collabUrl}

          reverse_proxy /api/v1.0/documents/media-auth/ unix/${socket}

          reverse_proxy /media/* unix/${proxySocket}
        '';
    };

  systemd.services.minio-init = {
    description = "Create MinIO bucket";
    after = [ "minio.service" ];
    requires = [ "minio.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      getent
      minio-client
    ];

    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.age.secrets."minioCredentials.age".path;
      ExecStart = pkgs.writeShellScript "init-minio" ''
        mc alias set minio ${s3Domain} "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" --api s3v4
        mc mb --ignore-existing minio/lasuite-docs
        mc anonymous get minio/lasuite-docs
      '';
    };
  };
}
