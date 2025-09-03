{pkgs, ...}: {
  services.caddy.virtualHosts."app.federated.nexus".extraConfig = ''
    root ${pkgs.cinny}
    file_server
  '';
}
