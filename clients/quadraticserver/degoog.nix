{ inputs, config, ... }: {
  imports = [ inputs.degoog.nixosModules.default ];
  services = {
    degoog = {
      enable = true;
      port = 8081;

      publicInstance = true;
    };

    caddy.authedHosts."search.federated.nexus" =
      "reverse_proxy 127.0.0.1:${toString config.services.degoog.port}";
  };
}
