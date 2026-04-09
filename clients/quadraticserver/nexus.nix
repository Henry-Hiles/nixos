{
  services.caddy.virtualHosts."nexus.federated.nexus".extraConfig =
    "redir https://git.federated.nexus/Nexus/nexus permanent";
}
