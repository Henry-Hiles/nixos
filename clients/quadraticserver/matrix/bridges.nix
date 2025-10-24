{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  client = config.services.matrix-continuwuity.settings.global.well_known.client;
  domain = config.quad.matrix.domain;

  settings = {
    backfill.enabled = true;

    homeserver = {
      inherit domain;
      address = client;
    };

    encryption = {
      allow = true;
      default = true;
      pickle_key = "generate";
    };

    bridge.permissions = {
      "${domain}" = "user";
      "@quadradical:${domain}" = "admin";
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
        settings = settings // {
          appservice = {
            as_token = "$CUSTOM_AS_TOKEN";
            hs_token = "$CUSTOM_HS_TOKEN";
          };
        };
      };

      mautrix-whatsapp = {
        enable = false;
        package = pkgs.mautrix-whatsapp.override { withGoolm = true; };
        settings = settings // {
          appservice.hostname = "127.0.0.4";
        };
        environmentFile = config.age.secrets."whatsapp.age".path;
      };

      matrix-ooye = {
        enable = true;
        homeserver = client;
        homeserverName = domain;
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
