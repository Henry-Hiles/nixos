{
  services.caddy = {
    enable = true;
    email = "henry@henryhiles.com";
  };
  networking.firewall.allowedTCPPorts = [2200 443];
}
