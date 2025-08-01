{
  inputs,
  config,
  ...
}: {
  imports = [inputs.matrixoidc.nixosModules.default];

  services = let
    socket = "/var/run/matrixoidc/socket";
    domain = "auth.federated.nexus";
  in {
    matrixoidc = {
      enable = true;
      jwtSecretFile = config.age.secrets."oidcJwtSecret.age".path;
      args = ["--socket" socket "--homeserver" config.services.grapevine.settings.server_discovery.client.base_url "--issuer" "https://${domain}" "--authorizeEndpoint" "https://federated.nexus/login" "--serviceDomain" "federated.nexus"];
      group = "caddy";
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
  };
}
