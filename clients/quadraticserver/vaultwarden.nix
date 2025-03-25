{
  services = let
    domain = "vaultwarden.henryhiles.com";
  in {
    vaultwarden = {
      enable = true;
      config = {
        domain = "https://${domain}";
        signupsAllowed = false;
        passwordHintsAllowed = false;
        rocketAddress = "127.0.0.1";
      };
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy localhost:8000";
  };
}
