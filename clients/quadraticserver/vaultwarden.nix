{
  services = {
    vaultwarden = {
      enable = true;
      config = {
        domain = "https://vaultwarden.henryhiles.com";
        signupsAllowed = false;
        rocketAddress = "127.0.0.1";
        passwordHintsAllowed = false;
      };
    };
    caddy.virtualHosts."vaultwarden.henryhiles.com".extraConfig = "reverse_proxy 127.0.0.1:8000";
  };
}
