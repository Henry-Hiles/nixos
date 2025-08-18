{inputs, ...}: {
  nixpkgs.overlays = [inputs.gnome-mobile.overlays.default];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

  services.logind = {
    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
  };
}
