{
  services = let
    domain = "vault.henryhiles.com";
  in {
    vaultwarden = {
      enable = true;
      config = {
        domain = "https://${domain}";
        signupsAllowed = false;
        passwordHintsAllowed = false;
        rocketAddress = "127.0.0.2";
      };
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy 127.0.0.2:8000";
  };
}
