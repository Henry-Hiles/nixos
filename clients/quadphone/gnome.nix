{inputs, ...}: {
  imports = [inputs.nixpkgs-gnome-mobile.nixosModules.gnome-mobile];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };
}
