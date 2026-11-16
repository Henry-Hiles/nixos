{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.nexusbot.nixosModules.default ];

  services =
    let
      socket = "/var/run/nexusbot/socket";
      domain = "register.federated.nexus";
    in
    {
      nexusbot = {
        enable = true;
        # An access token from a password login, made before continuwuity switched to Kanidm logins
        botTokenFile = config.age.secrets."botToken.age".path;
        args = [
          "--socket"
          socket
          "--homeserver"
          config.services.matrix-continuwuity.settings.global.well_known.client
          "--adminRoom"
          "#admins:federated.nexus"
          "--successUri"
          "https://federated.nexus/success"
          "--failureUri"
          "https://federated.nexus/failure"
        ];
        group = "caddy";
      };

      caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy unix/${socket}";
    };
}
