{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.quad.matrix = {
    enable = lib.mkEnableOption "matrix";

    domain = lib.mkOption { type = lib.types.string; };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.toml { }).type;

      };
      default = { };
    };
  };

  config = {
    systemd.services.continuwuity.serviceConfig.Restart = lib.mkForce "always";
    services =
      let
        subdomain = "matrix.${config.quad.matrix.domain}";
        socket = "/var/run/continuwuity/continuwuity.sock";
      in
      {
        matrix-continuwuity = {
          enable = config.quad.matrix.enable;
          group = "caddy";
          settings.global = config.quad.matrix.settings // {
            server_name = config.quad.matrix.domain;
            unix_socket_path = socket;
            new_user_displayname_suffix = "";
            allow_public_room_directory_over_federation = true;
            trusted_servers = [
              "matrix.org"
              "tchncs.de"
              "maunium.net"
            ];
            ignore_messages_from_server_names = [ ];
            url_preview_domain_explicit_allowlist = [ "*" ];

            well_known = {
              client = "https://${subdomain}";
              server = "${subdomain}:443";
            };
          };
        };

        caddy.virtualHosts."${subdomain}".extraConfig = "reverse_proxy unix/${socket}";
      };
  };
}
