{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  systemd.services.continuwuity.serviceConfig.Restart = lib.mkForce "always";

  services =
    let
      domain = "federated.nexus";
      subdomain = "matrix.${domain}";
      socket = "/var/run/continuwuity/continuwuity.sock";
    in
    {
      matrix-continuwuity = {
        enable = false;
        package = inputs.continuwuity.packages.${pkgs.system}.default;
        group = "caddy";
        settings.global = {
          server_name = domain;
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
            support_email = "henry@henryhiles.com";
            support_mxid = "@quadradical:${domain}";
          };
        };
      };

      caddy.virtualHosts."${subdomain}".extraConfig = "reverse_proxy unix/${socket}";
    };
}
