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
    systemd.services.continuwuity.serviceConfig = {
      TimeoutStartSec = 30;
      Restart = lib.mkForce "always";
      ExecStartPost = "/bin/sh -c 'until ${lib.getExe pkgs.curl} -s -f https://matrix.federated.nexus/.well-known/matrix/client; do sleep 1; done'";
    };
    services =
      let
        subdomain = "matrix.${config.quad.matrix.domain}";
        socket = "/var/run/continuwuity/continuwuity.sock";
      in
      {
        matrix-continuwuity = {
          enable = config.quad.matrix.enable;
          package = inputs.continuwuity.packages.${pkgs.stdenv.hostPlatform.system}.default;
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

            allow_local_presence = false;
            allow_incoming_presence = false;
            allow_outgoing_presence = false;

            db_cache_capacity_mb = 512;

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
