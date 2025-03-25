{config, ...}: {
  services = {
    radicale = {
      enable = true;
      settings.auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets."caldavUsers.age".path;
        htpasswd_encryption = "htpasswd";
      };
    };
    caddy.virtualHosts."dav.henryhiles.com".extraConfig = "reverse_proxy localhost:5232";
  };
}
