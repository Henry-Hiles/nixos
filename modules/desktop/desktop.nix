{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.displayManager = {
    gdm.enable = true;
    gnome.enable = true;
  };
}
