{inputs, ...}: {
  imports = [inputs.grapevine.nixosModules.default];
  networking.firewall.allowedTCPPorts = [8448];

  services = let
    domain = "federated.nexus";
    subdomain = "matrix.${domain}";
  in {
    grapevine = {
      enable = true;
      settings = {
        server_name = domain;
        database.backend = "rocksdb";
        federation = {
          max_concurrent_requests = 10000;
          self_test = false;
        };

        server_discovery = {
          server.authority = "${subdomain}:443";
          client.base_url = "https://${subdomain}";
        };

        listen = [
          {
            type = "tcp";
            address = "127.0.0.3";
          }
        ];
      };
    };

    caddy.virtualHosts."${subdomain}" = {
      serverAliases = ["${subdomain}:8448"];
      extraConfig = "reverse_proxy 127.0.0.3:6167";
    };
  };
}
