{pkgs, ...}: {
  wrappers.neofetch = {
    basePackage = pkgs.hyfetch;
    flags = [
      "--config"
      ./neofetch.conf
    ];
  };
}
