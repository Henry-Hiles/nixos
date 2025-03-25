{config, ...}: {
  networking.firewall.allowedTCPPorts = [8448];

  services = let
    domain = "matrix.henryhiles.com";
    socket = "/run/conduwuit/socket";
  in {
    conduwuit = {
      enable = true;
      group = config.services.caddy.group;
      settings.global = {
        server_name = "henryhiles.com";
        unix_socket_path = socket;
      };
    };

    caddy.virtualHosts."${domain}" = {
      serverAliases = ["${domain}:8448"];
      extraConfig = "reverse_proxy unix/${socket}";
    };
  };
}
