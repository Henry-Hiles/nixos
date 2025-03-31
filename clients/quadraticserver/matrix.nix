{inputs, ...}: {
  imports = [inputs.grapevine.nixosModules.default];
  networking.firewall.allowedTCPPorts = [8448];

  systemd.tmpfiles.rules = [
    "d /var/lib/private/matrix-conduit 0770 conduit conduit"
    "d /var/lib/private/matrix-conduit/database 0770 conduit conduit"
    "d /var/lib/private/matrix-conduit/media 0770 conduit conduit"
    "L /var/lib/matrix-conduit /var/lib/private/matrix-conduit"
  ];

  users = {
    groups.conduit = {};
    users.conduit = {
      isSystemUser = true;
      group = "conduit";
    };
  };

  systemd.services.grapevine.serviceConfig = {
    User = "conduit";
    Group = "conduit";
  };

  services = let
    domain = "matrix.henryhiles.com";
    # socket = "/run/grapvine/socket";
  in {
    grapevine = {
      enable = true;
      settings = {
        server_name = domain;
        conduit_compat = true;
        database.backend = "rocksdb";

        allow_registration = true;
        registration_token = "test";

        federation = {
          max_concurrent_requests = 10000;
          self_test = false;
        };

        server_discovery = {
          server.authority = "${domain}:443";
          client.base_url = "https://${domain}";
        };

        listen = [
          {
            type = "tcp";
            address = "127.0.0.3";
          }
        ];
      };
    };

    caddy.virtualHosts."${domain}" = {
      serverAliases = ["${domain}:8448"];
      extraConfig = "reverse_proxy 127.0.0.3";
    };
  };
}
