{config, ...}: {
  services = {
    redlib = {
      enable = true;
      address = "127.0.0.6";
      settings.THEME = "nord";
    };

    caddy.authedHosts."auth.federated.nexus" = with config.services.redlib; "reverse_proxy ${address}:${port}";
  };
}
