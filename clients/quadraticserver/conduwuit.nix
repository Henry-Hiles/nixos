{
  networking.firewall.allowedTCPPorts = [8448];

  services = {
    caddy.virtualHosts."matrix.henryhiles.com" = {
      serverAliases = ["matrix.henryhiles.com:8448"];
      extraConfig = "reverse_proxy unix//run/conduwuit/socket";
    };

    conduwuit = {
      enable = true;
      group = "caddy";
      settings.global = {
        server_name = "henryhiles.com";
        unix_socket_path = "/run/conduwuit/socket";
      };
    };
  };
}
