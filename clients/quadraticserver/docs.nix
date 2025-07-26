{
  config,
  pkgs,
  ...
}: let
  authDomain = "auth.federated.nexus";
  domain = "docs.federated.nexus";
  socket = "/run/lasuite-docs/socket";
  s3Domain = "http://127.0.0.1${config.services.minio.listenAddress}";
  s3Url = "${s3Domain}/lasuite-docs";
in {
  services = {
    lasuite-docs = {
      enable = true;
      enableNginx = false;
      redis.createLocally = true;
      postgresql.createLocally = true;
      bind = "unix:${socket}";
      inherit s3Url domain;

      settings = {
        OIDC_OP_AUTHORIZATION_ENDPOINT = "https://federated.nexus/login";
        OIDC_OP_TOKEN_ENDPOINT = "http://${authDomain}/token";
        OIDC_OP_USER_ENDPOINT = "http://${authDomain}/userinfo";
        OIDC_RP_SIGN_ALGO = "HS256";

        LOGIN_REDIRECT_URL = "http://${domain}";

        OIDC_USERINFO_FULLNAME_FIELDS = ''["name"]'';
        OIDC_USERINFO_SHORTNAME_FIELD = "name";

        AWS_S3_ENDPOINT_URL = s3Domain;
        AWS_S3_ACCESS_KEY_ID = "minioadmin";
        AWS_STORAGE_BUCKET_NAME = "lasuite-docs";
        MEDIA_BASE_URL = "http://${domain}";

        DJANGO_ALLOWED_HOSTS = domain;
      };

      environmentFile = config.age.secrets."lasuiteSecrets.age".path;
    };

    minio = {
      enable = true;
      rootCredentialsFile = config.age.secrets."minioCredentials.age".path;
    };

    caddy.virtualHosts."${domain}".extraConfig = let
      cfg = config.services.lasuite-docs;
    in ''
      handle_errors {
        rewrite * /{http.error.status_code}
        file_server
      }

      redir /api/v1.0/logout/None /

      root * ${pkgs.lasuite-docs-frontend}
      file_server

      @uuidDocs path_regexp uuidDocs ^/docs/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$
      rewrite @uuidDocs /docs/[id]/index.html

      reverse_proxy /api/* unix/${socket}
      reverse_proxy /admin/* unix/${socket}

      reverse_proxy /collaboration/ws/* http://localhost:${toString cfg.collaborationServer.port}
      reverse_proxy /collaboration/api/* http://localhost:${toString cfg.collaborationServer.port}

      rewrite /media-auth /api/v1.0/documents/media-auth/
      reverse_proxy /api/v1.0/documents/media-auth/ unix/${socket}

      rewrite /media/* /lasuite-docs
      reverse_proxy /lasuite-docs ${s3Domain}
    '';
  };

  systemd.services.minio-init = {
    description = "Create MinIO bucket";
    after = ["minio.service"];
    requires = ["minio.service"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.getent pkgs.minio-client];

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
