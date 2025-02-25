{pkgs, ...}: {
  wrappers.neofetch = {
    basePackage = pkgs.hyfetch; # Neowofetch
    flags = [
      "--config"
      ./neofetch.conf
    ];
  };
}
