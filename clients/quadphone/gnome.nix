{
  inputs,
  crossPkgs,
  ...
}: {
  nixpkgs.overlays = [(self: super: inputs.gnome-mobile.overlays.default self crossPkgs)];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

  services.logind = {
    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
  };
}
