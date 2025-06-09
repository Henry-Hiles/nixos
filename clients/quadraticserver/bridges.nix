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
  imports = [inputs.nix-matrix-appservices.nixosModule];

  services.matrix-appservices.services = builtins.mapAttrs (name: value:
    value
    // {
      inherit settings;
      format = "mautrix-go";
      package = value.package.override {withGoolm = true;};
    }) {
    whatsapp = {
      port = 29318;
      serviceConfig.EnvironmentFile = config.age.secrets."whatsapp.age".path;
      package = pkgs.mautrix-whatsapp;
    };
  };
}
