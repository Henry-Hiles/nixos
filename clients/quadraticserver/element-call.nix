{pkgs, ...}: {
  services.caddy.virtualHosts."call.henryhiles.com". extraConfig = ''
    root * ${pkgs.element-call}
    file_server
  '';
}
