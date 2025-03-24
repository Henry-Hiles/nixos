{
  services = {
    vaultwarden = {
      enable = true;
      config = {
        domain = "https://vaultwarden.henryhiles.com";
        signupsAllowed = false;
        passwordHintsAllowed = false;
        rocketAddress = "127.0.0.1";
      };
    };

    caddy.virtualHosts."vaultwarden.henryhiles.com".extraConfig = "reverse_proxy 127.0.0.1:8000";
  };
}
