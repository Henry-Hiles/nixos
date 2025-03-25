{
  services.caddy = {
    enable = true;
    email = "henry@henryhiles.com";
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
