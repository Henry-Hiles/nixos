{pkgs, ...}: {
  wrappers.vesktop = {
    basePackage = pkgs.vesktop;
    env.NIXOS_OZONE_WL.value = null;
  };
}
