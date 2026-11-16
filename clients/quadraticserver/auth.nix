{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.matrixoidc.nixosModules.default ];

  services =
    let
      socket = "/var/run/matrixoidc/socket";
      domain = "auth.federated.nexus";
    in
    {
      matrixoidc = {
        enable = true;
        # A snapshot from before the cutover, made by ~/Documents/fednex-password-hashes.sh
        passwordHashesFile = "/var/lib/matrix-password-hashes/hashes";
        args = [
          "--socket"
          socket
          "--homeserver"
          config.services.matrix-continuwuity.settings.global.well_known.client
          "--migrateUri"
          "https://federated.nexus/migrate/"
          "--serviceDomain"
          config.quad.matrix.domain
        ];
        group = "caddy";
      };

      caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
    };
}
