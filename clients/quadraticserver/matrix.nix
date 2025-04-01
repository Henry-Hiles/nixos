{inputs, ...}: {
  imports = [inputs.grapevine.nixosModules.default];
  networking.firewall.allowedTCPPorts = [8448];

  services = let
    domain = "matrix.henryhiles.com";
    # socket = "/run/grapvine/socket";
  in {
    grapevine = {
      enable = true;
      settings = {
        server_name = "henryhiles.com";
        database.backend = "rocksdb";

        federation = {
          max_concurrent_requests = 10000;
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
      extraConfig = "reverse_proxy 127.0.0.3:6167";
    };
  };
}
