{ inputs, config, ... }: {
  imports = [ inputs.degoog.nixosModules.default ];
  services = {
    degoog = {
      enable = true;
      configurePostgres = true;

      environment.DEGOOG_UNIX_SOCKET = "/var/run/degoog/degoog.sock";
    };

    caddy.authedHosts."search.federated.nexus" =
      "reverse_proxy unix/${config.services.degoog.environment.DEGOOG_UNIX_SOCKET}";
  };

  systemd.services.caddy.serviceConfig.SupplementaryGroups = [ "degoog" ];
}
