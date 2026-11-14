{
  config,
  pkgs,
  ...
}:
let
  domain = "account.federated.nexus";
  ip = "127.0.0.6";
  address = "${ip}:8443";
  email = "inf" + "o@f" + "edera" + "ted.n" + "exus";
  package = config.services.kanidm.package;

  # Kanidm refuses to run without TLS, even behind a reverse proxy. Only Caddy
  # connects to it directly, and pins this self-signed certificate; everything
  # else goes through Caddy's public URL.
  tlsDir = "/var/lib/kanidm-tls";
  tlsCert = "${tlsDir}/cert.pem";
  tlsKey = "${tlsDir}/key.pem";
  tlsConfig = pkgs.writeText "kanidm-tls.cnf" ''
    [req]
    distinguished_name = dn
    x509_extensions = ext
    prompt = no

    [dn]
    CN = localhost

    [ext]
    basicConstraints = critical,CA:FALSE
    keyUsage = critical,digitalSignature
    extendedKeyUsage = serverAuth
    subjectAltName = DNS:localhost,IP:${ip}
  '';

  # Written by kanidm-bootstrap, read by kanidm-mail-sender
  bootstrapDir = "/var/lib/kanidm-bootstrap";
  mailSenderToken = "${bootstrapDir}/mail-sender-token";

  mailSenderConfig = (pkgs.formats.toml { }).generate "kanidm-mail-sender.toml" {
    instance_display_name = "Federated Nexus";
    instance_url = "https://${domain}";
    mail_from_address = email;
    mail_reply_to_address = email;
    mail_relay = "smtp://email-smtp.us-east-1.amazonaws.com:587";
    mail_username = "AKIAREHCBHZLJ3FNCCSM";
  };

  hardening = {
    CapabilityBoundingSet = [ ];
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
    ];
  };
in
{
  services = {
    kanidm = {
      package = pkgs.kanidmWithSecretProvisioning_1_12.overrideAttrs (old: {
        # Adds the "Migrate your legacy Federated Nexus account" link to the login page
        patches = (old.patches or [ ]) ++ [ ./migrate-link.patch ];
      });

      server = {
        enable = true;
        settings = {
          inherit domain;
          origin = "https://${domain}";
          bindaddress = address;
          tls_chain = tlsCert;
          tls_key = tlsKey;
          http_client_address_info."x-forward-for" = [
            "127.0.0.0/8"
            "::1/128"
          ];
        };

        # Applied by Kanidm on startup, and again whenever their content changes
        entryManagement.migrations = {
          "00-accounts" = {
            id = "9ffd67bc-b388-4d7e-929c-65d329ab3b6e";
            assertions = [
              {
                state = "present";
                id = "a16d8cbc-7620-4170-8f4e-344c96a3b289";
                class = [
                  "account"
                  "service_account"
                ];
                name = "mail-sender";
                displayname = "Mail sender";
                entry_managed_by = "idm_admins";
              }
            ];
          };

          # Existing built-in entries: class is omitted, as asserting it would
          # replace the entry's classes
          "10-builtin" = {
            id = "089c7d43-8f5c-44b2-8af0-49d9ae63aea8";
            assertions = [
              {
                # Domain info
                state = "present";
                id = "00000000-0000-0000-0000-ffffff000025";
                domain_display_name = "Federated Nexus";
              }
            ];
          };
        };
      };

      client = {
        enable = true;
        settings.uri = "https://${domain}";
      };
    };

    caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy https://${address} {
        transport http {
          tls_server_name localhost
          tls_trust_pool file ${tlsCert}
        }
      }
    '';
  };

  systemd.services = {
    kanidm-tls = {
      description = "Generate Kanidm's loopback TLS certificate";
      requiredBy = [ "kanidm.service" ];
      before = [
        "kanidm.service"
        "caddy.service"
      ];
      path = [ pkgs.openssl ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "kanidm-tls";
      };
      script = ''
        # Keep the existing certificate unless it expires within 30 days, or
        # doesn't match the current address
        if [ -s ${tlsKey} ] \
          && openssl x509 -checkend 2592000 -noout -in ${tlsCert} \
          && openssl x509 -noout -checkip ${ip} -in ${tlsCert} | grep -q "does match"; then
          exit 0
        fi

        openssl req -x509 -nodes -days 3650 -config ${tlsConfig} \
          -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
          -keyout ${tlsKey}.new -out ${tlsCert}.new
        chown kanidm:kanidm ${tlsKey}.new
        chmod 0400 ${tlsKey}.new
        chmod 0444 ${tlsCert}.new
        mv ${tlsKey}.new ${tlsKey}
        mv ${tlsCert}.new ${tlsCert}

        # Pick up the new certificate if already running. --no-block, as
        # kanidm is ordered after this unit
        systemctl --no-block try-restart kanidm.service
        systemctl --no-block try-reload-or-restart caddy.service
      '';
    };

    # Settings that Kanidm's migrations and provisioning can't express. Logs in
    # by resetting the admin accounts' passwords through kanidmd's local admin
    # socket, like the NixOS provisioning does, so no admin passwords are stored.
    kanidm-bootstrap = {
      description = "Apply Kanidm settings that can't be declared";
      wantedBy = [ "kanidm.service" ];
      partOf = [ "kanidm.service" ];
      # Connects through Caddy, using the URL in /etc/kanidm/config
      after = [
        "kanidm.service"
        "caddy.service"
      ];
      path = [
        package
        pkgs.jq
      ];
      serviceConfig = hardening // {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "kanidm";
        Group = "kanidm";
        StateDirectory = "kanidm-bootstrap";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "kanidm-bootstrap";
        RuntimeDirectoryMode = "0700";
        ReadWritePaths = [ "-/run/kanidmd" ];
      };
      script = ''
        # The CLI always creates ~/.cache for its session tokens, even when
        # KANIDM_TOKEN_CACHE_PATH is set (why), so give it a writable home
        export HOME="$RUNTIME_DIRECTORY"

        login() {
          local password
          password=$(kanidmd scripting recover-account "$1" -c /etc/kanidm/server.toml | jq -er .output)
          KANIDM_PASSWORD="$password" kanidm login -D "$1" >/dev/null
        }

        login admin
        kanidm system domain set-allow-account-recovery true -D admin

        login idm_admin
        # Asserting this membership in a migration didn't persist, so it's
        # re-applied here on every start. Adding an existing member is a no-op.
        kanidm group add-members idm_message_senders mail-sender -D idm_admin >/dev/null

        if [ ! -s ${mailSenderToken} ]; then
          umask 077
          kanidm service-account api-token generate mail-sender mail-sender --readwrite \
            -D idm_admin -o json | jq -er .result > ${mailSenderToken}.tmp
          mv ${mailSenderToken}.tmp ${mailSenderToken}
        fi
      '';
    };

    kanidm-mail-sender = {
      description = "Kanidm mail sender";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires = [ "kanidm-bootstrap.service" ];
      after = [
        "network-online.target"
        "kanidm-bootstrap.service"
        "caddy.service"
      ];
      script = ''
        umask 077
        config="$RUNTIME_DIRECTORY/config.toml"
        {
          cat ${mailSenderConfig}
          printf 'token = "%s"\nmail_password = "%s"\n' \
            "$(< "$CREDENTIALS_DIRECTORY/token")" \
            "$(< "$CREDENTIALS_DIRECTORY/smtp")"
        } > "$config"

        exec ${package}/bin/kanidm-mail-sender \
          --client-config /etc/kanidm/config \
          --mail-sender-config "$config"
      '';
      serviceConfig = hardening // {
        DynamicUser = true;
        LoadCredential = [
          "token:${mailSenderToken}"
          "smtp:${config.age.secrets."smtpPassword.age".path}"
        ];
        RuntimeDirectory = "kanidm-mail-sender";
        RuntimeDirectoryMode = "0700";
        Restart = "always";
        RestartSec = 10;
      };
    };
  };
}
