# MinIO package and module, vendored from nixpkgs 6510408d147d8c5e6d76043e899e9251756f6a75
# (nixos/modules/services/web-servers/minio.nix and pkgs/by-name/mi/minio/package.nix), since
# both were removed upstream because MinIO was abandoned. Only here until lasuite-docs is
# migrated to another S3 server.
#
# Changes from upstream:
# - The option is `services.minio-vendored`, since nixpkgs still reserves `services.minio` to
#   show a removal message. The unit, user and paths are unchanged, so existing data keeps working.
# - The package is defined here, as `pkgs.minio` now throws, and without `passthru.tests`, as
#   `nixosTests.minio` was removed too.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.minio-vendored;

  minio = pkgs.callPackage (
    {
      lib,
      buildGoModule,
      fetchFromGitHub,
    }:
    let
      # The web client verifies, that the server version is a valid datetime string:
      # https://github.com/minio/minio/blob/3a0e7347cad25c60b2e51ff3194588b34d9e424c/browser/app/js/web.js#L51-L53
      #
      # Example:
      #   versionToTimestamp "2021-04-22T15-44-28Z"
      #   => "2021-04-22T15:44:28Z"
      versionToTimestamp =
        version:
        let
          splitTS = builtins.elemAt (builtins.split "(.*)(T.*)" version) 1;
        in
        builtins.concatStringsSep "" [
          (builtins.elemAt splitTS 0)
          (builtins.replaceStrings [ "-" ] [ ":" ] (builtins.elemAt splitTS 1))
        ];

      # CopyrightYear will be printed to the CLI UI.
      # Example:
      #   versionToYear "2021-04-22T15-44-28Z"
      #   => "2021"
      versionToYear = version: builtins.elemAt (lib.splitString "-" version) 0;
    in
    buildGoModule (finalAttrs: {
      pname = "minio";
      version = "2025-10-15T17-29-55Z";

      src = fetchFromGitHub {
        owner = "minio";
        repo = "minio";
        rev = "RELEASE.${finalAttrs.version}";
        hash = "sha256-HbjmCJYkWyRRHKriLP6QohaXYLk3QEVfi32Krq3ujjo=";
      };

      vendorHash = "sha256-BFnTJE9QFWmPsx90hDTG8MusdnwaBPYJxM5bCFk3hew=";

      doCheck = false;

      subPackages = [ "." ];

      env.CGO_ENABLED = 0;

      tags = [ "kqueue" ];

      ldflags =
        let
          t = "github.com/minio/minio/cmd";
        in
        [
          "-s"
          "-w"
          "-X ${t}.Version=${versionToTimestamp finalAttrs.version}"
          "-X ${t}.CopyrightYear=${versionToYear finalAttrs.version}"
          "-X ${t}.ReleaseTag=RELEASE.${finalAttrs.version}"
          "-X ${t}.CommitID=${finalAttrs.src.rev}"
        ];

      meta = {
        homepage = "https://www.minio.io/";
        description = "S3-compatible object storage server";
        changelog = "https://github.com/minio/minio/releases/tag/RELEASE.${finalAttrs.version}";
        maintainers = with lib.maintainers; [
          bachp
          ryan4yin
        ];
        license = lib.licenses.agpl3Plus;
        mainProgram = "minio";
        knownVulnerabilities = [
          "CVE-2026-40344: MinIO has an Unauthenticated Object Write via Missing Signature Verification in Unsigned-Trailer Uploads"
          "CVE-2026-41145: Unauthenticated Object Write via Query-String Credential Signature Bypass in Unsigned-Trailer Uploads"
          "CVE-2026-33322: JWT Algorithm Confusion in OIDC Authentication"
          "CVE-2026-33419: LDAP login brute-force via user enumeration and missing rate limit"
          "CVE-2026-34204: SSE Metadata Injection via Replication Headers"
          "CVE-2026-39414: DoS via Unbounded Memory Allocation in S3 Select CSV Parsing"
          "minio has been abandoned by upstream and security issues won't be fixed. Users should migrate to alternatives such as Garage, SeaweedFS, or Ceph. S3-compatible clients such as rclone can be used to move data."
        ];
      };
    })
  ) { };

  legacyCredentials =
    cfg:
    pkgs.writeText "minio-legacy-credentials" ''
      MINIO_ROOT_USER=${cfg.accessKey}
      MINIO_ROOT_PASSWORD=${cfg.secretKey}
    '';
in
{
  options.services.minio-vendored = {
    enable = mkEnableOption "Minio Object Storage";

    listenAddress = mkOption {
      default = ":9000";
      type = types.str;
      description = "IP address and port of the server.";
    };

    consoleAddress = mkOption {
      default = ":9001";
      type = types.str;
      description = "IP address and port of the web UI (console).";
    };

    dataDir = mkOption {
      default = [ "/var/lib/minio/data" ];
      type = types.listOf (types.either types.path types.str);
      description = "The list of data directories or nodes for storing the objects. Use one path for regular operation and the minimum of 4 endpoints for Erasure Code mode.";
    };

    configDir = mkOption {
      default = "/var/lib/minio/config";
      type = types.path;
      description = "The config directory, for the access keys and other settings.";
    };

    certificatesDir = mkOption {
      default = "/var/lib/minio/certs";
      type = types.path;
      description = "The directory where TLS certificates are stored.";
    };

    accessKey = mkOption {
      default = "";
      type = types.str;
      description = ''
        Access key of 5 to 20 characters in length that clients use to access the server.
        This overrides the access key that is generated by minio on first startup and stored inside the
        `configDir` directory.
      '';
    };

    secretKey = mkOption {
      default = "";
      type = types.str;
      description = ''
        Specify the Secret key of 8 to 40 characters in length that clients use to access the server.
        This overrides the secret key that is generated by minio on first startup and stored inside the
        `configDir` directory.
      '';
    };

    rootCredentialsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing the MINIO_ROOT_USER, default is "minioadmin", and
        MINIO_ROOT_PASSWORD (length >= 8), default is "minioadmin"; in the format of
        an EnvironmentFile=, as described by {manpage}`systemd.exec(5)`.
      '';
      example = "/etc/nixos/minio-root-credentials";
    };

    region = mkOption {
      default = "us-east-1";
      type = types.str;
      description = ''
        The physical location of the server. By default it is set to us-east-1, which is same as AWS S3's and Minio's default region.
      '';
    };

    browser = mkOption {
      default = true;
      type = types.bool;
      description = "Enable or disable access to web UI.";
    };

    package = mkOption {
      type = types.package;
      default = minio;
      defaultText = literalMD "MinIO 2025-10-15T17-29-55Z, vendored above";
      description = "The MinIO package to use.";
    };
  };

  config = mkIf cfg.enable {
    warnings =
      optional ((cfg.accessKey != "") || (cfg.secretKey != ""))
        "services.minio-vendored.`accessKey` and services.minio-vendored.`secretKey` are deprecated, please use services.minio-vendored.`rootCredentialsFile` instead.";

    systemd = lib.mkMerge [
      {
        tmpfiles.rules = [
          "d '${cfg.configDir}' - minio minio - -"
        ]
        ++ (map (x: "d '" + x + "' - minio minio - - ") (builtins.filter lib.types.path.check cfg.dataDir));

        services.minio = {
          description = "Minio Object Storage";
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/minio server --json --address ${cfg.listenAddress} --console-address ${cfg.consoleAddress} --config-dir=${cfg.configDir} --certs-dir=${cfg.certificatesDir} ${toString cfg.dataDir}";
            Type = "simple";
            User = "minio";
            Group = "minio";
            LimitNOFILE = 65536;
            EnvironmentFile =
              if (cfg.rootCredentialsFile != null) then
                cfg.rootCredentialsFile
              else if ((cfg.accessKey != "") || (cfg.secretKey != "")) then
                (legacyCredentials cfg)
              else
                null;

            # hardening
            DevicePolicy = "closed";
            CapabilityBoundingSet = "";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
              "AF_UNIX"
            ];
            DeviceAllow = "";
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateMounts = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            MemoryDenyWriteExecute = true;
            LockPersonality = true;
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
            ProtectProc = "invisible";
            ProtectHostname = true;
            UMask = "0077";
            # minio opens /proc/mounts on startup
            ProcSubset = "all";
          };
          environment = {
            MINIO_REGION = "${cfg.region}";
            MINIO_BROWSER = "${if cfg.browser then "on" else "off"}";
          };
        };
      }

      (lib.mkIf (cfg.rootCredentialsFile != null) {
        # The service will fail if the credentials file is missing
        services.minio.unitConfig.ConditionPathExists = cfg.rootCredentialsFile;

        # The service will not restart if the credentials file has
        # been changed. This can cause stale root credentials.
        paths.minio-root-credentials = {
          wantedBy = [ "multi-user.target" ];

          pathConfig = {
            PathChanged = [ cfg.rootCredentialsFile ];
            Unit = "minio-restart.service";
          };
        };

        services.minio-restart = {
          description = "Restart MinIO";

          script = ''
            systemctl restart minio.service
          '';

          serviceConfig = {
            Type = "oneshot";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      })
    ];

    users.users.minio = {
      group = "minio";
      uid = config.ids.uids.minio;
    };

    users.groups.minio.gid = config.ids.uids.minio;
  };
}
