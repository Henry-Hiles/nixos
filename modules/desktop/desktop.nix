{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
  };

  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
