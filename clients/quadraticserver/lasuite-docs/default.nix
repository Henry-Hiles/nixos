{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.lasuite-docs;
  secrets = config.age.secrets;

  domain = "docs.federated.nexus";
  authDomain = "auth.federated.nexus";
  socket = "/run/lasuite-docs-gunicorn/socket";

  # Attachments are stored in VersityGW, on the storage box like the continuwuity media
  bucket = "lasuite-docs";
  s3Host = "127.0.0.1:7070";

  s3AccessKey = "lasuite-docs";
  versityDir = "/var/lib/versitygw";

  backendEnvironmentFiles = [
    secrets."lasuiteSecrets.age".path
    secrets."lasuiteYProviderKey.age".path
    secrets."versityCredentials.age".path
  ];
in
{
  systemd.mounts = [
    {
      requires = [ "storagebox-online.service" ];
      after = [ "storagebox-online.service" ];
      what = "u675579@u675579.your-storagebox.de:/lasuite-docs";
      where = versityDir;
      type = "fuse.sshfs";
      options = builtins.concatStringsSep "," [
        "_netdev"
        "reconnect"
        "ServerAliveInterval=15"
        "ServerAliveCountMax=3"
        "IdentityFile=/home/quadradical/.ssh/id_ed25519"
        "allow_other"
      ];
    }
  ];

  systemd.services = {
    lasuite-docs.serviceConfig = {
      EnvironmentFile = lib.mkForce backendEnvironmentFiles;
      Restart = "always";
      # FIXME: the socket gets its own runtime dir, as the shared lasuite-docs one is deleted
      # whenever any unit using it stops, e.g. celery or the lasuite-docs-setup-keys oneshot
      RuntimeDirectory = lib.mkForce [
        "lasuite-docs"
        "lasuite-docs-gunicorn"
      ];
    };

    lasuite-docs-celery.serviceConfig = {
      EnvironmentFile = lib.mkForce backendEnvironmentFiles;
      Restart = "always";
    };

    lasuite-docs-yhub-server.serviceConfig = {
      EnvironmentFile = secrets."lasuiteYProviderKey.age".path;
      Restart = "always";
    };

    lasuite-docs-yhub-server-setup-db = {
      # FIXME: missing upstream, it can otherwise race postgres at boot
      after = [ "postgresql.target" ];
      wants = [ "postgresql.target" ];
      # FIXME: the module sets POSTGRES="" for createLocally, but y-init-db skips creating the
      # tables when it is empty. No host means the PGHOST socket, and the user is the unit's own.
      environment.POSTGRES = lib.mkForce "postgres:///lasuite-docs-yhub-server";
    };

    versitygw = {
      description = "Versity S3 Gateway";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig.RequiresMountsFor = [ versityDir ];
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${versityDir}/data ${versityDir}/meta";
        # sshfs has no xattrs (metadata goes to a sidecar dir instead), O_TMPFILE nor reliable flock
        ExecStart = lib.escapeShellArgs [
          (lib.getExe pkgs.versitygw)
          "--port"
          s3Host
          "--access"
          s3AccessKey
          "--quiet"
          "posix"
          "--sidecar"
          "${versityDir}/meta"
          "--disableotmp"
          "--object-lock-mode"
          "local"
          "--disable-copy-file-range"
          "${versityDir}/data"
        ];
        # ROOT_SECRET_KEY
        EnvironmentFile = secrets."versityCredentials.age".path;
        Restart = "always";

        # No StateDirectory, systemd would try to chown the sshfs mount
        DynamicUser = true;
        ReadWritePaths = [ versityDir ];
        UMask = "0077";
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    versitygw-init = {
      description = "Create VersityGW bucket";
      after = [ "versitygw.service" ];
      requires = [ "versitygw.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.rclone ];
      environment = {
        RCLONE_CONFIG_VERSITY_TYPE = "s3";
        RCLONE_CONFIG_VERSITY_PROVIDER = "Other";
        RCLONE_CONFIG_VERSITY_ENDPOINT = "http://${s3Host}";
        RCLONE_CONFIG_VERSITY_ACCESS_KEY_ID = s3AccessKey;
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        EnvironmentFile = secrets."versityCredentials.age".path;
        Restart = "on-failure";
        RestartSec = 5;
      };
      script = ''
        RCLONE_CONFIG_VERSITY_SECRET_ACCESS_KEY="$ROOT_SECRET_KEY" rclone mkdir versity:${bucket}
      '';
    };
  };

  services = {
    lasuite-docs = {
      enable = true;
      enableNginx = false;
      redis.createLocally = true;
      postgresql.createLocally = true;
      frontendPackage = pkgs.lasuite-docs-frontend.overrideAttrs {
        NEXT_PUBLIC_PUBLISH_AS_MIT = "false";
      };
      bind = "unix:${socket}";
      s3Url = "http://${s3Host}/${bucket}";
      inherit domain;

      # Both default to true, for migrating from 5.x, which is done
      collaborationServer.enable = false;
      yhub.settings.SOFT_MIGRATION = false;

      settings = {
        OIDC_OP_AUTHORIZATION_ENDPOINT = "https://federated.nexus/login";
        OIDC_OP_TOKEN_ENDPOINT = "https://${authDomain}/token";
        OIDC_OP_USER_ENDPOINT = "https://${authDomain}/userinfo";
        OIDC_RP_SIGN_ALGO = "HS256";

        LOGIN_REDIRECT_URL = "https://${domain}";

        AWS_S3_ENDPOINT_URL = "http://${s3Host}";
        AWS_S3_ACCESS_KEY_ID = s3AccessKey;
        AWS_STORAGE_BUCKET_NAME = bucket;
        MEDIA_BASE_URL = "https://${domain}";

        DJANGO_ALLOWED_HOSTS = domain;
        DJANGO_LANGUAGES = "en-us,English;fr-fr,Français;el-el,Ελληνικά;nl-nl,Nederlands;es-es,Español;uk-ua,Українська;ru-ru,Русский";
      };

      environmentFile = secrets."lasuiteSecrets.age".path;
    };

    caddy.virtualHosts.${domain}.extraConfig = ''
      handle_errors {
        rewrite * /{http.error.status_code}
        file_server
      }

      redir /api/v1.0/logout/None /

      root * ${cfg.frontendPackage}
      file_server

      @uuidDocs path_regexp uuidDocs ^/docs/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$
      rewrite @uuidDocs /docs/[id]/index.html

      @userReconciliations path_regexp userReconciliations ^/user-reconciliations/(active|inactive)/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$
      rewrite @userReconciliations /user-reconciliations/{re.userReconciliations.1}/[id]/index.html

      reverse_proxy /static/admin/* unix/${socket}
      reverse_proxy /api/* unix/${socket}
      reverse_proxy /admin* unix/${socket}

      @yhub path /collaboration/ws/v1/* /collaboration/ydoc/* /collaboration/activity/* /collaboration/changeset/* /collaboration/rollback/* /collaboration/jwks/*
      reverse_proxy @yhub localhost:${toString cfg.yhub.settings.PORT}

      route /media/* {
        forward_auth unix/${socket} {
          uri /api/v1.0/documents/media-auth/
          header_up X-Original-URL {http.request.orig_uri}
          copy_headers Authorization X-Amz-Date X-Amz-Content-SHA256
        }

        uri strip_prefix /media
        rewrite * /${bucket}{uri}
        header Content-Security-Policy "default-src 'none'"
        reverse_proxy ${s3Host} {
          header_up Host {upstream_hostport}
          header_up -Cookie
        }
      }
    '';
  };
}
