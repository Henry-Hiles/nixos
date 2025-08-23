{config, ...}: {
  services = {
    redlib = {
      enable = true;
      address = "127.0.0.6";
      port = 8082;
      settings.REDLIB_DEFAULT_THEME = "nord";
    };

    caddy.authedHosts."redlib.federated.nexus" = with config.services.redlib; "reverse_proxy ${address}:${toString port}";
  };

  systemd.services.redlib.serviceConfig.Restart = "always";
}
