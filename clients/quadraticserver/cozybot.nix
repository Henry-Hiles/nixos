{ inputs, ... }:
{
  imports = [ inputs.cozybot.nixosModules.default ];

  services = {
    cozybot.enable = true;
    caddy.virtualHosts."cozyp.federated.nexus".extraConfig = ''
      respond /robots.txt <<EOF
        User-agent: *
        Disallow: *
        EOF 200

      reverse_proxy unix//var/run/cozybot/socket
    '';

  };
}
