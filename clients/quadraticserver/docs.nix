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
        OIDC_CREATE_USER = true;
        OIDC_OP_AUTHORIZATION_ENDPOINT = "https://federated.nexus/login";
        OIDC_OP_TOKEN_ENDPOINT = "http://${authDomain}/token";
        OIDC_OP_USER_ENDPOINT = "http://${authDomain}/userinfo";
        OIDC_RP_SIGN_ALGO = "HS256";
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
      browser = false;
      rootCredentialsFile = config.age.secrets."minioCredentials.age".path;
    };

    caddy.virtualHosts."${domain}".extraConfig = let
      cfg = config.services.lasuite-docs;
    in ''
      handle_errors {
        @401 expression {http.error.status_code} == 401
        rewrite @401 /401

        @403 expression {http.error.status_code} == 403
        rewrite @403 /403

        @404 expression {http.error.status_code} == 404
        rewrite @404 /404
      }

      root * ${pkgs.lasuite-docs-frontend}
      file_server

      @uuidDocs path_regexp uuidDocs ^/docs/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$
      rewrite @uuidDocs /docs/[id]/index.html

      reverse_proxy /api/* unix/${socket}

      reverse_proxy /admin/* unix/${socket}

      reverse_proxy /collaboration/ws/* http://localhost:${toString cfg.collaborationServer.port} {
        transport http {
          versions h2c 1.1
        }
      }

      reverse_proxy /collaboration/api/* http://localhost:${toString cfg.collaborationServer.port}

      rewrite /media-auth /api/v1.0/documents/media-auth/
      reverse_proxy /api/v1.0/documents/media-auth/ unix/${socket} {
        header_up X-Original-URL {uri}
        header_up -Content-Length
        header_up X-Original-Method {method}
        header_up -X-Forwarded-For
      }

      rewrite /media/* /lasuite-docs
      reverse_proxy /lasuite-docs ${s3Domain} {
        header_up Authorization {http.reverse_proxy.header.X-Upstream-Authorization}
        header_up X-Amz-Date {http.reverse_proxy.header.X-Upstream-X-Amz-Date}
        header_up X-Amz-Content-SHA256 {http.reverse_proxy.header.X-Upstream-X-Amz-Content-Sha256}
      }
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
      after = ["minio.service"];
      requires = ["minio.service"];

      EnvironmentFile = config.age.secrets."minioCredentials.age".path;
      ExecStart = pkgs.writeShellScript "init-minio" ''
        mc alias set minio ${s3Domain} "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" --api s3v4
        mc --config-dir "$CONFIG_DIR" mb --ignore-existing minio/lasuite-docs
      '';
    };
  };
}
