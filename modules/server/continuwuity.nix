{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.quad.matrix = {
    enable = lib.mkEnableOption "matrix";

    domain = lib.mkOption { type = lib.types.str; };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.toml { }).type;
      };
      default = { };
    };
  };

  config = {
    systemd.services.caddy.serviceConfig.SupplementaryGroups = [
      config.services.matrix-continuwuity.group
    ];

    services =
      let
        subdomain = "matrix.${config.quad.matrix.domain}";
        socket = "/var/run/continuwuity/continuwuity.sock";
      in
      {
        matrix-continuwuity = {
          enable = config.quad.matrix.enable;
          package = inputs.continuwuity.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings.global = lib.recursiveUpdate {
            server_name = config.quad.matrix.domain;
            unix_socket_path = socket;

            new_user_displayname_suffix = "";

            forbidden_remote_server_names = [ ];
            ignore_messages_from_server_names = [ ];

            trusted_servers = [
              "starstruck.systems"
              "maunium.net"
              "unredacted.org"
              "matrix.org"
            ];

            startup_netburst = false;
            admins_from_room = false;

            url_preview_domain_explicit_allowlist = [ "*" ];
            url_preview_max_spider_size = 2097152;

            cache_capacity_modifier = 1.5;
            db_cache_capacity_mb = 4096;
            allow_sticky_events = true;

            allow_prometheus_metrics = true;

            max_request_size = 256000000;

            dns_cache_entries = 0;

            allow_public_room_directory_over_federation = true;
            lockdown_public_room_directory = true;

            allow_incoming_presence = false;
            allow_outgoing_presence = false;
            allow_local_presence = false;

            well_known = {
              client = "https://${subdomain}";
              server = "${subdomain}:443";
            };
          } config.quad.matrix.settings;
        };

        caddy.virtualHosts."${subdomain}".extraConfig = ''
          handle /_continuwuity/metrics {
            respond 404
          }

          handle {
            reverse_proxy unix/${socket}
          }
        '';
      };
  };
}
