{ crossPkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      gnome-shell = crossPkgs.gnome-shell;
      gnome-settings-daemon-mobile = crossPkgs.gnome-settings-daemon-mobile;
      mutter = crossPkgs.mutter;
    })
  ];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

  services.logind = {
    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
  };
}
