{
  pkgs,
  inputs,
  config,
  ...
}: let
  settings = {
    appservice = {
      as_token = "$CUSTOM_AS_TOKEN";
      hs_token = "$CUSTOM_HS_TOKEN";
    };

    backfill = {
      enabled = true;
      max_initial_messages = 50;
      max_catchup_messages = 20;
      unread_hours_threshold = 300;
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
        config.services.grapevine.settings.server_name = "user";
        "@quadradical:${config.services.grapevine.settings.server_name}" = "admin";
      };
    };
  };
in {
  imports = [inputs.nix-matrix-appservices.nixosModule];

  services.matrix-appservices.services.whatsapp = {
    port = 8081;
    format = "mautrix-go";
    serviceConfig.EnvironmentFile = config.age.secrets."whatsapp.age".path;
    package = pkgs.mautrix-whatsapp.override {withGoolm = true;};
    inherit settings;
  };
}
