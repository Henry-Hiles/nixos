{pkgs, ...}: {
  environment = {
    systemPackages = [pkgs.mangohud];
    sessionVariables = {
      MANGOHUD = "1";
      MANGOHUD_CONFIGFILE = ./mangohud.conf;
    };
  };
}
