{pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.mangohud];
    sessionVariables.MANGOHUD_CONFIGFILE = ./mangohud.conf;
  };
}
