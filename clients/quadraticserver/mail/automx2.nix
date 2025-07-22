{
  lib,
  config,
  ...
}: {
  services = let
    domain = lib.head config.mailserver.domains;
    fqdn = config.mailserver.fqdn;
  in {
    caddy.virtualHosts = {
      "autoconfig.${domain}" = {
        serverAliases = ["autodiscover.${domain}"];
        extraConfig = let
          proxy = "reverse_proxy 127.0.0.1:${toString config.services.automx2.port}";
        in ''
          route {
            handle_path /initdb* {
              @not_local not remote_ip 127.0.0.1
              abort @not_local
              ${proxy}
            }

            ${proxy}
           }
        '';
      };
    };
    automx2 = {
      enable = true;
      inherit domain;
      settings = {
        provider = "Federated Nexus";
        domains = [domain];
        servers = [
          {
            type = "imap";
            name = fqdn;
          }
          {
            type = "smtp";
            name = fqdn;
          }
        ];
      };
    };
  };
}
