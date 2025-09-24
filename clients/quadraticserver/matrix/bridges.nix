{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  client = config.services.matrix-continuwuity.settings.global.well_known.client;
  server_name = config.services.matrix-continuwuity.settings.global.server_name;

  settings = {
    backfill.enabled = true;

    homeserver = {
      domain = server_name;
      address = client;
    };

    encryption = {
      allow = true;
      default = true;
      pickle_key = "generate";
    };

    bridge.permissions = {
      "${server_name}" = "user";
      "@quadradical:${server_name}" = "admin";
    };
  };
in
{
  imports = [
    inputs.nix-matrix-appservices.nixosModule
    inputs.ooye.modules.default
  ];

  services =
    let
      domain = "ooye.federated.nexus";
    in
    {
      matrix-appservices.services.gmessages = {
        host = "127.0.0.5";
        serviceConfig.EnvironmentFile = config.age.secrets."gmessages.age".path;
        format = "mautrix-go";
        port = 8000;
        package = pkgs.mautrix-gmessages.override { withGoolm = true; };
        inherit settings;
      };

      mautrix-whatsapp = {
        enable = true;
        package = pkgs.mautrix-whatsapp.override { withGoolm = true; };
        settings = settings // {
          appservice.hostname = "127.0.0.4";
        };
        environmentFile = config.age.secrets."whatsapp.age".path;
      };

      matrix-ooye = {
        enable = true;
        homeserver = client;
        homeserverName = "federated.nexus";
        discordTokenPath = config.age.secrets."discordToken.age".path;
        discordClientSecretPath = config.age.secrets."discordClientSecret.age".path;
        socket = "8081";
        bridgeOrigin = "https://${domain}";
      };

      caddy.virtualHosts."${domain}".extraConfig =
        "reverse_proxy 127.0.0.1:${config.services.matrix-ooye.socket}";
    };

  systemd.services.matrix-ooye.serviceConfig.Restart = lib.mkForce "always";
}
