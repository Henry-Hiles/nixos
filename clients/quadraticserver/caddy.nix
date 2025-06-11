{
  services.caddy = {
    enable = true;
    email = "henry@henryhiles.com";
  };
  networking.firewall.allowedTCPPorts = [2222 443 8448]; # Git SSH, HTTPS, and Matrix
}
