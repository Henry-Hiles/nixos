{pkgs, ...}: {
  wrappers.mangohud = {
    basePackage = pkgs.mangohud;
    env.MANGOHUD_CONFIGFILE.value = ./mangohud.conf;
  };
}