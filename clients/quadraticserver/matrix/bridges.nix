{
  pkgs,
  inputs,
  config,
  ...
}: let
  settings = {
    backfill.enabled = true;

    appservice = {
      as_token = "$CUSTOM_AS_TOKEN";
      hs_token = "$CUSTOM_HS_TOKEN";
    };

    homeserver = {
      domain = config.services.grapevine.settings.server_name;
      address = config.services.grapevine.settings.server_discovery.client.base_url;
    };

    bridge = {
      encryption = {
        allow = true;
        default = true;
        require = false;
      };
      permissions = {
        "${config.services.grapevine.settings.server_name}" = "user";
        "@quadradical:${config.services.grapevine.settings.server_name}" = "admin";
      };
    };
  };
in {
  imports = [inputs.nix-matrix-appservices.nixosModule inputs.ooye.modules.default];

  services = let
    domain = "ooye.federated.nexus";
  in {
    matrix-appservices.services = builtins.mapAttrs (name: value:
      value
      // {
        inherit settings;
        format = "mautrix-go";
        port = 8000;
        package = value.package.override {withGoolm = true;};
      }) {
      whatsapp = {
        host = "127.0.0.4";
        serviceConfig.EnvironmentFile = config.age.secrets."whatsapp.age".path;
        package = pkgs.mautrix-whatsapp;
      };
      gmessages = {
        host = "127.0.0.5";
        serviceConfig.EnvironmentFile = config.age.secrets."gmessages.age".path;
        package = pkgs.mautrix-gmessages;
      };
    };

    matrix-ooye = {
      enable = true;
      homeserver = config.services.grapevine.settings.server_discovery.client.base_url;
      homeserverName = "federated.nexus";
      discordTokenPath = config.age.secrets."discordToken.age".path;
      discordClientSecretPath = config.age.secrets."discordClientSecret.age".path;
      socket = "8081";
      bridgeOrigin = "https://${domain}";
    };

    caddy.virtualHosts."${domain}".extraConfig = "reverse_proxy 127.0.0.1:${config.services.matrix-ooye.socket}";
  };
}
