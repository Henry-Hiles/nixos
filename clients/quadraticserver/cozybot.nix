{ inputs, ... }:
{
  imports = [ inputs.cozybot.nixosModules.default ];

  services = {
    cozybot.enable = true;
    caddy.virtualHosts."cozyp.federated.nexus".extraConfig =
      "reverse_proxy unix//var/run/cozybot/socket";
  };
}
