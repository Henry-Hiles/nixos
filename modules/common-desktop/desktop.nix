{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.GSK_RENDERER = "ngl";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = "us";
  };
}
