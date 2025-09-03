{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.grapevine.nixosModules.default];
  networking.firewall.allowedTCPPorts = [8448];

  systemd.services.grapevine.serviceConfig.Restart = lib.mkForce "always";

  services = let
    domain = "federated.nexus";
    subdomain = "matrix.${domain}";
    address = "127.0.0.3";
  in {
    grapevine = {
      enable = true;
      settings = {
        server_name = domain;
        database.backend = "rocksdb";
        media.allow_unauthenticated_access = true;
        federation = {
          max_concurrent_requests = 10000;
          self_test = false;
          trusted_servers = ["matrix.org" "tchncs.de" "maunium.net"];
        };

        server_discovery = {
          server.authority = "${subdomain}:443";
          client.base_url = "https://${subdomain}";
        };

        listen = [
          {
            type = "tcp";
            inherit address;
          }
        ];
      };
    };

    caddy.virtualHosts."${subdomain}".extraConfig = "reverse_proxy ${address}:6167";
  };
}
