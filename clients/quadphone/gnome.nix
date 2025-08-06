{inputs, ...}: {
  imports = [inputs.gnome-mobile.nixosModules.gnome-mobile];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };
}
